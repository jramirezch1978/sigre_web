package pe.restaurant.activos.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InOrder;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.activos.client.ContabilidadAsientosClient;
import pe.restaurant.activos.client.dto.contabilidad.AsientoRequest;
import pe.restaurant.activos.config.IntegracionProperties;
import pe.restaurant.activos.dto.IntegracionContabilidadResult;
import pe.restaurant.activos.entity.AfCalculoCntbl;
import pe.restaurant.activos.integracion.AfIntegracionContableModulo;
import pe.restaurant.activos.repository.AfCalculoCntblRepository;
import pe.restaurant.activos.repository.AfMaestroCcDistribRepository;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.repository.AfMatrizSubClaseRepository;
import pe.restaurant.activos.service.AfHistorialRegistroService;
import java.util.Collections;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.security.TenantContext;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.inOrder;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static pe.restaurant.activos.TestDataFactory.*;

/**
 * Valida que la integración contable de activos fijos consume los endpoints Feign
 * {@code POST /api/contabilidad/asientos} y {@code GET .../asientos/buscar}.
 */
@ExtendWith(MockitoExtension.class)
class ContabilidadAsientosEndpointConsumoTest {

    @Mock private IntegracionProperties integracionProperties;
    @Mock private ContabilidadAsientosClient contabilidadAsientosClient;
    @Mock private AfCalculoCntblRepository calculoRepository;
    @Mock private AfMaestroRepository maestroRepository;
    @Mock private AfMatrizSubClaseRepository matrizRepository;
    @Mock private AfMaestroCcDistribRepository maestroCcDistribRepository;
    @Mock private AfHistorialRegistroService historialRegistroService;

    @InjectMocks private ContabilidadIntegracionServiceImpl service;

    private IntegracionProperties.Contabilidad cfg;

    @BeforeEach
    void setUp() {
        cfg = new IntegracionProperties.Contabilidad();
        cfg.setHabilitada(true);
        cfg.setLibroId(1L);
        cfg.setTipoAsiento("03");
        cfg.setMonedaId(1L);
        when(integracionProperties.getContabilidad()).thenReturn(cfg);
        TenantContext.setUsuarioId(1L);
    }

    private void stubDepreciacionMaestroYMatriz() {
        when(maestroRepository.findById(10L)).thenReturn(Optional.of(afMaestro(10L)));
        when(matrizRepository.findByAfSubClaseId(2L)).thenReturn(Optional.of(afMatrizSubClaseCompleta()));
    }

    private void stubCcDistribVacio() {
        when(maestroCcDistribRepository.findByAfMaestroIdOrderByIdAsc(any())).thenReturn(Collections.emptyList());
    }

    @Nested
    @DisplayName("POST /api/contabilidad/asientos (crear)")
    class CrearAsiento {

        @Test
        void contabilizarDepreciacion_enviaModuloDocumentoYDetalles() {
            AfCalculoCntbl calculo = afCalculoDepreciacion(50L, 10L);
            when(calculoRepository.findById(50L)).thenReturn(Optional.of(calculo));
            stubDepreciacionMaestroYMatriz();
            stubCcDistribVacio();
            when(contabilidadAsientosClient.buscarPorOrigen(any(), any())).thenReturn(ApiResponse.ok(null));
            when(contabilidadAsientosClient.crear(any())).thenReturn(ApiResponse.ok(asientoResponse(900L)));
            when(calculoRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            IntegracionContabilidadResult result = service.contabilizarDepreciacion(50L);

            assertThat(result.getAsientoId()).isEqualTo(900L);
            ArgumentCaptor<AsientoRequest> captor = ArgumentCaptor.forClass(AsientoRequest.class);
            verify(contabilidadAsientosClient).crear(captor.capture());
            AsientoRequest req = captor.getValue();
            assertThat(req.getModuloOrigen()).isEqualTo(AfIntegracionContableModulo.MODULO);
            assertThat(req.getDocumentoOrigenId()).isEqualTo(50L);
            assertThat(req.getLibroId()).isEqualTo(1L);
            assertThat(req.getMonedaId()).isEqualTo(1L);
            assertThat(req.getDetalles()).hasSize(2);
        }
    }

    @Nested
    @DisplayName("GET /api/contabilidad/asientos/buscar (buscarPorOrigen)")
    class BuscarPorOrigen {

        @Test
        void contabilizarDepreciacion_consultaOrigenAntesDeCrear() {
            AfCalculoCntbl calculo = afCalculoDepreciacion(50L, 10L);
            when(calculoRepository.findById(50L)).thenReturn(Optional.of(calculo));
            stubDepreciacionMaestroYMatriz();
            stubCcDistribVacio();
            when(contabilidadAsientosClient.buscarPorOrigen(any(), any())).thenReturn(ApiResponse.ok(null));
            when(contabilidadAsientosClient.crear(any())).thenReturn(ApiResponse.ok(asientoResponse(901L)));
            when(calculoRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            service.contabilizarDepreciacion(50L);

            InOrder order = inOrder(contabilidadAsientosClient);
            order.verify(contabilidadAsientosClient).buscarPorOrigen(
                    eq(AfIntegracionContableModulo.MODULO), eq(50L));
            order.verify(contabilidadAsientosClient).crear(any());
        }

        @Test
        void contabilizarDepreciacion_siBuscarEncuentraAsiento_noCrea() {
            AfCalculoCntbl calculo = afCalculoDepreciacion(50L, 10L);
            when(calculoRepository.findById(50L)).thenReturn(Optional.of(calculo));
            stubDepreciacionMaestroYMatriz();
            when(contabilidadAsientosClient.buscarPorOrigen(
                    AfIntegracionContableModulo.MODULO, 50L))
                    .thenReturn(ApiResponse.ok(asientoResponse(777L, AfIntegracionContableModulo.MODULO, 50L)));
            when(calculoRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            IntegracionContabilidadResult result = service.contabilizarDepreciacion(50L);

            assertThat(result.getAsientoId()).isEqualTo(777L);
            assertThat(result.isYaExistia()).isTrue();
            verify(contabilidadAsientosClient).buscarPorOrigen(
                    AfIntegracionContableModulo.MODULO, 50L);
            verify(contabilidadAsientosClient, never()).crear(any());
        }

        @Test
        void consultarTrazabilidad_soloBuscarPorOrigen() {
            when(contabilidadAsientosClient.buscarPorOrigen(AfIntegracionContableModulo.MODULO, 50L))
                    .thenReturn(ApiResponse.ok(asientoResponse(100L)));

            IntegracionContabilidadResult result = service.consultarTrazabilidad(
                    AfIntegracionContableModulo.MODULO, 50L);

            assertThat(result.getAsientoId()).isEqualTo(100L);
            assertThat(result.isYaExistia()).isTrue();
            verify(contabilidadAsientosClient).buscarPorOrigen(
                    AfIntegracionContableModulo.MODULO, 50L);
            verify(contabilidadAsientosClient, never()).crear(any());
        }
    }
}
