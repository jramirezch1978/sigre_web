package pe.restaurant.activos.service.impl;

import feign.FeignException;
import feign.Request;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.activos.client.ContabilidadAsientosClient;
import pe.restaurant.activos.client.dto.contabilidad.AsientoResponse;
import pe.restaurant.activos.config.IntegracionProperties;
import pe.restaurant.activos.dto.IntegracionContabilidadResult;
import pe.restaurant.activos.entity.*;
import pe.restaurant.activos.integracion.AfIntegracionContableModulo;
import pe.restaurant.activos.repository.*;
import pe.restaurant.activos.entity.AfCalculoCntbl;
import pe.restaurant.activos.entity.AfMaestro;
import pe.restaurant.activos.entity.AfMatrizSubClase;
import pe.restaurant.activos.repository.AfAdaptacionRepository;
import pe.restaurant.activos.repository.AfCalculoCntblRepository;
import pe.restaurant.activos.repository.AfMaestroCcDistribRepository;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.repository.AfMatrizSubClaseRepository;
import pe.restaurant.activos.repository.AfPolizaActivoRepository;
import pe.restaurant.activos.repository.AfPrimaDevengoRepository;
import pe.restaurant.activos.repository.AfValuacionRepository;
import pe.restaurant.activos.repository.AfVentaRepository;
import pe.restaurant.activos.service.AfHistorialRegistroService;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Collections;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ContabilidadIntegracionServiceImplTest {

    @Mock
    private IntegracionProperties integracionProperties;
    @Mock
    private ContabilidadAsientosClient contabilidadClient;
    @Mock
    private AfAdaptacionRepository adaptacionRepository;
    @Mock
    private AfCalculoCntblRepository calculoRepository;
    @Mock
    private AfPrimaDevengoRepository devengoRepository;
    @Mock
    private AfVentaRepository ventaRepository;
    @Mock
    private AfValuacionRepository valuacionRepository;
    @Mock
    private AfMaestroRepository maestroRepository;
    @Mock
    private AfMaestroCcDistribRepository maestroCcDistribRepository;
    @Mock
    private AfMatrizSubClaseRepository matrizRepository;
    @Mock
    private AfPolizaActivoRepository polizaActivoRepository;
    @Mock
    private AfHistorialRegistroService historialRegistroService;

    @InjectMocks
    private ContabilidadIntegracionServiceImpl service;

    private IntegracionProperties.Contabilidad contabilidadCfg;

    @BeforeEach
    void setUp() {
        contabilidadCfg = new IntegracionProperties.Contabilidad();
        contabilidadCfg.setHabilitada(true);
        contabilidadCfg.setLibroId(1L);
        contabilidadCfg.setTipoAsiento("03");
        contabilidadCfg.setMonedaId(1L);
        TenantContext.setUsuarioId(99L);
    }

    private AfMatrizSubClase matrizCompleta() {
        AfMatrizSubClase m = new AfMatrizSubClase();
        m.setCuentaGastoDepId(100L);
        m.setCuentaDepAcumId(101L);
        m.setCuentaActivoId(102L);
        m.setCuentaBajaId(103L);
        m.setCuentaResVentaId(104L);
        m.setCentroCostoId(5L);
        m.setCuentaProveedorTransitoriaId(105L);
        return m;
    }

    private AfMaestro maestroBase() {
        AfMaestro activo = new AfMaestro();
        activo.setId(10L);
        activo.setCodigo("AF-001");
        activo.setAfSubClaseId(2L);
        activo.setValorAdquisicion(new BigDecimal("50000.0000"));
        activo.setFechaAdquisicion(LocalDate.of(2024, 1, 10));
        return activo;
    }

    private void habilitarContabilidad() {
        when(integracionProperties.getContabilidad()).thenReturn(contabilidadCfg);
    }

    private void mockAsientoCreado(Long asientoId) {
        AsientoResponse asiento = new AsientoResponse();
        asiento.setId(asientoId);
        when(contabilidadClient.crear(any())).thenReturn(ApiResponse.ok(asiento));
    }

    private void mockBuscarOrigenVacio() {
        when(contabilidadClient.buscarPorOrigen(any(), any())).thenReturn(ApiResponse.ok(null));
    }

    @Nested
    class VerificarContabilidadHabilitada {

        @Test
        void lanzaExcepcionSiDeshabilitada() {
            contabilidadCfg.setHabilitada(false);
            when(integracionProperties.getContabilidad()).thenReturn(contabilidadCfg);

            assertThatThrownBy(() -> service.contabilizarDepreciacion(1L))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.INTEGRACION_CONTABILIDAD_DESHABILITADA);
        }
    }

    @Nested
    class ContabilizarDepreciacion {

        @Test
        void creaAsientoYGuardaReferencia() {
            habilitarContabilidad();
            AfCalculoCntbl calculo = new AfCalculoCntbl();
            calculo.setId(50L);
            calculo.setAfMaestroId(10L);
            calculo.setAnio(2026);
            calculo.setMes(4);
            calculo.setDepreciacionPeriodo(new BigDecimal("100.0000"));

            AfMaestro activo = maestroBase();
            AfMatrizSubClase matriz = matrizCompleta();

            when(calculoRepository.findById(50L)).thenReturn(Optional.of(calculo));
            when(maestroRepository.findById(10L)).thenReturn(Optional.of(activo));
            when(matrizRepository.findByAfSubClaseId(2L)).thenReturn(Optional.of(matriz));
            mockBuscarOrigenVacio();
            mockAsientoCreado(900L);
            when(calculoRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            IntegracionContabilidadResult result = service.contabilizarDepreciacion(50L);

            assertThat(result.getAsientoId()).isEqualTo(900L);
            assertThat(result.isYaExistia()).isFalse();
            assertThat(result.getModuloOrigen()).isEqualTo(AfIntegracionContableModulo.MODULO);
            assertThat(calculo.getCntblAsientoId()).isEqualTo(900L);
            verify(contabilidadClient).crear(any());
            verify(historialRegistroService).registrar(eq(10L), eq("DEPRECIACION_CONTABILIZADA"), any(), any(), any(), eq("AF_CONTABILIDAD"));
        }

        @Test
        void retornaExistenteSiYaTieneAsientoId() {
            habilitarContabilidad();
            AfCalculoCntbl calculo = new AfCalculoCntbl();
            calculo.setId(50L);
            calculo.setAfMaestroId(10L);
            calculo.setAnio(2026);
            calculo.setMes(4);
            calculo.setCntblAsientoId(800L);

            when(calculoRepository.findById(50L)).thenReturn(Optional.of(calculo));

            IntegracionContabilidadResult result = service.contabilizarDepreciacion(50L);

            assertThat(result.getAsientoId()).isEqualTo(800L);
            assertThat(result.isYaExistia()).isTrue();
            verify(contabilidadClient, never()).crear(any());
        }

        @Test
        void rechazaMontoCero() {
            habilitarContabilidad();
            AfCalculoCntbl calculo = new AfCalculoCntbl();
            calculo.setId(50L);
            calculo.setDepreciacionPeriodo(BigDecimal.ZERO);
            when(calculoRepository.findById(50L)).thenReturn(Optional.of(calculo));

            assertThatThrownBy(() -> service.contabilizarDepreciacion(50L))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.MONTO_CERO_NO_CONTABILIZABLE);
        }

        @Test
        void rechazaMontoNulo() {
            habilitarContabilidad();
            AfCalculoCntbl calculo = new AfCalculoCntbl();
            calculo.setId(50L);
            calculo.setDepreciacionPeriodo(null);
            when(calculoRepository.findById(50L)).thenReturn(Optional.of(calculo));

            assertThatThrownBy(() -> service.contabilizarDepreciacion(50L))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.MONTO_CERO_NO_CONTABILIZABLE);
        }

        @Test
        void rechazaMontoNegativo() {
            habilitarContabilidad();
            AfCalculoCntbl calculo = new AfCalculoCntbl();
            calculo.setId(50L);
            calculo.setDepreciacionPeriodo(new BigDecimal("-10.00"));
            when(calculoRepository.findById(50L)).thenReturn(Optional.of(calculo));

            assertThatThrownBy(() -> service.contabilizarDepreciacion(50L))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.MONTO_CERO_NO_CONTABILIZABLE);
        }

        @Test
        void lanzaExcepcionSiCalculoNoExiste() {
            habilitarContabilidad();
            when(calculoRepository.findById(999L)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> service.contabilizarDepreciacion(999L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void lanzaExcepcionSiActivoNoExiste() {
            habilitarContabilidad();
            AfCalculoCntbl calculo = new AfCalculoCntbl();
            calculo.setId(50L);
            calculo.setAfMaestroId(10L);
            calculo.setDepreciacionPeriodo(new BigDecimal("100.0000"));
            when(calculoRepository.findById(50L)).thenReturn(Optional.of(calculo));
            when(maestroRepository.findById(10L)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> service.contabilizarDepreciacion(50L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }

        @Test
        void lanzaExcepcionSiMatrizNoExiste() {
            habilitarContabilidad();
            AfCalculoCntbl calculo = new AfCalculoCntbl();
            calculo.setId(50L);
            calculo.setAfMaestroId(10L);
            calculo.setDepreciacionPeriodo(new BigDecimal("100.0000"));
            AfMaestro activo = maestroBase();

            when(calculoRepository.findById(50L)).thenReturn(Optional.of(calculo));
            when(maestroRepository.findById(10L)).thenReturn(Optional.of(activo));
            when(matrizRepository.findByAfSubClaseId(2L)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> service.contabilizarDepreciacion(50L))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.MATRIZ_INCOMPLETA_INTEGRACION);
        }

        @Test
        void lanzaExcepcionSiMatrizSinCuentaGastoDep() {
            habilitarContabilidad();
            AfCalculoCntbl calculo = new AfCalculoCntbl();
            calculo.setId(50L);
            calculo.setAfMaestroId(10L);
            calculo.setDepreciacionPeriodo(new BigDecimal("100.0000"));
            AfMaestro activo = maestroBase();
            AfMatrizSubClase matriz = new AfMatrizSubClase();
            matriz.setCuentaGastoDepId(null);
            matriz.setCuentaDepAcumId(101L);

            when(calculoRepository.findById(50L)).thenReturn(Optional.of(calculo));
            when(maestroRepository.findById(10L)).thenReturn(Optional.of(activo));
            when(matrizRepository.findByAfSubClaseId(2L)).thenReturn(Optional.of(matriz));

            assertThatThrownBy(() -> service.contabilizarDepreciacion(50L))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.MATRIZ_INCOMPLETA_INTEGRACION);
        }

        @Test
        void resuelveIdempotenciaCuandoYaExisteEnRemoto() {
            habilitarContabilidad();
            AfCalculoCntbl calculo = new AfCalculoCntbl();
            calculo.setId(50L);
            calculo.setAfMaestroId(10L);
            calculo.setAnio(2026);
            calculo.setMes(4);
            calculo.setDepreciacionPeriodo(new BigDecimal("100.0000"));

            AfMaestro activo = maestroBase();
            AfMatrizSubClase matriz = matrizCompleta();

            AsientoResponse existente = new AsientoResponse();
            existente.setId(777L);

            when(calculoRepository.findById(50L)).thenReturn(Optional.of(calculo));
            when(maestroRepository.findById(10L)).thenReturn(Optional.of(activo));
            when(matrizRepository.findByAfSubClaseId(2L)).thenReturn(Optional.of(matriz));
            when(contabilidadClient.buscarPorOrigen(any(), eq(50L))).thenReturn(ApiResponse.ok(existente));
            when(calculoRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            IntegracionContabilidadResult result = service.contabilizarDepreciacion(50L);

            assertThat(result.getAsientoId()).isEqualTo(777L);
            assertThat(result.isYaExistia()).isTrue();
            assertThat(calculo.getCntblAsientoId()).isEqualTo(777L);
            verify(contabilidadClient, never()).crear(any());
        }

        @Test
        void lanzaExcepcionCuandoFeignFalla() {
            habilitarContabilidad();
            AfCalculoCntbl calculo = new AfCalculoCntbl();
            calculo.setId(50L);
            calculo.setAfMaestroId(10L);
            calculo.setAnio(2026);
            calculo.setMes(4);
            calculo.setDepreciacionPeriodo(new BigDecimal("100.0000"));
            AfMaestro activo = maestroBase();
            AfMatrizSubClase matriz = matrizCompleta();

            when(calculoRepository.findById(50L)).thenReturn(Optional.of(calculo));
            when(maestroRepository.findById(10L)).thenReturn(Optional.of(activo));
            when(matrizRepository.findByAfSubClaseId(2L)).thenReturn(Optional.of(matriz));
            mockBuscarOrigenVacio();
            when(contabilidadClient.crear(any())).thenThrow(
                    new FeignException.ServiceUnavailable("service down",
                            Request.create(Request.HttpMethod.POST, "/api", Map.of(), null, null, null),
                            null, null));

            assertThatThrownBy(() -> service.contabilizarDepreciacion(50L))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.CONTABILIDAD_NO_DISPONIBLE);
        }

        @Test
        void lanzaExcepcionCuandoResponseEsNull() {
            habilitarContabilidad();
            AfCalculoCntbl calculo = new AfCalculoCntbl();
            calculo.setId(50L);
            calculo.setAfMaestroId(10L);
            calculo.setAnio(2026);
            calculo.setMes(4);
            calculo.setDepreciacionPeriodo(new BigDecimal("100.0000"));
            AfMaestro activo = maestroBase();
            AfMatrizSubClase matriz = matrizCompleta();

            when(calculoRepository.findById(50L)).thenReturn(Optional.of(calculo));
            when(maestroRepository.findById(10L)).thenReturn(Optional.of(activo));
            when(matrizRepository.findByAfSubClaseId(2L)).thenReturn(Optional.of(matriz));
            mockBuscarOrigenVacio();
            when(contabilidadClient.crear(any())).thenReturn(null);

            assertThatThrownBy(() -> service.contabilizarDepreciacion(50L))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.CONTABILIDAD_NO_DISPONIBLE);
        }
    }

    @Nested
    class ContabilizarDevengoPrima {

        @Test
        void creaAsientoDevengoPrima() {
            habilitarContabilidad();
            AfPrimaDevengo devengo = new AfPrimaDevengo();
            devengo.setId(30L);
            devengo.setAfPolizaSeguroId(7L);
            devengo.setAnio(2026);
            devengo.setMes(5);
            devengo.setImporteDevengado(new BigDecimal("100.0000"));

            AfPolizaActivo pa = new AfPolizaActivo();
            pa.setAfMaestroId(10L);
            AfMaestro activo = maestroBase();
            AfMatrizSubClase matriz = matrizCompleta();
            matriz.setCuentaGastoSeguroId(200L);
            matriz.setCuentaPasivoSeguroId(201L);

            when(devengoRepository.findById(30L)).thenReturn(Optional.of(devengo));
            when(polizaActivoRepository.findByAfPolizaSeguroId(7L)).thenReturn(List.of(pa));
            when(maestroRepository.findById(10L)).thenReturn(Optional.of(activo));
            when(matrizRepository.findByAfSubClaseId(2L)).thenReturn(Optional.of(matriz));
            mockBuscarOrigenVacio();
            mockAsientoCreado(901L);
            when(devengoRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            IntegracionContabilidadResult result = service.contabilizarDevengoPrima(30L);

            assertThat(result.getAsientoId()).isEqualTo(901L);
            assertThat(result.isYaExistia()).isFalse();
            assertThat(devengo.getCntblAsientoId()).isEqualTo(901L);
        }

        @Test
        void retornaExistenteSiYaTieneAsientoId() {
            habilitarContabilidad();
            AfPrimaDevengo devengo = new AfPrimaDevengo();
            devengo.setId(30L);
            devengo.setAfPolizaSeguroId(7L);
            devengo.setAnio(2026);
            devengo.setMes(5);
            devengo.setCntblAsientoId(555L);

            when(devengoRepository.findById(30L)).thenReturn(Optional.of(devengo));

            IntegracionContabilidadResult result = service.contabilizarDevengoPrima(30L);
            assertThat(result.isYaExistia()).isTrue();
            assertThat(result.getAsientoId()).isEqualTo(555L);
        }

        @Test
        void rechazaMontoNulo() {
            habilitarContabilidad();
            AfPrimaDevengo devengo = new AfPrimaDevengo();
            devengo.setId(30L);
            devengo.setImporteDevengado(null);
            when(devengoRepository.findById(30L)).thenReturn(Optional.of(devengo));

            assertThatThrownBy(() -> service.contabilizarDevengoPrima(30L))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.MONTO_CERO_NO_CONTABILIZABLE);
        }

        @Test
        void lanzaExcepcionSiPolizaSinActivos() {
            habilitarContabilidad();
            AfPrimaDevengo devengo = new AfPrimaDevengo();
            devengo.setId(30L);
            devengo.setAfPolizaSeguroId(7L);
            devengo.setImporteDevengado(new BigDecimal("100.0000"));

            when(devengoRepository.findById(30L)).thenReturn(Optional.of(devengo));
            when(polizaActivoRepository.findByAfPolizaSeguroId(7L)).thenReturn(Collections.emptyList());

            assertThatThrownBy(() -> service.contabilizarDevengoPrima(30L))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.MATRIZ_INCOMPLETA_INTEGRACION);
        }

        @Test
        void usaCuentaGastoDepComoFallbackSiGastoSeguroEsNull() {
            habilitarContabilidad();
            AfPrimaDevengo devengo = new AfPrimaDevengo();
            devengo.setId(30L);
            devengo.setAfPolizaSeguroId(7L);
            devengo.setAnio(2026);
            devengo.setMes(5);
            devengo.setImporteDevengado(new BigDecimal("100.0000"));

            AfPolizaActivo pa = new AfPolizaActivo();
            pa.setAfMaestroId(10L);
            AfMaestro activo = maestroBase();
            AfMatrizSubClase matriz = matrizCompleta();
            matriz.setCuentaGastoSeguroId(null);
            matriz.setCuentaPasivoSeguroId(null);

            when(devengoRepository.findById(30L)).thenReturn(Optional.of(devengo));
            when(polizaActivoRepository.findByAfPolizaSeguroId(7L)).thenReturn(List.of(pa));
            when(maestroRepository.findById(10L)).thenReturn(Optional.of(activo));
            when(matrizRepository.findByAfSubClaseId(2L)).thenReturn(Optional.of(matriz));
            mockBuscarOrigenVacio();
            mockAsientoCreado(902L);
            when(devengoRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            IntegracionContabilidadResult result = service.contabilizarDevengoPrima(30L);
            assertThat(result.getAsientoId()).isEqualTo(902L);
        }

        @Test
        void lanzaExcepcionDevengoNoExiste() {
            habilitarContabilidad();
            when(devengoRepository.findById(999L)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> service.contabilizarDevengoPrima(999L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }

    @Nested
    class ContabilizarVenta {

        @Test
        void creaAsientoVentaConUtilidadPositiva() {
            habilitarContabilidad();
            AfVenta venta = new AfVenta();
            venta.setId(20L);
            venta.setAfMaestroId(10L);
            venta.setValorVenta(new BigDecimal("45000.0000"));
            venta.setFechaBaja(LocalDate.of(2026, 5, 1));

            AfMaestro activo = maestroBase();
            AfMatrizSubClase matriz = matrizCompleta();
            AfCalculoCntbl ultimaDep = new AfCalculoCntbl();
            ultimaDep.setDepreciacionAcumulada(new BigDecimal("10000.0000"));

            when(ventaRepository.findById(20L)).thenReturn(Optional.of(venta));
            when(maestroRepository.findById(10L)).thenReturn(Optional.of(activo));
            when(matrizRepository.findByAfSubClaseId(2L)).thenReturn(Optional.of(matriz));
            when(calculoRepository.obtenerUltimaDepreciacion(10L)).thenReturn(Optional.of(ultimaDep));
            mockBuscarOrigenVacio();
            mockAsientoCreado(910L);
            when(ventaRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            IntegracionContabilidadResult result = service.contabilizarVenta(20L);

            assertThat(result.getAsientoId()).isEqualTo(910L);
            assertThat(result.isYaExistia()).isFalse();
            assertThat(venta.getCntblAsientoId()).isEqualTo(910L);
        }

        @Test
        void creaAsientoVentaConPerdida() {
            habilitarContabilidad();
            AfVenta venta = new AfVenta();
            venta.setId(20L);
            venta.setAfMaestroId(10L);
            venta.setValorVenta(new BigDecimal("5000.0000"));
            venta.setFechaBaja(LocalDate.of(2026, 5, 1));

            AfMaestro activo = maestroBase();
            AfMatrizSubClase matriz = matrizCompleta();
            AfCalculoCntbl ultimaDep = new AfCalculoCntbl();
            ultimaDep.setDepreciacionAcumulada(new BigDecimal("10000.0000"));

            when(ventaRepository.findById(20L)).thenReturn(Optional.of(venta));
            when(maestroRepository.findById(10L)).thenReturn(Optional.of(activo));
            when(matrizRepository.findByAfSubClaseId(2L)).thenReturn(Optional.of(matriz));
            when(calculoRepository.obtenerUltimaDepreciacion(10L)).thenReturn(Optional.of(ultimaDep));
            mockBuscarOrigenVacio();
            mockAsientoCreado(911L);
            when(ventaRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            IntegracionContabilidadResult result = service.contabilizarVenta(20L);
            assertThat(result.getAsientoId()).isEqualTo(911L);
        }

        @Test
        void ventaConValorVentaNull() {
            habilitarContabilidad();
            AfVenta venta = new AfVenta();
            venta.setId(20L);
            venta.setAfMaestroId(10L);
            venta.setValorVenta(null);
            venta.setFechaBaja(LocalDate.of(2026, 5, 1));

            AfMaestro activo = maestroBase();
            AfMatrizSubClase matriz = matrizCompleta();

            when(ventaRepository.findById(20L)).thenReturn(Optional.of(venta));
            when(maestroRepository.findById(10L)).thenReturn(Optional.of(activo));
            when(matrizRepository.findByAfSubClaseId(2L)).thenReturn(Optional.of(matriz));
            when(calculoRepository.obtenerUltimaDepreciacion(10L)).thenReturn(Optional.empty());
            mockBuscarOrigenVacio();
            mockAsientoCreado(912L);
            when(ventaRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            IntegracionContabilidadResult result = service.contabilizarVenta(20L);
            assertThat(result.getAsientoId()).isEqualTo(912L);
        }

        @Test
        void retornaExistenteSiYaTieneAsientoId() {
            habilitarContabilidad();
            AfVenta venta = new AfVenta();
            venta.setId(20L);
            venta.setAfMaestroId(10L);
            venta.setCntblAsientoId(800L);

            when(ventaRepository.findById(20L)).thenReturn(Optional.of(venta));

            IntegracionContabilidadResult result = service.contabilizarVenta(20L);
            assertThat(result.isYaExistia()).isTrue();
            assertThat(result.getAsientoId()).isEqualTo(800L);
        }

        @Test
        void ventaSinDepreciacionAcumulada() {
            habilitarContabilidad();
            AfVenta venta = new AfVenta();
            venta.setId(20L);
            venta.setAfMaestroId(10L);
            venta.setValorVenta(new BigDecimal("50000.0000"));
            venta.setFechaBaja(LocalDate.of(2026, 5, 1));

            AfMaestro activo = maestroBase();
            AfMatrizSubClase matriz = matrizCompleta();

            when(ventaRepository.findById(20L)).thenReturn(Optional.of(venta));
            when(maestroRepository.findById(10L)).thenReturn(Optional.of(activo));
            when(matrizRepository.findByAfSubClaseId(2L)).thenReturn(Optional.of(matriz));
            when(calculoRepository.obtenerUltimaDepreciacion(10L)).thenReturn(Optional.empty());
            mockBuscarOrigenVacio();
            mockAsientoCreado(913L);
            when(ventaRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            IntegracionContabilidadResult result = service.contabilizarVenta(20L);
            assertThat(result.getAsientoId()).isEqualTo(913L);
        }
    }

    @Nested
    class ContabilizarValuacion {

        @Test
        void creaAsientoValuacionAlAlza() {
            habilitarContabilidad();
            AfValuacion valuacion = new AfValuacion();
            valuacion.setId(40L);
            valuacion.setAfMaestroId(10L);
            valuacion.setValorAnterior(new BigDecimal("50000.0000"));
            valuacion.setValorNuevo(new BigDecimal("55000.0000"));
            valuacion.setFechaAprobacion(LocalDate.of(2026, 4, 1));
            valuacion.setFechaValuacion(LocalDate.of(2026, 4, 1));

            AfMaestro activo = maestroBase();
            AfMatrizSubClase matriz = matrizCompleta();

            when(valuacionRepository.findById(40L)).thenReturn(Optional.of(valuacion));
            when(maestroRepository.findById(10L)).thenReturn(Optional.of(activo));
            when(matrizRepository.findByAfSubClaseId(2L)).thenReturn(Optional.of(matriz));
            mockBuscarOrigenVacio();
            mockAsientoCreado(920L);
            when(valuacionRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            IntegracionContabilidadResult result = service.contabilizarValuacion(40L);
            assertThat(result.getAsientoId()).isEqualTo(920L);
            assertThat(result.isYaExistia()).isFalse();
        }

        @Test
        void creaAsientoValuacionALaBaja() {
            habilitarContabilidad();
            AfValuacion valuacion = new AfValuacion();
            valuacion.setId(41L);
            valuacion.setAfMaestroId(10L);
            valuacion.setValorAnterior(new BigDecimal("50000.0000"));
            valuacion.setValorNuevo(new BigDecimal("45000.0000"));
            valuacion.setFechaAprobacion(LocalDate.of(2026, 4, 1));
            valuacion.setFechaValuacion(LocalDate.of(2026, 4, 1));

            AfMaestro activo = maestroBase();
            AfMatrizSubClase matriz = matrizCompleta();

            when(valuacionRepository.findById(41L)).thenReturn(Optional.of(valuacion));
            when(maestroRepository.findById(10L)).thenReturn(Optional.of(activo));
            when(matrizRepository.findByAfSubClaseId(2L)).thenReturn(Optional.of(matriz));
            mockBuscarOrigenVacio();
            mockAsientoCreado(921L);
            when(valuacionRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            IntegracionContabilidadResult result = service.contabilizarValuacion(41L);
            assertThat(result.getAsientoId()).isEqualTo(921L);
        }

        @Test
        void lanzaExcepcionSiNoAprobada() {
            habilitarContabilidad();
            AfValuacion valuacion = new AfValuacion();
            valuacion.setId(40L);
            valuacion.setFechaAprobacion(null);

            when(valuacionRepository.findById(40L)).thenReturn(Optional.of(valuacion));

            assertThatThrownBy(() -> service.contabilizarValuacion(40L))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.VALUACION_NO_APROBADA);
        }

        @Test
        void lanzaExcepcionSiDeltaCero() {
            habilitarContabilidad();
            AfValuacion valuacion = new AfValuacion();
            valuacion.setId(40L);
            valuacion.setValorAnterior(new BigDecimal("50000.0000"));
            valuacion.setValorNuevo(new BigDecimal("50000.0000"));
            valuacion.setFechaAprobacion(LocalDate.of(2026, 4, 1));

            when(valuacionRepository.findById(40L)).thenReturn(Optional.of(valuacion));

            assertThatThrownBy(() -> service.contabilizarValuacion(40L))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.MONTO_CERO_NO_CONTABILIZABLE);
        }

        @Test
        void retornaExistenteSiYaTieneAsientoId() {
            habilitarContabilidad();
            AfValuacion valuacion = new AfValuacion();
            valuacion.setId(40L);
            valuacion.setAfMaestroId(10L);
            valuacion.setValorAnterior(new BigDecimal("50000.0000"));
            valuacion.setValorNuevo(new BigDecimal("55000.0000"));
            valuacion.setFechaAprobacion(LocalDate.of(2026, 4, 1));
            valuacion.setCntblAsientoId(700L);

            when(valuacionRepository.findById(40L)).thenReturn(Optional.of(valuacion));

            IntegracionContabilidadResult result = service.contabilizarValuacion(40L);
            assertThat(result.isYaExistia()).isTrue();
            assertThat(result.getAsientoId()).isEqualTo(700L);
        }
    }

    @Nested
    class ContabilizarAltaActivo {

        @Test
        void creaAsientoAltaConCuentaProveedorTransitoria() {
            habilitarContabilidad();
            AfMaestro activo = maestroBase();
            AfMatrizSubClase matriz = matrizCompleta();

            when(maestroRepository.findById(10L)).thenReturn(Optional.of(activo));
            when(matrizRepository.findByAfSubClaseId(2L)).thenReturn(Optional.of(matriz));
            mockBuscarOrigenVacio();
            mockAsientoCreado(930L);
            when(maestroRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            IntegracionContabilidadResult result = service.contabilizarAltaActivo(10L);

            assertThat(result.getAsientoId()).isEqualTo(930L);
            assertThat(result.isYaExistia()).isFalse();
            assertThat(activo.getCntblAsientoId()).isEqualTo(930L);
        }

        @Test
        void usaCuentaBajaComoFallbackSiProveedorTransitoriaEsNull() {
            habilitarContabilidad();
            AfMaestro activo = maestroBase();
            AfMatrizSubClase matriz = matrizCompleta();
            matriz.setCuentaProveedorTransitoriaId(null);

            when(maestroRepository.findById(10L)).thenReturn(Optional.of(activo));
            when(matrizRepository.findByAfSubClaseId(2L)).thenReturn(Optional.of(matriz));
            mockBuscarOrigenVacio();
            mockAsientoCreado(931L);
            when(maestroRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            IntegracionContabilidadResult result = service.contabilizarAltaActivo(10L);
            assertThat(result.getAsientoId()).isEqualTo(931L);
        }

        @Test
        void retornaExistenteSiYaTieneAsientoId() {
            habilitarContabilidad();
            AfMaestro activo = maestroBase();
            activo.setCntblAsientoId(600L);

            when(maestroRepository.findById(10L)).thenReturn(Optional.of(activo));

            IntegracionContabilidadResult result = service.contabilizarAltaActivo(10L);
            assertThat(result.isYaExistia()).isTrue();
            assertThat(result.getAsientoId()).isEqualTo(600L);
        }

        @Test
        void lanzaExcepcionSiMatrizActivoNull() {
            habilitarContabilidad();
            AfMaestro activo = maestroBase();
            AfMatrizSubClase matriz = new AfMatrizSubClase();
            matriz.setCuentaActivoId(null);
            matriz.setCuentaProveedorTransitoriaId(105L);

            when(maestroRepository.findById(10L)).thenReturn(Optional.of(activo));
            when(matrizRepository.findByAfSubClaseId(2L)).thenReturn(Optional.of(matriz));

            assertThatThrownBy(() -> service.contabilizarAltaActivo(10L))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.MATRIZ_INCOMPLETA_INTEGRACION);
        }
    }

    @Nested
    class ContabilizarAdaptacion {

        @Test
        void creaAsientoAdaptacionCapitalizada() {
            habilitarContabilidad();
            AfAdaptacion adaptacion = new AfAdaptacion();
            adaptacion.setId(60L);
            adaptacion.setAfMaestroId(10L);
            adaptacion.setEstado("CAPITALIZADO");
            adaptacion.setMontoTotal(new BigDecimal("5000.0000"));
            adaptacion.setFecha(LocalDate.of(2026, 3, 1));

            AfMaestro activo = maestroBase();
            AfMatrizSubClase matriz = matrizCompleta();
            matriz.setCuentaCapitalizacionId(300L);

            when(adaptacionRepository.findById(60L)).thenReturn(Optional.of(adaptacion));
            when(maestroRepository.findById(10L)).thenReturn(Optional.of(activo));
            when(matrizRepository.findByAfSubClaseId(2L)).thenReturn(Optional.of(matriz));
            mockBuscarOrigenVacio();
            mockAsientoCreado(940L);
            when(adaptacionRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            IntegracionContabilidadResult result = service.contabilizarAdaptacion(60L);
            assertThat(result.getAsientoId()).isEqualTo(940L);
            assertThat(adaptacion.getCntblAsientoId()).isEqualTo(940L);
        }

        @Test
        void lanzaExcepcionSiNoCapitalizada() {
            habilitarContabilidad();
            AfAdaptacion adaptacion = new AfAdaptacion();
            adaptacion.setId(60L);
            adaptacion.setEstado("REGISTRADO");

            when(adaptacionRepository.findById(60L)).thenReturn(Optional.of(adaptacion));

            assertThatThrownBy(() -> service.contabilizarAdaptacion(60L))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.ADAPTACION_NO_CAPITALIZADA);
        }

        @Test
        void retornaExistenteSiYaTieneAsientoId() {
            habilitarContabilidad();
            AfAdaptacion adaptacion = new AfAdaptacion();
            adaptacion.setId(60L);
            adaptacion.setAfMaestroId(10L);
            adaptacion.setEstado("CAPITALIZADO");
            adaptacion.setCntblAsientoId(500L);

            when(adaptacionRepository.findById(60L)).thenReturn(Optional.of(adaptacion));

            IntegracionContabilidadResult result = service.contabilizarAdaptacion(60L);
            assertThat(result.isYaExistia()).isTrue();
            assertThat(result.getAsientoId()).isEqualTo(500L);
        }

        @Test
        void usaCuentaCreditoAltaComoFallbackSiCapitalizacionEsNull() {
            habilitarContabilidad();
            AfAdaptacion adaptacion = new AfAdaptacion();
            adaptacion.setId(60L);
            adaptacion.setAfMaestroId(10L);
            adaptacion.setEstado("CAPITALIZADO");
            adaptacion.setMontoTotal(new BigDecimal("5000.0000"));
            adaptacion.setFecha(LocalDate.of(2026, 3, 1));

            AfMaestro activo = maestroBase();
            AfMatrizSubClase matriz = matrizCompleta();
            matriz.setCuentaCapitalizacionId(null);

            when(adaptacionRepository.findById(60L)).thenReturn(Optional.of(adaptacion));
            when(maestroRepository.findById(10L)).thenReturn(Optional.of(activo));
            when(matrizRepository.findByAfSubClaseId(2L)).thenReturn(Optional.of(matriz));
            mockBuscarOrigenVacio();
            mockAsientoCreado(941L);
            when(adaptacionRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

            IntegracionContabilidadResult result = service.contabilizarAdaptacion(60L);
            assertThat(result.getAsientoId()).isEqualTo(941L);
        }
    }

    @Nested
    class ContabilizarBajaActivo {

        @Test
        void creaAsientoBajaConDepreciacionAcumulada() {
            habilitarContabilidad();
            AfMaestro activo = maestroBase();
            AfMatrizSubClase matriz = matrizCompleta();
            AfCalculoCntbl ultimaDep = new AfCalculoCntbl();
            ultimaDep.setDepreciacionAcumulada(new BigDecimal("20000.0000"));

            when(ventaRepository.existsByAfMaestroId(10L)).thenReturn(false);
            when(maestroRepository.findById(10L)).thenReturn(Optional.of(activo));
            when(matrizRepository.findByAfSubClaseId(2L)).thenReturn(Optional.of(matriz));
            when(calculoRepository.obtenerUltimaDepreciacion(10L)).thenReturn(Optional.of(ultimaDep));
            when(contabilidadClient.buscarPorOrigen(any(), eq(10L))).thenReturn(ApiResponse.ok(null));
            mockAsientoCreado(950L);

            IntegracionContabilidadResult result = service.contabilizarBajaActivo(10L);

            assertThat(result.getAsientoId()).isEqualTo(950L);
            assertThat(result.isYaExistia()).isFalse();
            verify(historialRegistroService).registrar(eq(10L), eq("BAJA_CONTABILIZADA"), any(), any(), any(), eq("AF_CONTABILIDAD"));
        }

        @Test
        void lanzaExcepcionSiActivoTieneVenta() {
            habilitarContabilidad();
            when(ventaRepository.existsByAfMaestroId(10L)).thenReturn(true);

            assertThatThrownBy(() -> service.contabilizarBajaActivo(10L))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.ACTIVO_YA_VENDIDO);
        }

        @Test
        void retornaExistenteSiBajaYaContabilizada() {
            habilitarContabilidad();
            AfMaestro activo = maestroBase();
            AsientoResponse existente = new AsientoResponse();
            existente.setId(888L);

            when(ventaRepository.existsByAfMaestroId(10L)).thenReturn(false);
            when(maestroRepository.findById(10L)).thenReturn(Optional.of(activo));
            when(contabilidadClient.buscarPorOrigen(any(), eq(10L))).thenReturn(ApiResponse.ok(existente));

            IntegracionContabilidadResult result = service.contabilizarBajaActivo(10L);
            assertThat(result.isYaExistia()).isTrue();
            assertThat(result.getAsientoId()).isEqualTo(888L);
        }

        @Test
        void bajaSinDepreciacionAcumulada() {
            habilitarContabilidad();
            AfMaestro activo = maestroBase();
            AfMatrizSubClase matriz = matrizCompleta();

            when(ventaRepository.existsByAfMaestroId(10L)).thenReturn(false);
            when(maestroRepository.findById(10L)).thenReturn(Optional.of(activo));
            when(matrizRepository.findByAfSubClaseId(2L)).thenReturn(Optional.of(matriz));
            when(calculoRepository.obtenerUltimaDepreciacion(10L)).thenReturn(Optional.empty());
            when(contabilidadClient.buscarPorOrigen(any(), eq(10L))).thenReturn(ApiResponse.ok(null));
            mockAsientoCreado(951L);

            IntegracionContabilidadResult result = service.contabilizarBajaActivo(10L);
            assertThat(result.getAsientoId()).isEqualTo(951L);
        }
    }

    @Nested
    class ConsultarTrazabilidad {

        @Test
        void retornaResultadoConAsientoEncontrado() {
            habilitarContabilidad();
            AsientoResponse asiento = new AsientoResponse();
            asiento.setId(100L);
            asiento.setGlosa("Asiento test");

            when(contabilidadClient.buscarPorOrigen(AfIntegracionContableModulo.MODULO, 50L))
                    .thenReturn(ApiResponse.ok(asiento));

            IntegracionContabilidadResult result = service.consultarTrazabilidad(
                    AfIntegracionContableModulo.MODULO, 50L);
            assertThat(result.getAsientoId()).isEqualTo(100L);
            assertThat(result.isYaExistia()).isTrue();
            assertThat(result.getCorrelacion()).isEqualTo("Asiento test");
        }

        @Test
        void lanzaExcepcionSiNoEncuentraAsiento() {
            habilitarContabilidad();
            when(contabilidadClient.buscarPorOrigen(AfIntegracionContableModulo.MODULO, 50L))
                    .thenThrow(new FeignException.NotFound("not found",
                            Request.create(Request.HttpMethod.GET, "/api", Map.of(), null, null, null),
                            null, null));

            assertThatThrownBy(() -> service.consultarTrazabilidad(AfIntegracionContableModulo.MODULO, 50L))
                    .isInstanceOf(ResourceNotFoundException.class);
        }
    }
}
