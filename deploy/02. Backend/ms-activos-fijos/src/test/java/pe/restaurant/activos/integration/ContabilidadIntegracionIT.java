package pe.restaurant.activos.integration;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.mockito.ArgumentCaptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.mock.mockito.MockBean;
import pe.restaurant.activos.client.ContabilidadAsientosClient;
import pe.restaurant.activos.client.dto.contabilidad.AsientoRequest;
import pe.restaurant.activos.dto.IntegracionContabilidadResult;
import pe.restaurant.activos.entity.AfCalculoCntbl;
import pe.restaurant.activos.entity.AfTraslado;
import pe.restaurant.activos.integracion.AfIntegracionContableModulo;
import pe.restaurant.activos.repository.AfCalculoCntblRepository;
import pe.restaurant.activos.repository.AfTrasladoRepository;
import pe.restaurant.activos.service.ContabilidadIntegracionService;
import pe.restaurant.activos.testdata.ActivosTestDataFactory;
import pe.restaurant.activos.support.ActivosIntegrationTest;
import pe.restaurant.activos.support.ActivosItSeed;
import pe.restaurant.activos.support.JdbcContabilidadAsientosClient;

import javax.sql.DataSource;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assumptions.assumeTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * Integración con BD tenant: {@link ContabilidadAsientosClient} (Feign) se sustituye con
 * {@link JdbcContabilidadAsientosClient} vía {@code @MockBean} — patrón acordado para servicio externo.
 * Datos de activos: {@link ActivosTestDataFactory} (rol B), sin Mockito en dominio.
 *
 * <p>Ejecutar: {@code mvn test -pl ms-activos-fijos -Dactivos.it=true
 * -Dtest=ContabilidadIntegracionIT,ActivosTestDataFactorySmokeIT}</p>
 */
@ActivosIntegrationTest
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class ContabilidadIntegracionIT {

    @Autowired
    private ContabilidadIntegracionService contabilidadIntegracionService;

    @Autowired
    private ActivosTestDataFactory testDataFactory;

    @Autowired
    private AfCalculoCntblRepository calculoRepository;

    @Autowired
    private AfTrasladoRepository trasladoRepository;

    @Autowired
    private DataSource dataSource;

    @MockBean
    private ContabilidadAsientosClient contabilidadAsientosClient;

    private JdbcContabilidadAsientosClient jdbcContabilidad;

    @BeforeEach
    void seedAndWireContabilidad() {
        ActivosItSeed.standard(dataSource, testDataFactory);
        assumeTrue(testDataFactory.isActivosSchemaReady(),
                "Tenant sin esquema activos completo (DDL 08-activos + migraciones ms-activos-fijos)");
        testDataFactory.resetDepreciacionContableFactoryState();
        testDataFactory.resetTrasladoContableFactoryState();

        jdbcContabilidad = new JdbcContabilidadAsientosClient(dataSource);
        when(contabilidadAsientosClient.buscarPorOrigen(anyString(), anyLong()))
                .thenAnswer(inv -> jdbcContabilidad.buscarPorOrigen(inv.getArgument(0), inv.getArgument(1)));
        when(contabilidadAsientosClient.crear(any(AsientoRequest.class)))
                .thenAnswer(inv -> jdbcContabilidad.crear(inv.getArgument(0)));
    }

    @Test
    @Order(1)
    void contabilizarDepreciacion_persisteAsientoEnCalculoYEnContabilidad() {
        Long calculoId = testDataFactory.resolveCalculoDepreciacionContableId();
        assertThat(calculoRepository.findById(calculoId).orElseThrow().getCntblAsientoId()).isNull();

        IntegracionContabilidadResult result = contabilidadIntegracionService.contabilizarDepreciacion(calculoId);

        assertThat(result.getAsientoId()).isPositive();
        assertThat(result.getModuloOrigen()).isEqualTo(AfIntegracionContableModulo.MODULO);
        assertThat(result.isYaExistia()).isFalse();
        assertThat(calculoRepository.findById(calculoId).orElseThrow().getCntblAsientoId())
                .isEqualTo(result.getAsientoId());

        assertThat(testDataFactory.countCntblAsientoPorOrigen(
                AfIntegracionContableModulo.MODULO, calculoId)).isEqualTo(1);
        int lineasDetalle = jdbcContabilidad.countAsientoDetalle(result.getAsientoId());
        assertThat(lineasDetalle).isGreaterThanOrEqualTo(2);

        ArgumentCaptor<AsientoRequest> captor = ArgumentCaptor.forClass(AsientoRequest.class);
        verify(contabilidadAsientosClient).crear(captor.capture());
        assertThat(captor.getValue().getModuloOrigen()).isEqualTo(AfIntegracionContableModulo.MODULO);
        assertThat(captor.getValue().getDocumentoOrigenId()).isEqualTo(calculoId);
        assertThat(captor.getValue().getDetalles()).hasSizeGreaterThanOrEqualTo(2);
        assertThat(captor.getValue().getDetalles()).hasSize(lineasDetalle);
    }

    @Test
    @Order(2)
    void contabilizarDepreciacion_idempotentePorBuscarOrigenRemoto() {
        Long calculoId = testDataFactory.resolveCalculoDepreciacionContableId();
        IntegracionContabilidadResult first = contabilidadIntegracionService.contabilizarDepreciacion(calculoId);
        assertThat(first.isYaExistia()).isFalse();

        IntegracionContabilidadResult second = contabilidadIntegracionService.contabilizarDepreciacion(calculoId);

        assertThat(second.getAsientoId()).isEqualTo(first.getAsientoId());
        assertThat(second.isYaExistia()).isTrue();
        assertThat(testDataFactory.countCntblAsientoPorOrigen(
                AfIntegracionContableModulo.MODULO, calculoId)).isEqualTo(1);
    }

    @Test
    @Order(4)
    void contabilizarDepreciacion_idempotenteSiCalculoYaTieneAsiento() {
        Long calculoId = testDataFactory.resolveCalculoDepreciacionContableId();
        AfCalculoCntbl calculo = calculoRepository.findById(calculoId).orElseThrow();
        calculo.setCntblAsientoId(88_888L);
        calculoRepository.save(calculo);

        IntegracionContabilidadResult result = contabilidadIntegracionService.contabilizarDepreciacion(calculoId);

        assertThat(result.getAsientoId()).isEqualTo(88_888L);
        assertThat(result.isYaExistia()).isTrue();
        verify(contabilidadAsientosClient, never()).crear(any());
    }

    @Test
    @Order(3)
    void contabilizarTraslado_persisteAsientoEnTrasladoYEnContabilidad() {
        assumeTrue(testDataFactory.hasTrasladoContableEjecutado(),
                "Sin traslado EJECUTADO con CC distintos (centros_costo + columnas traslado en BD)");

        Long trasladoId = testDataFactory.resolveTrasladoEjecutadoContableId();
        AfTraslado traslado = trasladoRepository.findById(trasladoId).orElseThrow();
        assertThat(traslado.getEstado()).isEqualTo("EJECUTADO");
        assertThat(traslado.getCntblAsientoId()).isNull();

        IntegracionContabilidadResult result = contabilidadIntegracionService.contabilizarTraslado(trasladoId);

        assertThat(result.getAsientoId()).isPositive();
        assertThat(result.getModuloOrigen()).isEqualTo(AfIntegracionContableModulo.MODULO);
        assertThat(trasladoRepository.findById(trasladoId).orElseThrow().getCntblAsientoId())
                .isEqualTo(result.getAsientoId());
        assertThat(testDataFactory.countCntblAsientoPorOrigen(
                AfIntegracionContableModulo.MODULO, trasladoId)).isGreaterThanOrEqualTo(1);
    }

    @Test
    @Order(5)
    void asientosYActivos_quedanPersistidosDirectamenteEnBd() {
        Long calculoId = testDataFactory.resolveCalculoDepreciacionContableId();
        testDataFactory.resetDepreciacionContableFactoryState();

        IntegracionContabilidadResult result = contabilidadIntegracionService.contabilizarDepreciacion(calculoId);

        assertThat(result.getAsientoId()).isPositive();
        assertThat(testDataFactory.countCntblAsientoPorOrigen(
                AfIntegracionContableModulo.MODULO, calculoId)).isEqualTo(1);
        assertThat(jdbcContabilidad.countAsientoDetalle(result.getAsientoId())).isGreaterThanOrEqualTo(2);
        assertThat(calculoRepository.findById(calculoId).orElseThrow().getCntblAsientoId())
                .isEqualTo(result.getAsientoId());
        assertThat(testDataFactory.countMaestroFactoryEnBd()).isEqualTo(1);
    }
}
