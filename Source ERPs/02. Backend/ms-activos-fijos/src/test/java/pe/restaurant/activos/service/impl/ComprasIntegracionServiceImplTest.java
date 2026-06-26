package pe.restaurant.activos.service.impl;

import feign.FeignException;
import feign.Request;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.quality.Strictness;
import pe.restaurant.activos.client.ComprasActivosClient;
import pe.restaurant.activos.client.dto.compras.OrdenCompraDetalleResponse;
import pe.restaurant.activos.client.dto.compras.OrdenCompraLineaResponse;
import pe.restaurant.activos.client.dto.compras.RecepcionResumenResponse;
import pe.restaurant.activos.config.IntegracionProperties;
import pe.restaurant.activos.dto.AfMaestroDesdeCompraRequest;
import pe.restaurant.activos.dto.AfMaestroDesdeFacturaCompraRequest;
import pe.restaurant.activos.dto.AfMaestroDesdeRecepcionRequest;
import pe.restaurant.activos.entity.AfMaestro;
import pe.restaurant.activos.integracion.ContabilidadAutoContabilizador;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.activos.service.AfHistorialRegistroService;
import pe.restaurant.activos.service.AfMaestroService;
import pe.restaurant.activos.service.ContabilidadIntegracionService;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.exception.BusinessException;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class ComprasIntegracionServiceImplTest {

    @Mock
    private IntegracionProperties integracionProperties;
    @Mock
    private ComprasActivosClient comprasClient;
    @Mock
    private AfMaestroRepository maestroRepository;
    @Mock
    private AfMaestroService maestroService;
    @Mock
    private AfHistorialRegistroService historialRegistroService;
    @Mock
    private ContabilidadIntegracionService contabilidadIntegracionService;
    @Mock
    private ContabilidadAutoContabilizador contabilidadAutoContabilizador;
    private ComprasIntegracionServiceImpl service;

    private IntegracionProperties.Compras comprasCfg;

    @BeforeEach
    void setUp() {
        comprasCfg = new IntegracionProperties.Compras();
        comprasCfg.setHabilitada(true);
        comprasCfg.setToleranciaImporte(new BigDecimal("0.01"));
        lenient().when(integracionProperties.getCompras()).thenReturn(comprasCfg);
        service = new ComprasIntegracionServiceImpl(
                integracionProperties,
                comprasClient,
                maestroRepository,
                maestroService,
                historialRegistroService,
                contabilidadIntegracionService,
                contabilidadAutoContabilizador,
                null);
    }

    private OrdenCompraLineaResponse lineaBase() {
        var linea = new OrdenCompraLineaResponse();
        linea.setId(20L);
        linea.setSubtotal(new BigDecimal("15000.0000"));
        linea.setArticuloDescripcion("Laptop contabilidad");
        linea.setCantFacturada(new BigDecimal("1"));
        return linea;
    }

    private OrdenCompraDetalleResponse ocBase() {
        var oc = new OrdenCompraDetalleResponse();
        oc.setId(5L);
        oc.setProveedorId(99L);
        oc.setNroOrdenCompra("OC-2026-001");
        oc.setFechaEmision(LocalDate.of(2026, 3, 1));
        oc.setLineas(List.of(lineaBase()));
        return oc;
    }

    private AfMaestroDesdeCompraRequest requestBase() {
        var request = new AfMaestroDesdeCompraRequest();
        request.setOrdenCompraId(5L);
        request.setOrdenCompraLineaId(20L);
        request.setCodigo("AF-LAP-01");
        request.setAfSubClaseId(2L);
        request.setValorAdquisicion(new BigDecimal("15000.0000"));
        request.setValorResidual(BigDecimal.ZERO);
        return request;
    }

    @Nested
    class CrearMaestroDesdeOrdenCompra {

        @Test
        void creaActivoExitosamente() {
            var request = requestBase();
            AfMaestro creado = new AfMaestro();
            creado.setId(1L);
            creado.setCodigo("AF-LAP-01");

            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(ocBase()));
            when(maestroService.create(any())).thenReturn(creado);

            AfMaestro result = service.crearMaestroDesdeOrdenCompra(request);

            assertThat(result.getId()).isEqualTo(1L);
            verify(maestroService).create(any());
            verify(historialRegistroService).registrar(eq(1L), eq("ALTA_DESDE_COMPRA"), any(), any(), any(), eq("AF_COMPRAS"));
        }

        @Test
        void usaFechaEmisionOcSiFechaAdquisicionNull() {
            var request = requestBase();
            request.setFechaAdquisicion(null);
            AfMaestro creado = new AfMaestro();
            creado.setId(1L);

            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(ocBase()));
            when(maestroService.create(any())).thenReturn(creado);

            service.crearMaestroDesdeOrdenCompra(request);
            verify(maestroService).create(argThat(m -> m.getFechaAdquisicion().equals(LocalDate.of(2026, 3, 1))));
        }

        @Test
        void usaProveedorOcSiRequestNull() {
            var request = requestBase();
            request.setProveedorId(null);
            AfMaestro creado = new AfMaestro();
            creado.setId(1L);

            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(ocBase()));
            when(maestroService.create(any())).thenReturn(creado);

            service.crearMaestroDesdeOrdenCompra(request);
            verify(maestroService).create(argThat(m -> m.getProveedorId().equals(99L)));
        }

        @Test
        void lanzaExcepcionSiIntegracionDeshabilitada() {
            comprasCfg.setHabilitada(false);

            assertThatThrownBy(() -> service.crearMaestroDesdeOrdenCompra(requestBase()))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.INTEGRACION_COMPRAS_DESHABILITADA);
        }

        @Test
        void lanzaExcepcionSiActivoYaVinculado() {
            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(true);

            assertThatThrownBy(() -> service.crearMaestroDesdeOrdenCompra(requestBase()))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.ACTIVO_YA_VINCULADO_OC);
        }

        @Test
        void lanzaExcepcionSiLineaNoPertenece() {
            var request = requestBase();
            request.setOrdenCompraLineaId(999L);
            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 999L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(ocBase()));

            assertThatThrownBy(() -> service.crearMaestroDesdeOrdenCompra(request))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.ORDEN_COMPRA_LINEA_INVALIDA);
        }

        @Test
        void lanzaExcepcionSiImporteNoCuadra() {
            var request = requestBase();
            request.setValorAdquisicion(new BigDecimal("200.0000"));
            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(ocBase()));

            assertThatThrownBy(() -> service.crearMaestroDesdeOrdenCompra(request))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.IMPORTE_NO_CUADRA_COMPRA);
        }

        @Test
        void lanzaExcepcionSiProveedorNoCoincide() {
            var request = requestBase();
            request.setProveedorId(50L);
            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(ocBase()));

            assertThatThrownBy(() -> service.crearMaestroDesdeOrdenCompra(request))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.PROVEEDOR_NO_COINCIDE_OC);
        }

        @Test
        void noValidaProveedorSiRequestProveedorNull() {
            var request = requestBase();
            request.setProveedorId(null);
            AfMaestro creado = new AfMaestro();
            creado.setId(1L);
            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(ocBase()));
            when(maestroService.create(any())).thenReturn(creado);

            service.crearMaestroDesdeOrdenCompra(request);
            verify(maestroService).create(any());
        }

        @Test
        void lanzaExcepcionSiOcNoEncontrada() {
            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(null));

            assertThatThrownBy(() -> service.crearMaestroDesdeOrdenCompra(requestBase()))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.ORDEN_COMPRA_NO_ENCONTRADA);
        }

        @Test
        void lanzaExcepcionSiOcSinLineas() {
            var oc = ocBase();
            oc.setLineas(Collections.emptyList());
            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(oc));

            assertThatThrownBy(() -> service.crearMaestroDesdeOrdenCompra(requestBase()))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.ORDEN_COMPRA_LINEA_INVALIDA);
        }

        @Test
        void lanzaExcepcionSiFeignNotFound() {
            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenThrow(
                    new FeignException.NotFound("not found",
                            Request.create(Request.HttpMethod.GET, "/api", Map.of(), null, null, null),
                            null, null));

            assertThatThrownBy(() -> service.crearMaestroDesdeOrdenCompra(requestBase()))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.ORDEN_COMPRA_NO_ENCONTRADA);
        }

        @Test
        void lanzaExcepcionSiFeignGenericError() {
            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenThrow(
                    new FeignException.ServiceUnavailable("timeout",
                            Request.create(Request.HttpMethod.GET, "/api", Map.of(), null, null, null),
                            null, null));

            assertThatThrownBy(() -> service.crearMaestroDesdeOrdenCompra(requestBase()))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.ORDEN_COMPRA_NO_ENCONTRADA);
        }

        @Test
        void usaNombreDelRequestSiProvisto() {
            var request = requestBase();
            request.setNombre("Mi equipo custom");
            AfMaestro creado = new AfMaestro();
            creado.setId(1L);
            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(ocBase()));
            when(maestroService.create(any())).thenReturn(creado);

            service.crearMaestroDesdeOrdenCompra(request);
            verify(maestroService).create(argThat(m -> "Mi equipo custom".equals(m.getNombre())));
        }

        @Test
        void usaDescripcionLineaSiNombreBlank() {
            var request = requestBase();
            request.setNombre("  ");
            AfMaestro creado = new AfMaestro();
            creado.setId(1L);
            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(ocBase()));
            when(maestroService.create(any())).thenReturn(creado);

            service.crearMaestroDesdeOrdenCompra(request);
            verify(maestroService).create(argThat(m -> "Laptop contabilidad".equals(m.getNombre())));
        }

        @Test
        void usaCodigoSiNombreYDescripcionVacios() {
            var linea = lineaBase();
            linea.setArticuloDescripcion("  ");
            var oc = ocBase();
            oc.setLineas(List.of(linea));
            var request = requestBase();
            request.setNombre(null);
            AfMaestro creado = new AfMaestro();
            creado.setId(1L);
            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(oc));
            when(maestroService.create(any())).thenReturn(creado);

            service.crearMaestroDesdeOrdenCompra(request);
            verify(maestroService).create(argThat(m -> "AF-LAP-01".equals(m.getNombre())));
        }

        @Test
        void noValidaImporteSiReferenciaEsNull() {
            var linea = lineaBase();
            linea.setSubtotal(null);
            linea.setValorUnitario(null);
            var oc = ocBase();
            oc.setLineas(List.of(linea));
            var request = requestBase();
            request.setValorAdquisicion(new BigDecimal("99999.0000"));
            AfMaestro creado = new AfMaestro();
            creado.setId(1L);
            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(oc));
            when(maestroService.create(any())).thenReturn(creado);

            service.crearMaestroDesdeOrdenCompra(request);
            verify(maestroService).create(any());
        }

        @Test
        void usaValorUnitarioSiSubtotalEsNull() {
            var linea = lineaBase();
            linea.setSubtotal(null);
            linea.setValorUnitario(new BigDecimal("15000.0000"));
            var oc = ocBase();
            oc.setLineas(List.of(linea));
            var request = requestBase();
            AfMaestro creado = new AfMaestro();
            creado.setId(1L);
            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(oc));
            when(maestroService.create(any())).thenReturn(creado);

            service.crearMaestroDesdeOrdenCompra(request);
            verify(maestroService).create(any());
        }
    }

    @Nested
    class CrearMaestroDesdeRecepcion {

        @Test
        void creaActivoDesdeRecepcion() {
            var request = new AfMaestroDesdeRecepcionRequest();
            request.setOrdenCompraId(5L);
            request.setOrdenCompraLineaId(20L);
            request.setRecepcionId(100L);
            request.setCodigo("AF-REC-01");
            request.setAfSubClaseId(2L);
            request.setValorAdquisicion(new BigDecimal("15000.0000"));
            request.setValorResidual(BigDecimal.ZERO);

            RecepcionResumenResponse rec = new RecepcionResumenResponse();
            rec.setId(100L);

            AfMaestro creado = new AfMaestro();
            creado.setId(2L);

            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(ocBase()));
            when(comprasClient.listarRecepciones(5L)).thenReturn(ApiResponse.ok(List.of(rec)));
            when(maestroService.create(any())).thenReturn(creado);

            AfMaestro result = service.crearMaestroDesdeRecepcion(request);
            assertThat(result.getId()).isEqualTo(2L);
            verify(historialRegistroService).registrar(eq(2L), eq("ALTA_DESDE_RECEPCION"), any(), any(), any(), eq("AF_COMPRAS"));
        }

        @Test
        void lanzaExcepcionSiIntegracionDeshabilitada() {
            comprasCfg.setHabilitada(false);
            var request = new AfMaestroDesdeRecepcionRequest();

            assertThatThrownBy(() -> service.crearMaestroDesdeRecepcion(request))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.INTEGRACION_COMPRAS_DESHABILITADA);
        }

        @Test
        void lanzaExcepcionSiRecepcionNoEncontrada() {
            var request = new AfMaestroDesdeRecepcionRequest();
            request.setOrdenCompraId(5L);
            request.setOrdenCompraLineaId(20L);
            request.setRecepcionId(999L);
            request.setCodigo("AF-X");
            request.setAfSubClaseId(2L);
            request.setValorAdquisicion(new BigDecimal("15000.0000"));
            request.setValorResidual(BigDecimal.ZERO);

            RecepcionResumenResponse rec = new RecepcionResumenResponse();
            rec.setId(100L);

            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(ocBase()));
            when(comprasClient.listarRecepciones(5L)).thenReturn(ApiResponse.ok(List.of(rec)));

            assertThatThrownBy(() -> service.crearMaestroDesdeRecepcion(request))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.RECEPCION_COMPRA_NO_ENCONTRADA);
        }

        @Test
        void lanzaExcepcionSiFeignFallaEnRecepciones() {
            var request = new AfMaestroDesdeRecepcionRequest();
            request.setOrdenCompraId(5L);
            request.setOrdenCompraLineaId(20L);
            request.setRecepcionId(100L);
            request.setCodigo("AF-X");
            request.setAfSubClaseId(2L);
            request.setValorAdquisicion(new BigDecimal("15000.0000"));
            request.setValorResidual(BigDecimal.ZERO);

            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(ocBase()));
            when(comprasClient.listarRecepciones(5L)).thenThrow(
                    new FeignException.ServiceUnavailable("timeout",
                            Request.create(Request.HttpMethod.GET, "/api", Map.of(), null, null, null),
                            null, null));

            assertThatThrownBy(() -> service.crearMaestroDesdeRecepcion(request))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.RECEPCION_COMPRA_NO_ENCONTRADA);
        }

        @Test
        void lanzaExcepcionSiRecepcionResponseEsNull() {
            var request = new AfMaestroDesdeRecepcionRequest();
            request.setOrdenCompraId(5L);
            request.setOrdenCompraLineaId(20L);
            request.setRecepcionId(100L);
            request.setCodigo("AF-X");
            request.setAfSubClaseId(2L);
            request.setValorAdquisicion(new BigDecimal("15000.0000"));
            request.setValorResidual(BigDecimal.ZERO);

            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(ocBase()));
            when(comprasClient.listarRecepciones(5L)).thenReturn(ApiResponse.ok(null));

            assertThatThrownBy(() -> service.crearMaestroDesdeRecepcion(request))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.RECEPCION_COMPRA_NO_ENCONTRADA);
        }

        @Test
        void usaNombreCustomDelRequest() {
            var request = new AfMaestroDesdeRecepcionRequest();
            request.setOrdenCompraId(5L);
            request.setOrdenCompraLineaId(20L);
            request.setRecepcionId(100L);
            request.setCodigo("AF-REC-N");
            request.setNombre("Equipo recepcion custom");
            request.setAfSubClaseId(2L);
            request.setValorAdquisicion(new BigDecimal("15000.0000"));
            request.setValorResidual(BigDecimal.ZERO);

            RecepcionResumenResponse rec = new RecepcionResumenResponse();
            rec.setId(100L);
            AfMaestro creado = new AfMaestro();
            creado.setId(20L);

            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(ocBase()));
            when(comprasClient.listarRecepciones(5L)).thenReturn(ApiResponse.ok(List.of(rec)));
            when(maestroService.create(any())).thenReturn(creado);

            service.crearMaestroDesdeRecepcion(request);
            verify(maestroService).create(argThat(m -> "Equipo recepcion custom".equals(m.getNombre())));
        }

        @Test
        void usaCodigoCuandoNombreYDescripcionVacios() {
            var linea = lineaBase();
            linea.setArticuloDescripcion("   ");
            var oc = ocBase();
            oc.setLineas(List.of(linea));

            var request = new AfMaestroDesdeRecepcionRequest();
            request.setOrdenCompraId(5L);
            request.setOrdenCompraLineaId(20L);
            request.setRecepcionId(100L);
            request.setCodigo("AF-REC-FB");
            request.setAfSubClaseId(2L);
            request.setValorAdquisicion(new BigDecimal("15000.0000"));
            request.setValorResidual(BigDecimal.ZERO);

            RecepcionResumenResponse rec = new RecepcionResumenResponse();
            rec.setId(100L);
            AfMaestro creado = new AfMaestro();
            creado.setId(21L);

            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(oc));
            when(comprasClient.listarRecepciones(5L)).thenReturn(ApiResponse.ok(List.of(rec)));
            when(maestroService.create(any())).thenReturn(creado);

            service.crearMaestroDesdeRecepcion(request);
            verify(maestroService).create(argThat(m -> "AF-REC-FB".equals(m.getNombre())));
        }
    }

    @Nested
    class CrearMaestroDesdeFacturaCompra {

        private AfMaestroDesdeFacturaCompraRequest requestFacturaBase() {
            var request = new AfMaestroDesdeFacturaCompraRequest();
            request.setOrdenCompraId(5L);
            request.setOrdenCompraLineaId(20L);
            request.setFacturaSerie("F001");
            request.setFacturaNumero("000123");
            request.setFacturaFecha(LocalDate.of(2026, 3, 15));
            request.setCodigo("AF-FAC-01");
            request.setAfSubClaseId(2L);
            request.setAfUbicacionId(7L);
            request.setValorAdquisicion(new BigDecimal("15000.0000"));
            request.setValorResidual(BigDecimal.ZERO);
            request.setProveedorId(99L);
            return request;
        }

        @Test
        void creaActivoExitosamenteDesdeFactura() {
            var request = requestFacturaBase();
            AfMaestro creado = new AfMaestro();
            creado.setId(50L);
            creado.setCodigo("AF-FAC-01");

            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(ocBase()));
            when(maestroRepository
                    .existsByProveedorIdAndFacturaProveedorSerieIgnoreCaseAndFacturaProveedorNumeroIgnoreCase(
                            eq(99L), eq("F001"), eq("000123")))
                    .thenReturn(false);
            when(maestroService.create(any())).thenReturn(creado);

            AfMaestro result = service.crearMaestroDesdeFacturaCompra(request);

            assertThat(result.getId()).isEqualTo(50L);
            verify(maestroService).create(argThat(m ->
                    "F001".equals(m.getFacturaProveedorSerie())
                            && "000123".equals(m.getFacturaProveedorNumero())
                            && LocalDate.of(2026, 3, 15).equals(m.getFacturaProveedorFecha())));
            verify(historialRegistroService).registrar(eq(50L), eq("ALTA_DESDE_FACTURA"),
                    any(), any(), any(), eq("AF_COMPRAS"));
            verify(contabilidadAutoContabilizador).ejecutarSiAutomatico(any(), any());
        }

        @Test
        void usaFacturaFechaSiFechaAdquisicionNull() {
            var request = requestFacturaBase();
            request.setFechaAdquisicion(null);
            AfMaestro creado = new AfMaestro();
            creado.setId(50L);

            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(ocBase()));
            when(maestroRepository
                    .existsByProveedorIdAndFacturaProveedorSerieIgnoreCaseAndFacturaProveedorNumeroIgnoreCase(
                            any(), any(), any()))
                    .thenReturn(false);
            when(maestroService.create(any())).thenReturn(creado);

            service.crearMaestroDesdeFacturaCompra(request);

            verify(maestroService).create(argThat(m ->
                    LocalDate.of(2026, 3, 15).equals(m.getFechaAdquisicion())));
        }

        @Test
        void usaFechaAdquisicionDelRequestCuandoNoNull() {
            var request = requestFacturaBase();
            request.setFechaAdquisicion(LocalDate.of(2026, 1, 1));
            AfMaestro creado = new AfMaestro();
            creado.setId(50L);

            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(ocBase()));
            when(maestroRepository
                    .existsByProveedorIdAndFacturaProveedorSerieIgnoreCaseAndFacturaProveedorNumeroIgnoreCase(
                            any(), any(), any()))
                    .thenReturn(false);
            when(maestroService.create(any())).thenReturn(creado);

            service.crearMaestroDesdeFacturaCompra(request);

            verify(maestroService).create(argThat(m ->
                    LocalDate.of(2026, 1, 1).equals(m.getFechaAdquisicion())));
        }

        @Test
        void usaProveedorOcSiRequestProveedorNull() {
            var request = requestFacturaBase();
            request.setProveedorId(null);
            AfMaestro creado = new AfMaestro();
            creado.setId(50L);

            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(ocBase()));
            when(maestroRepository
                    .existsByProveedorIdAndFacturaProveedorSerieIgnoreCaseAndFacturaProveedorNumeroIgnoreCase(
                            eq(99L), any(), any()))
                    .thenReturn(false);
            when(maestroService.create(any())).thenReturn(creado);

            service.crearMaestroDesdeFacturaCompra(request);

            verify(maestroService).create(argThat(m -> Long.valueOf(99L).equals(m.getProveedorId())));
        }

        @Test
        void lanzaExcepcionSiIntegracionDeshabilitada() {
            comprasCfg.setHabilitada(false);
            assertThatThrownBy(() -> service.crearMaestroDesdeFacturaCompra(requestFacturaBase()))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode",
                            ActivosErrorCodes.INTEGRACION_COMPRAS_DESHABILITADA);
        }

        @Test
        void lanzaExcepcionSiActivoYaVinculado() {
            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(true);

            assertThatThrownBy(() -> service.crearMaestroDesdeFacturaCompra(requestFacturaBase()))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.ACTIVO_YA_VINCULADO_OC);
        }

        @Test
        void lanzaExcepcionSiLineaNoPertenece() {
            var request = requestFacturaBase();
            request.setOrdenCompraLineaId(999L);
            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 999L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(ocBase()));

            assertThatThrownBy(() -> service.crearMaestroDesdeFacturaCompra(request))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.ORDEN_COMPRA_LINEA_INVALIDA);
        }

        @Test
        void lanzaExcepcionSiLineaSinCantidadFacturada() {
            var linea = lineaBase();
            linea.setCantFacturada(BigDecimal.ZERO);
            var oc = ocBase();
            oc.setLineas(List.of(linea));

            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(oc));

            assertThatThrownBy(() -> service.crearMaestroDesdeFacturaCompra(requestFacturaBase()))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.LINEA_SIN_FACTURAR);
        }

        @Test
        void lanzaExcepcionSiCantFacturadaEsNull() {
            var linea = lineaBase();
            linea.setCantFacturada(null);
            var oc = ocBase();
            oc.setLineas(List.of(linea));

            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(oc));

            assertThatThrownBy(() -> service.crearMaestroDesdeFacturaCompra(requestFacturaBase()))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.LINEA_SIN_FACTURAR);
        }

        @Test
        void lanzaExcepcionSiImporteNoCuadra() {
            var request = requestFacturaBase();
            request.setValorAdquisicion(new BigDecimal("100.0000"));

            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(ocBase()));

            assertThatThrownBy(() -> service.crearMaestroDesdeFacturaCompra(request))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.IMPORTE_NO_CUADRA_COMPRA);
        }

        @Test
        void lanzaExcepcionSiProveedorNoCoincide() {
            var request = requestFacturaBase();
            request.setProveedorId(77L);

            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(ocBase()));

            assertThatThrownBy(() -> service.crearMaestroDesdeFacturaCompra(request))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.PROVEEDOR_NO_COINCIDE_OC);
        }

        @Test
        void lanzaExcepcionSiFacturaDuplicada() {
            var request = requestFacturaBase();

            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(ocBase()));
            when(maestroRepository
                    .existsByProveedorIdAndFacturaProveedorSerieIgnoreCaseAndFacturaProveedorNumeroIgnoreCase(
                            eq(99L), eq("F001"), eq("000123")))
                    .thenReturn(true);

            assertThatThrownBy(() -> service.crearMaestroDesdeFacturaCompra(request))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", ActivosErrorCodes.FACTURA_PROVEEDOR_DUPLICADA);
        }

        @Test
        void noChequeaFacturaDuplicadaCuandoProveedorEsNullEnOcYRequest() {
            var oc = ocBase();
            oc.setProveedorId(null);
            var request = requestFacturaBase();
            request.setProveedorId(null);

            AfMaestro creado = new AfMaestro();
            creado.setId(60L);

            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(oc));
            when(maestroService.create(any())).thenReturn(creado);

            AfMaestro result = service.crearMaestroDesdeFacturaCompra(request);

            assertThat(result.getId()).isEqualTo(60L);
            // Verifica que NO se consulte la duplicidad si proveedor es null
            verify(maestroRepository, never())
                    .existsByProveedorIdAndFacturaProveedorSerieIgnoreCaseAndFacturaProveedorNumeroIgnoreCase(
                            any(), any(), any());
        }

        @Test
        void usaNombreDelRequestSiProvisto() {
            var request = requestFacturaBase();
            request.setNombre("Mi factura custom");
            AfMaestro creado = new AfMaestro();
            creado.setId(50L);

            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(ocBase()));
            when(maestroRepository
                    .existsByProveedorIdAndFacturaProveedorSerieIgnoreCaseAndFacturaProveedorNumeroIgnoreCase(
                            any(), any(), any()))
                    .thenReturn(false);
            when(maestroService.create(any())).thenReturn(creado);

            service.crearMaestroDesdeFacturaCompra(request);

            verify(maestroService).create(argThat(m -> "Mi factura custom".equals(m.getNombre())));
        }

        @Test
        void usaDescripcionLineaSiNombreBlank() {
            var request = requestFacturaBase();
            request.setNombre("   ");
            AfMaestro creado = new AfMaestro();
            creado.setId(50L);

            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(ocBase()));
            when(maestroRepository
                    .existsByProveedorIdAndFacturaProveedorSerieIgnoreCaseAndFacturaProveedorNumeroIgnoreCase(
                            any(), any(), any()))
                    .thenReturn(false);
            when(maestroService.create(any())).thenReturn(creado);

            service.crearMaestroDesdeFacturaCompra(request);

            verify(maestroService).create(argThat(m -> "Laptop contabilidad".equals(m.getNombre())));
        }

        @Test
        void usaCodigoSiNombreYDescripcionVacios() {
            var linea = lineaBase();
            linea.setArticuloDescripcion("   ");
            var oc = ocBase();
            oc.setLineas(List.of(linea));

            var request = requestFacturaBase();
            request.setNombre(null);

            AfMaestro creado = new AfMaestro();
            creado.setId(50L);

            when(maestroRepository.existsByOrdenCompraIdAndOrdenCompraLineaId(5L, 20L)).thenReturn(false);
            when(comprasClient.obtenerOrdenCompra(5L)).thenReturn(ApiResponse.ok(oc));
            when(maestroRepository
                    .existsByProveedorIdAndFacturaProveedorSerieIgnoreCaseAndFacturaProveedorNumeroIgnoreCase(
                            any(), any(), any()))
                    .thenReturn(false);
            when(maestroService.create(any())).thenReturn(creado);

            service.crearMaestroDesdeFacturaCompra(request);

            verify(maestroService).create(argThat(m -> "AF-FAC-01".equals(m.getNombre())));
        }
    }
}
