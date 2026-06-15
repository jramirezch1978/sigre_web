package com.sigre.almacen.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import com.sigre.almacen.domain.MovimientoErrorCode;
import com.sigre.almacen.dto.IntegracionRecepcionOcRequest;
import com.sigre.almacen.dto.IntegracionTrasladoEjecutarRequest;
import com.sigre.almacen.dto.IntegracionTrasladoResultadoResponse;
import com.sigre.almacen.dto.MovimientoCabeceraRequest;
import com.sigre.almacen.dto.MovimientoDetalleResponse;
import com.sigre.almacen.entity.Almacen;
import com.sigre.almacen.entity.ArticuloMovTipo;
import com.sigre.almacen.entity.OrdenTraslado;
import com.sigre.almacen.entity.OrdenTrasladoDet;
import com.sigre.almacen.entity.ValeMov;
import com.sigre.almacen.config.AlmacenIntegracionProperties;
import com.sigre.almacen.repository.*;
import com.sigre.almacen.service.RecepcionTresViasValidator;
import com.sigre.almacen.service.ValeMovService;
import com.sigre.common.exception.BusinessException;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static com.sigre.almacen.TestDataFactory.*;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class IntegracionAlmacenServiceImplTest {

    @Mock
    private ValeMovService valeMovService;
    @Mock
    private JdbcTemplate jdbcTemplate;
    @Mock
    private ArticuloMovTipoRepository articuloMovTipoRepository;
    @Mock
    private OrdenTrasladoRepository ordenTrasladoRepository;
    @Mock
    private OrdenTrasladoDetRepository ordenTrasladoDetRepository;
    @Mock
    private AlmacenRepository almacenRepository;
    @Mock
    private ValeMovRepository valeMovRepository;
    @Mock
    private RecepcionTresViasValidator recepcionTresViasValidator;
    @Mock
    private AlmacenIntegracionProperties integracionProperties;

    @InjectMocks
    private IntegracionAlmacenServiceImpl service;

    private ArticuloMovTipo tipoIngreso;

    @BeforeEach
    void setUp() {
        when(integracionProperties.isValidarTresVias()).thenReturn(false);
        tipoIngreso = articuloMovTipoIngreso(5L);
    }

    @Nested
    @DisplayName("recepcionarOrdenCompra")
    class RecepcionOc {

        @Test
        void construyeCabeceraYLlamaValeMovCrear() {
            when(articuloMovTipoRepository.findById(5L)).thenReturn(Optional.of(tipoIngreso));
            when(jdbcTemplate.queryForList(anyString(), eq(1L))).thenAnswer(inv -> {
                String sql = inv.getArgument(0);
                if (sql.contains("FROM compras.orden_compra WHERE")) {
                    return List.of(filaOrdenCompraJdbc(1L, 99L));
                }
                if (sql.contains("FROM compras.orden_compra_det")) {
                    return List.of(filaOrdenCompraDetJdbc(10L, 100L, 20L, new BigDecimal("10"), new BigDecimal("5.00")));
                }
                return List.of();
            });

            MovimientoDetalleResponse esperado = MovimientoDetalleResponse.builder().id(700L).build();
            when(valeMovService.crear(any(MovimientoCabeceraRequest.class))).thenReturn(esperado);

            IntegracionRecepcionOcRequest req = new IntegracionRecepcionOcRequest();
            req.setOrdenCompraId(1L);
            req.setArticuloMovTipoId(5L);
            req.setAlmacenId(20L);
            req.setFechaMov(LocalDate.of(2026, 4, 29));
            req.setObservaciones("Recibo OC");

            MovimientoDetalleResponse out = service.recepcionarOrdenCompra(req);

            assertThat(out.getId()).isEqualTo(700L);

            ArgumentCaptor<MovimientoCabeceraRequest> cap = ArgumentCaptor.forClass(MovimientoCabeceraRequest.class);
            verify(valeMovService).crear(cap.capture());
            MovimientoCabeceraRequest cab = cap.getValue();
            assertThat(cab.getSucursalId()).isEqualTo(1L);
            assertThat(cab.getAlmacenId()).isEqualTo(20L);
            assertThat(cab.getProveedorId()).isEqualTo(99L);
            assertThat(cab.getTipoReferenciaOrigen()).isEqualTo("I");
            assertThat(cab.getOrdenCompraId()).isEqualTo(1L);
            assertThat(cab.getArticuloMovTipoId()).isEqualTo(5L);
            assertThat(cab.getObservaciones()).isEqualTo("Recibo OC");
            assertThat(cab.getLineas()).hasSize(1);
            assertThat(cab.getLineas().get(0).getOcDetId()).isEqualTo(10L);
            assertThat(cab.getLineas().get(0).getCantProcesada()).isEqualByComparingTo("10");
        }

        @Test
        void ordenCompraInexistente() {
            when(articuloMovTipoRepository.findById(5L)).thenReturn(Optional.of(tipoIngreso));
            when(jdbcTemplate.queryForList(anyString(), eq(1L))).thenAnswer(inv -> {
                String sql = inv.getArgument(0);
                if (sql.contains("FROM compras.orden_compra WHERE")) {
                    return List.of();
                }
                return List.of();
            });

            IntegracionRecepcionOcRequest req = new IntegracionRecepcionOcRequest();
            req.setOrdenCompraId(1L);
            req.setArticuloMovTipoId(5L);
            req.setAlmacenId(20L);

            assertThatThrownBy(() -> service.recepcionarOrdenCompra(req))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("status", HttpStatus.NOT_FOUND)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.REFERENCIA_NO_ENCONTRADA);
        }

        @Test
        void sinLineasPendientes() {
            when(articuloMovTipoRepository.findById(5L)).thenReturn(Optional.of(tipoIngreso));
            when(jdbcTemplate.queryForList(anyString(), eq(1L))).thenAnswer(inv -> {
                String sql = inv.getArgument(0);
                if (sql.contains("FROM compras.orden_compra WHERE")) {
                    return List.of(Map.of("sucursal_id", 1L, "proveedor_id", 99L));
                }
                if (sql.contains("FROM compras.orden_compra_det")) {
                    return List.of();
                }
                return List.of();
            });

            IntegracionRecepcionOcRequest req = new IntegracionRecepcionOcRequest();
            req.setOrdenCompraId(1L);
            req.setArticuloMovTipoId(5L);
            req.setAlmacenId(20L);

            assertThatThrownBy(() -> service.recepcionarOrdenCompra(req))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("status", HttpStatus.UNPROCESSABLE_ENTITY)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.INTEGRACION_SIN_LINEAS_PENDIENTES);
        }

        @Test
        void rechazaArticuloDuplicadoEnOrigen() {
            when(articuloMovTipoRepository.findById(5L)).thenReturn(Optional.of(tipoIngreso));
            when(jdbcTemplate.queryForList(anyString(), eq(1L))).thenAnswer(inv -> {
                String sql = inv.getArgument(0);
                if (sql.contains("FROM compras.orden_compra WHERE")) {
                    return List.of(Map.of("sucursal_id", 1L, "proveedor_id", 99L));
                }
                if (sql.contains("FROM compras.orden_compra_det")) {
                    Map<String, Object> a = new HashMap<>();
                    a.put("id", 1L);
                    a.put("articulo_id", 100L);
                    a.put("cant_proyectada", new BigDecimal("5"));
                    a.put("cant_procesada", BigDecimal.ZERO);
                    a.put("valor_unitario", BigDecimal.ONE);
                    a.put("almacen_id", 20L);
                    a.put("centros_costo_id", null);
                    Map<String, Object> b = new HashMap<>(a);
                    b.put("id", 2L);
                    return List.of(a, b);
                }
                return List.of();
            });

            IntegracionRecepcionOcRequest req = new IntegracionRecepcionOcRequest();
            req.setOrdenCompraId(1L);
            req.setArticuloMovTipoId(5L);
            req.setAlmacenId(20L);

            assertThatThrownBy(() -> service.recepcionarOrdenCompra(req))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.INTEGRACION_ARTICULO_DUPLICADO_EN_ORIGEN);
        }

        @Test
        void conValidarTresVias_invocaValidator() {
            when(integracionProperties.isValidarTresVias()).thenReturn(true);
            when(integracionProperties.getToleranciaTresVias()).thenReturn(new BigDecimal("0.0001"));
            when(articuloMovTipoRepository.findById(5L)).thenReturn(Optional.of(tipoIngreso));
            when(jdbcTemplate.queryForList(anyString(), eq(1L))).thenAnswer(inv -> {
                String sql = inv.getArgument(0);
                if (sql.contains("FROM compras.orden_compra WHERE")) {
                    return List.of(filaOrdenCompraJdbc(1L, 99L));
                }
                if (sql.contains("FROM compras.orden_compra_det")) {
                    return List.of(filaOrdenCompraDetJdbc(10L, 100L, 20L, new BigDecimal("10"), new BigDecimal("5.00")));
                }
                return List.of();
            });
            when(valeMovService.crear(any())).thenReturn(MovimientoDetalleResponse.builder().id(1L).build());

            IntegracionRecepcionOcRequest req = new IntegracionRecepcionOcRequest();
            req.setOrdenCompraId(1L);
            req.setArticuloMovTipoId(5L);
            req.setAlmacenId(20L);

            service.recepcionarOrdenCompra(req);

            verify(recepcionTresViasValidator).validarRecepcionOc(eq(1L), eq(20L), eq(null), any());
        }

        @Test
        void tipoMovimientoDebeSerClaseI() {
            ArticuloMovTipo tipoMal = new ArticuloMovTipo();
            tipoMal.setId(5L);
            tipoMal.setFlagEstado("1");
            tipoMal.setFlagSolicitaRef("1");
            tipoMal.setFlagClaseMov("V");
            when(articuloMovTipoRepository.findById(5L)).thenReturn(Optional.of(tipoMal));

            IntegracionRecepcionOcRequest req = new IntegracionRecepcionOcRequest();
            req.setOrdenCompraId(1L);
            req.setArticuloMovTipoId(5L);
            req.setAlmacenId(20L);

            assertThatThrownBy(() -> service.recepcionarOrdenCompra(req))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.INTEGRACION_TIPO_MOV_INVALIDO);
        }
    }

    @Nested
    @DisplayName("ejecutarTraslado")
    class EjecutarTraslado {

        private ArticuloMovTipo tipoTrasladoSalida(boolean movEntreAlm) {
            ArticuloMovTipo tipo = new ArticuloMovTipo();
            tipo.setId(7L);
            tipo.setFlagEstado("1");
            tipo.setFlagSolicitaRef("1");
            tipo.setFlagClaseMov("T");
            tipo.setFlagMovEntreAlm(movEntreAlm ? "1" : "0");
            return tipo;
        }

        @Test
        void siNoApareceValeEspejoTrasSalidaLanzaError() {
            ArticuloMovTipo tipo = tipoTrasladoSalida(true);
            when(articuloMovTipoRepository.findById(7L)).thenReturn(Optional.of(tipo));

            OrdenTraslado ot = new OrdenTraslado();
            ot.setId(50L);
            ot.setAlmacenOrigenId(10L);
            ot.setAlmacenDestinoId(11L);
            ot.setFecha(LocalDate.of(2026, 5, 1));
            when(ordenTrasladoRepository.findByIdForUpdate(50L)).thenReturn(Optional.of(ot));

            Almacen alm = new Almacen();
            alm.setSucursalId(3L);
            when(almacenRepository.findById(10L)).thenReturn(Optional.of(alm));

            OrdenTrasladoDet det = new OrdenTrasladoDet();
            det.setId(200L);
            det.setArticuloId(100L);
            det.setCantidad(new BigDecimal("5"));
            det.setCantidadDespachada(BigDecimal.ZERO);
            when(ordenTrasladoDetRepository.findByOrdenTrasladoIdOrderById(50L)).thenReturn(List.of(det));

            MovimientoDetalleResponse salidaResp = MovimientoDetalleResponse.builder().id(900L).build();
            when(valeMovService.crear(any(MovimientoCabeceraRequest.class))).thenReturn(salidaResp);
            when(valeMovRepository.findFirstByOrdenTrasladoIdAndIdGreaterThanOrderByIdAsc(50L, 900L))
                    .thenReturn(Optional.empty());

            IntegracionTrasladoEjecutarRequest req = new IntegracionTrasladoEjecutarRequest();
            req.setOrdenTrasladoId(50L);
            req.setArticuloMovTipoId(7L);

            assertThatThrownBy(() -> service.ejecutarTraslado(req))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.INTEGRACION_ESPEJO_NO_GENERADO);
        }

        @Test
        void conMovEntreAlmBuscaEspejoYObtieneDetalleIngreso() {
            ArticuloMovTipo tipo = tipoTrasladoSalida(true);
            when(articuloMovTipoRepository.findById(7L)).thenReturn(Optional.of(tipo));

            OrdenTraslado ot = new OrdenTraslado();
            ot.setId(50L);
            ot.setAlmacenOrigenId(10L);
            ot.setAlmacenDestinoId(11L);
            ot.setFecha(LocalDate.of(2026, 5, 1));
            when(ordenTrasladoRepository.findByIdForUpdate(50L)).thenReturn(Optional.of(ot));

            Almacen alm = new Almacen();
            alm.setSucursalId(3L);
            when(almacenRepository.findById(10L)).thenReturn(Optional.of(alm));

            OrdenTrasladoDet det = new OrdenTrasladoDet();
            det.setId(200L);
            det.setArticuloId(100L);
            det.setCantidad(new BigDecimal("5"));
            det.setCantidadDespachada(BigDecimal.ZERO);
            when(ordenTrasladoDetRepository.findByOrdenTrasladoIdOrderById(50L)).thenReturn(List.of(det));

            MovimientoDetalleResponse salidaResp = MovimientoDetalleResponse.builder().id(900L).build();
            when(valeMovService.crear(any(MovimientoCabeceraRequest.class))).thenReturn(salidaResp);

            ValeMov espejoRow = new ValeMov();
            espejoRow.setId(901L);
            when(valeMovRepository.findFirstByOrdenTrasladoIdAndIdGreaterThanOrderByIdAsc(50L, 900L))
                    .thenReturn(Optional.of(espejoRow));

            MovimientoDetalleResponse ingresoDet = MovimientoDetalleResponse.builder().id(901L).build();
            when(valeMovService.obtener(901L)).thenReturn(ingresoDet);

            IntegracionTrasladoEjecutarRequest req = new IntegracionTrasladoEjecutarRequest();
            req.setOrdenTrasladoId(50L);
            req.setArticuloMovTipoId(7L);

            IntegracionTrasladoResultadoResponse out = service.ejecutarTraslado(req);

            assertThat(out.getMovimientoSalida()).isEqualTo(salidaResp);
            assertThat(out.getMovimientoIngreso()).isEqualTo(ingresoDet);
            verify(valeMovService).obtener(901L);
        }

        @Test
        void sinCantidadPendienteLanzaError() {
            ArticuloMovTipo tipo = tipoTrasladoSalida(true);
            when(articuloMovTipoRepository.findById(7L)).thenReturn(Optional.of(tipo));

            OrdenTraslado ot = new OrdenTraslado();
            ot.setId(50L);
            ot.setAlmacenOrigenId(10L);
            ot.setAlmacenDestinoId(11L);
            ot.setFecha(LocalDate.of(2026, 5, 1));
            when(ordenTrasladoRepository.findByIdForUpdate(50L)).thenReturn(Optional.of(ot));

            Almacen alm = new Almacen();
            alm.setSucursalId(3L);
            when(almacenRepository.findById(10L)).thenReturn(Optional.of(alm));

            OrdenTrasladoDet det = new OrdenTrasladoDet();
            det.setId(200L);
            det.setArticuloId(100L);
            det.setCantidad(new BigDecimal("5"));
            det.setCantidadDespachada(new BigDecimal("5"));
            when(ordenTrasladoDetRepository.findByOrdenTrasladoIdOrderById(50L)).thenReturn(List.of(det));

            IntegracionTrasladoEjecutarRequest req = new IntegracionTrasladoEjecutarRequest();
            req.setOrdenTrasladoId(50L);
            req.setArticuloMovTipoId(7L);

            assertThatThrownBy(() -> service.ejecutarTraslado(req))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.INTEGRACION_SIN_LINEAS_PENDIENTES);
            verify(valeMovService, never()).crear(any());
        }
    }

    @Nested
    @DisplayName("despacharOrdenVenta")
    class DespacharOv {

        @Test
        void construyeCabeceraYLlamaValeMovCrear() {
            ArticuloMovTipo tipo = articuloMovTipoSalidaOv(2L);
            when(articuloMovTipoRepository.findById(2L)).thenReturn(Optional.of(tipo));
            when(jdbcTemplate.queryForList(anyString(), eq(201L))).thenAnswer(inv -> {
                String sql = inv.getArgument(0);
                if (sql.contains("FROM ventas.orden_venta WHERE")) {
                    return List.of(filaOrdenVentaJdbc(1L));
                }
                if (sql.contains("FROM ventas.orden_venta_det")) {
                    return List.of(filaOrdenVentaDetJdbc(30L, 100L, 10L, new BigDecimal("8"), new BigDecimal("12.50")));
                }
                return List.of();
            });

            MovimientoDetalleResponse esperado = MovimientoDetalleResponse.builder().id(801L).build();
            when(valeMovService.crear(any(MovimientoCabeceraRequest.class))).thenReturn(esperado);

            var req = integracionSalidaOvRequest();
            MovimientoDetalleResponse out = service.despacharOrdenVenta(req);

            assertThat(out.getId()).isEqualTo(801L);

            ArgumentCaptor<MovimientoCabeceraRequest> cap = ArgumentCaptor.forClass(MovimientoCabeceraRequest.class);
            verify(valeMovService).crear(cap.capture());
            MovimientoCabeceraRequest cab = cap.getValue();
            assertThat(cab.getSucursalId()).isEqualTo(1L);
            assertThat(cab.getAlmacenId()).isEqualTo(10L);
            assertThat(cab.getTipoReferenciaOrigen()).isEqualTo("V");
            assertThat(cab.getOrdenVentaId()).isEqualTo(201L);
            assertThat(cab.getLineas()).hasSize(1);
            assertThat(cab.getLineas().get(0).getOrdenVentaDetId()).isEqualTo(30L);
            assertThat(cab.getLineas().get(0).getCantProcesada()).isEqualByComparingTo("8");
        }

        @Test
        void ordenVentaInexistente() {
            when(articuloMovTipoRepository.findById(2L)).thenReturn(Optional.of(articuloMovTipoSalidaOv(2L)));
            when(jdbcTemplate.queryForList(anyString(), eq(201L))).thenReturn(List.of());

            var req = integracionSalidaOvRequest();

            assertThatThrownBy(() -> service.despacharOrdenVenta(req))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("status", HttpStatus.NOT_FOUND)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.REFERENCIA_NO_ENCONTRADA);
        }

        @Test
        void sinLineasPendientes() {
            when(articuloMovTipoRepository.findById(2L)).thenReturn(Optional.of(articuloMovTipoSalidaOv(2L)));
            when(jdbcTemplate.queryForList(anyString(), eq(201L))).thenAnswer(inv -> {
                String sql = inv.getArgument(0);
                if (sql.contains("FROM ventas.orden_venta WHERE")) {
                    return List.of(filaOrdenVentaJdbc(1L));
                }
                if (sql.contains("FROM ventas.orden_venta_det")) {
                    return List.of();
                }
                return List.of();
            });

            var req = integracionSalidaOvRequest();

            assertThatThrownBy(() -> service.despacharOrdenVenta(req))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.INTEGRACION_SIN_LINEAS_PENDIENTES);
        }

        @Test
        void rechazaArticuloDuplicadoEnOrigen() {
            when(articuloMovTipoRepository.findById(2L)).thenReturn(Optional.of(articuloMovTipoSalidaOv(2L)));
            when(jdbcTemplate.queryForList(anyString(), eq(201L))).thenAnswer(inv -> {
                String sql = inv.getArgument(0);
                if (sql.contains("FROM ventas.orden_venta WHERE")) {
                    return List.of(filaOrdenVentaJdbc(1L));
                }
                if (sql.contains("FROM ventas.orden_venta_det")) {
                    Map<String, Object> a = filaOrdenVentaDetJdbc(1L, 100L, 10L, new BigDecimal("5"), BigDecimal.ONE);
                    Map<String, Object> b = filaOrdenVentaDetJdbc(2L, 100L, 10L, new BigDecimal("3"), BigDecimal.ONE);
                    return List.of(a, b);
                }
                return List.of();
            });

            var req = integracionSalidaOvRequest();

            assertThatThrownBy(() -> service.despacharOrdenVenta(req))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.INTEGRACION_ARTICULO_DUPLICADO_EN_ORIGEN);
        }

        @Test
        void tipoMovimientoDebeSerClaseV() {
            ArticuloMovTipo tipoMal = articuloMovTipoIngreso(2L);
            tipoMal.setFlagClaseMov("I");
            when(articuloMovTipoRepository.findById(2L)).thenReturn(Optional.of(tipoMal));

            var req = integracionSalidaOvRequest();

            assertThatThrownBy(() -> service.despacharOrdenVenta(req))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.INTEGRACION_TIPO_MOV_INVALIDO);
        }
    }
}
