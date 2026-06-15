package com.sigre.almacen.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.ArgumentMatchers;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.mock.web.MockMultipartFile;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import org.springframework.test.util.ReflectionTestUtils;
import com.sigre.almacen.domain.MovimientoErrorCode;
import com.sigre.almacen.domain.ValeMovFlagEstado;
import com.sigre.almacen.dto.*;
import com.sigre.almacen.entity.*;
import com.sigre.almacen.repository.*;
import com.sigre.almacen.service.EmpresaInfoService;
import com.sigre.almacen.support.UsuarioResumenLoader;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.service.NumeradorDocumentoService;

import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static com.sigre.almacen.TestDataFactory.*;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class ValeMovServiceImplTest {

    @Mock private ValeMovRepository valeMovRepository;
    @Mock private ArticuloMovTipoRepository articuloMovTipoRepository;
    @Mock private AlmacenRepository almacenRepository;
    @Mock private AlmacenTipoMovRepository almacenTipoMovRepository;
    @Mock private UbicacionAlmacenRepository ubicacionAlmacenRepository;
    @Mock private ArticuloAlmacenRepository articuloAlmacenRepository;
    @Mock private ArticuloAlmacenPosicionRepository articuloAlmacenPosicionRepository;
    @Mock private ArticuloSaldoMensualRepository articuloSaldoMensualRepository;
    @Mock private CntblCierreRepository cntblCierreRepository;
    @Mock private ArticuloRefRepository articuloRefRepository;
    @Mock private ArticuloSubCategRefRepository articuloSubCategRefRepository;
    @Mock private TipoMovMatrizSubcatRepository tipoMovMatrizSubcatRepository;
    @Mock private OrdenTrasladoRepository ordenTrasladoRepository;
    @Mock private GuiaRepository guiaRepository;
    @Mock private JdbcTemplate jdbcTemplate;
    @Mock private NumeradorDocumentoService numeradorDocumentoService;
    @Mock private SucursalRefRepository sucursalRefRepository;
    @Mock private EntidadContribuyenteRefRepository entidadContribuyenteRefRepository;
    @Mock private UnidadMedidaRefRepository unidadMedidaRefRepository;
    @Mock private EmpresaInfoService empresaInfoService;
    @Mock private UsuarioResumenLoader usuarioResumenLoader;
    @Mock private com.sigre.almacen.event.publisher.AlmacenPreAsientoPublisher preAsientoPublisher;

    @InjectMocks
    private ValeMovServiceImpl service;

    private ArticuloMovTipo tipoBase;
    private MovimientoCabeceraRequest requestBase;

    @BeforeEach
    void setUp() {
        lenient().when(jdbcTemplate.queryForList(anyString(), ArgumentMatchers.<Object>any())).thenReturn(List.of());
        lenient().when(jdbcTemplate.update(anyString(), any(), any(), any(), any())).thenReturn(1);
        lenient().when(jdbcTemplate.update(anyString(), any(), any(), any(), any(), any())).thenReturn(1);
        lenient().when(usuarioResumenLoader.loadByIds(any())).thenReturn(Map.of());
        lenient().when(articuloRefRepository.findAllById(any())).thenReturn(List.of());
        tipoBase = articuloMovTipoIngreso(1L);
        tipoBase.setFlagClaseMov(null);
        tipoBase.setFlagSolicitaRef("0");
        requestBase = movimientoCabeceraRequest();
    }

    private void setupMocksForCrear() {
        when(articuloMovTipoRepository.findById(1L)).thenReturn(Optional.of(tipoBase));
        when(almacenRepository.existsById(10L)).thenReturn(true);
        when(almacenTipoMovRepository.existsByAlmacenIdAndArticuloMovTipoIdAndFlagEstado(10L, 1L, "1"))
                .thenReturn(true);
        when(cntblCierreRepository.findByAnoAndMes(anyInt(), anyInt())).thenReturn(Optional.empty());
        when(articuloAlmacenRepository.findByAlmacenIdAndArticuloId(anyLong(), anyLong()))
                .thenReturn(Optional.of(articuloAlmacen(10L, 100L, new BigDecimal("100"), new BigDecimal("5.00"))));
        when(articuloAlmacenRepository.save(any(ArticuloAlmacen.class))).thenAnswer(i -> i.getArgument(0));
        when(articuloSaldoMensualRepository.save(any(ArticuloSaldoMensual.class))).thenAnswer(i -> i.getArgument(0));
        when(numeradorDocumentoService.siguienteNroDocumento(anyString(), anyLong(), anyInt()))
                .thenReturn("VALE-00000001");
        when(valeMovRepository.save(any(ValeMov.class))).thenAnswer(invocation -> {
            ValeMov mov = invocation.getArgument(0);
            mov.setId(1L);
            return mov;
        });
    }

    // ────────────────────────────────────────────────────────────────────
    // T6: Validación de artículos duplicados
    // ────────────────────────────────────────────────────────────────────

    @Nested
    @DisplayName("Validación: artículos duplicados en detalle")
    class ArticuloDuplicadoTests {

        @Test
        @DisplayName("rechaza vale con artículo duplicado en el detalle")
        void crear_articuloDuplicado_lanzaError() {
            setupMocksForCrear();

            MovimientoLineaRequest linea1 = new MovimientoLineaRequest();
            linea1.setArticuloId(100L);
            linea1.setCantProcesada(new BigDecimal("5"));
            linea1.setCostoUnitario(new BigDecimal("10"));

            MovimientoLineaRequest linea2 = new MovimientoLineaRequest();
            linea2.setArticuloId(100L);
            linea2.setCantProcesada(new BigDecimal("3"));
            linea2.setCostoUnitario(new BigDecimal("10"));

            requestBase.setLineas(List.of(linea1, linea2));

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo(MovimientoErrorCode.ARTICULO_DUPLICADO);
                    });
        }

        @Test
        @DisplayName("acepta vale con artículos distintos en cada línea")
        void crear_articulosDistintos_ok() {
            setupMocksForCrear();

            when(articuloAlmacenRepository.findByAlmacenIdAndArticuloId(eq(10L), eq(200L)))
                    .thenReturn(Optional.of(articuloAlmacen(10L, 200L, new BigDecimal("50"), new BigDecimal("8.00"))));

            MovimientoLineaRequest linea1 = new MovimientoLineaRequest();
            linea1.setArticuloId(100L);
            linea1.setCantProcesada(new BigDecimal("5"));
            linea1.setCostoUnitario(new BigDecimal("10"));

            MovimientoLineaRequest linea2 = new MovimientoLineaRequest();
            linea2.setArticuloId(200L);
            linea2.setCantProcesada(new BigDecimal("3"));
            linea2.setCostoUnitario(new BigDecimal("8"));

            requestBase.setLineas(List.of(linea1, linea2));

            MovimientoDetalleResponse result = service.crear(requestBase);

            assertThat(result).isNotNull();
            verify(valeMovRepository).save(any(ValeMov.class));
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // T4: Validación coherencia flag_clase_mov ↔ tipoReferenciaOrigen
    // ────────────────────────────────────────────────────────────────────

    @Nested
    @DisplayName("Validación: coherencia flag_clase_mov vs tipoReferenciaOrigen")
    class CoherenciaClaseMovTests {

        @Test
        @DisplayName("rechaza cuando flag_clase_mov no coincide con tipoReferenciaOrigen")
        void crear_claseNoCoincide_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            tipoBase.setFlagClaseMov("I");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("T");
            requestBase.setOrdenTrasladoId(50L);

            OrdenTraslado ot = new OrdenTraslado();
            ot.setId(50L);
            ot.setFlagEstado("1");
            when(ordenTrasladoRepository.findByIdForUpdate(50L)).thenReturn(Optional.of(ot));

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo(MovimientoErrorCode.COHERENCIA_CLASE_MOV);
                    });
        }

        @Test
        @DisplayName("acepta cuando flag_clase_mov coincide con tipoReferenciaOrigen")
        void crear_claseCoincide_ok() {
            tipoBase.setFlagSolicitaRef("1");
            tipoBase.setFlagClaseMov("I");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("I");
            requestBase.setOrdenCompraId(50L);

            when(valeMovRepository.obtenerFlagEstadoOrdenCompra(50L)).thenReturn("1");

            MovimientoDetalleResponse result = service.crear(requestBase);

            assertThat(result).isNotNull();
        }

        @Test
        @DisplayName("no valida coherencia si flag_clase_mov es null")
        void crear_claseMovNull_noValidaCoherencia() {
            tipoBase.setFlagSolicitaRef("1");
            tipoBase.setFlagClaseMov(null);
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("I");
            requestBase.setOrdenCompraId(50L);

            when(valeMovRepository.obtenerFlagEstadoOrdenCompra(50L)).thenReturn("1");

            MovimientoDetalleResponse result = service.crear(requestBase);

            assertThat(result).isNotNull();
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // T5: Validación existencia y estado del FK de referencia
    // ────────────────────────────────────────────────────────────────────

    @Nested
    @DisplayName("Validación: existencia y estado de referencia OC/OT")
    class ReferenciaExistenciaTests {

        @Test
        @DisplayName("rechaza OC que no existe")
        void crear_ocNoExiste_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("I");
            requestBase.setOrdenCompraId(999L);

            when(valeMovRepository.obtenerFlagEstadoOrdenCompra(999L)).thenReturn(null);

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo(MovimientoErrorCode.REFERENCIA_NO_ENCONTRADA);
                    });
        }

        @Test
        @DisplayName("rechaza OC con flag_estado distinto a 1")
        void crear_ocEstadoInvalido_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("I");
            requestBase.setOrdenCompraId(50L);

            when(valeMovRepository.obtenerFlagEstadoOrdenCompra(50L)).thenReturn("0");

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo(MovimientoErrorCode.REFERENCIA_ESTADO_INVALIDO);
                    });
        }

        @Test
        @DisplayName("rechaza OT que no existe")
        void crear_otNoExiste_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("T");
            requestBase.setOrdenTrasladoId(999L);

            when(ordenTrasladoRepository.findByIdForUpdate(999L)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo(MovimientoErrorCode.REFERENCIA_NO_ENCONTRADA);
                    });
        }

        @Test
        @DisplayName("rechaza OT con estado CERRADA")
        void crear_otEstadoCerrada_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("T");
            requestBase.setOrdenTrasladoId(50L);

            OrdenTraslado ot = new OrdenTraslado();
            ot.setId(50L);
            ot.setNumero("OT-001");
            ot.setFlagEstado("2");
            when(ordenTrasladoRepository.findByIdForUpdate(50L)).thenReturn(Optional.of(ot));
            when(ordenTrasladoRepository.findById(50L)).thenReturn(Optional.of(ot));

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo(MovimientoErrorCode.REFERENCIA_ESTADO_INVALIDO);
                    });
        }

        @Test
        @DisplayName("acepta OT con estado APROBADA")
        void crear_otAprobada_ok() {
            tipoBase.setFlagSolicitaRef("1");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("T");
            requestBase.setOrdenTrasladoId(50L);

            OrdenTraslado ot = new OrdenTraslado();
            ot.setId(50L);
            ot.setNumero("OT-001");
            ot.setFlagEstado("1");
            when(ordenTrasladoRepository.findByIdForUpdate(50L)).thenReturn(Optional.of(ot));
            when(ordenTrasladoRepository.findById(50L)).thenReturn(Optional.of(ot));

            MovimientoDetalleResponse result = service.crear(requestBase);

            assertThat(result).isNotNull();
        }

        @Test
        @DisplayName("acepta OT con estado EN_PROCESO")
        void crear_otEnProceso_ok() {
            tipoBase.setFlagSolicitaRef("1");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("T");
            requestBase.setOrdenTrasladoId(50L);

            OrdenTraslado ot = new OrdenTraslado();
            ot.setId(50L);
            ot.setNumero("OT-001");
            ot.setFlagEstado("1");
            when(ordenTrasladoRepository.findByIdForUpdate(50L)).thenReturn(Optional.of(ot));
            when(ordenTrasladoRepository.findById(50L)).thenReturn(Optional.of(ot));

            MovimientoDetalleResponse result = service.crear(requestBase);

            assertThat(result).isNotNull();
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // T7: Bloqueos de anulación
    // ────────────────────────────────────────────────────────────────────

    @Nested
    @DisplayName("Validación: bloqueos de anulación")
    class BloqueosAnulacionTests {

        private ValeMov valeActivo;

        @BeforeEach
        void setUpVale() {
            valeActivo = new ValeMov();
            valeActivo.setId(1L);
            valeActivo.setFlagEstado(ValeMovFlagEstado.ACTIVO);
            valeActivo.setFechaMov(LocalDate.of(2026, 4, 17));
            valeActivo.setArticuloMovTipoId(1L);
            valeActivo.setAlmacenId(10L);

            ValeMovDet det = new ValeMovDet();
            det.setId(10L);
            det.setArticuloId(100L);
            det.setCantProcesada(new BigDecimal("5"));
            det.setCostoUnitario(new BigDecimal("10"));
            det.setFlagEstado("1");
            valeActivo.addLinea(det);
        }

        @Test
        @DisplayName("rechaza anulación si tiene guía de remisión activa")
        void anular_guiaActiva_lanzaError() {
            when(valeMovRepository.findById(1L)).thenReturn(Optional.of(valeActivo));
            when(cntblCierreRepository.findByAnoAndMes(anyInt(), anyInt())).thenReturn(Optional.empty());
            when(valeMovRepository.tieneGuiaRemisionActiva(1L)).thenReturn(true);

            MovimientoAnularRequest req = new MovimientoAnularRequest();
            req.setId(1L);
            req.setMotivo("Prueba");

            assertThatThrownBy(() -> service.anular(req))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo(MovimientoErrorCode.NO_ANULAR_GUIA_ACTIVA);
                    });
        }

        @Test
        @DisplayName("rechaza anulación si tiene cantidad facturada")
        void anular_facturado_lanzaError() {
            when(valeMovRepository.findById(1L)).thenReturn(Optional.of(valeActivo));
            when(cntblCierreRepository.findByAnoAndMes(anyInt(), anyInt())).thenReturn(Optional.empty());
            when(valeMovRepository.tieneGuiaRemisionActiva(1L)).thenReturn(false);
            when(valeMovRepository.tieneCantidadFacturada(1L)).thenReturn(true);

            MovimientoAnularRequest req = new MovimientoAnularRequest();
            req.setId(1L);
            req.setMotivo("Prueba");

            assertThatThrownBy(() -> service.anular(req))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo(MovimientoErrorCode.NO_ANULAR_FACTURADO);
                    });
        }

        @Test
        @DisplayName("rechaza anulación si tiene consignación activa")
        void anular_consignacion_lanzaError() {
            when(valeMovRepository.findById(1L)).thenReturn(Optional.of(valeActivo));
            when(cntblCierreRepository.findByAnoAndMes(anyInt(), anyInt())).thenReturn(Optional.empty());
            when(valeMovRepository.tieneGuiaRemisionActiva(1L)).thenReturn(false);
            when(valeMovRepository.tieneCantidadFacturada(1L)).thenReturn(false);
            when(valeMovRepository.tieneConsignacionActiva(1L)).thenReturn(true);

            MovimientoAnularRequest req = new MovimientoAnularRequest();
            req.setId(1L);
            req.setMotivo("Prueba");

            assertThatThrownBy(() -> service.anular(req))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo(MovimientoErrorCode.NO_ANULAR_CONSIGNACION);
                    });
        }

        @Test
        @DisplayName("rechaza anulación si tiene guía de recepción MP")
        void anular_guiaRecepcionMP_lanzaError() {
            when(valeMovRepository.findById(1L)).thenReturn(Optional.of(valeActivo));
            when(cntblCierreRepository.findByAnoAndMes(anyInt(), anyInt())).thenReturn(Optional.empty());
            when(valeMovRepository.tieneGuiaRemisionActiva(1L)).thenReturn(false);
            when(valeMovRepository.tieneCantidadFacturada(1L)).thenReturn(false);
            when(valeMovRepository.tieneConsignacionActiva(1L)).thenReturn(false);
            when(valeMovRepository.tieneGuiaRecepcionMP(1L)).thenReturn(true);

            MovimientoAnularRequest req = new MovimientoAnularRequest();
            req.setId(1L);
            req.setMotivo("Prueba");

            assertThatThrownBy(() -> service.anular(req))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo(MovimientoErrorCode.NO_ANULAR_GUIA_RECEPCION_MP);
                    });
        }

        @Test
        @DisplayName("permite anulación si no tiene bloqueos")
        void anular_sinBloqueos_ok() {
            when(valeMovRepository.findById(1L)).thenReturn(Optional.of(valeActivo));
            when(cntblCierreRepository.findByAnoAndMes(anyInt(), anyInt())).thenReturn(Optional.empty());
            when(valeMovRepository.tieneGuiaRemisionActiva(1L)).thenReturn(false);
            when(valeMovRepository.tieneCantidadFacturada(1L)).thenReturn(false);
            when(valeMovRepository.tieneConsignacionActiva(1L)).thenReturn(false);
            when(valeMovRepository.tieneGuiaRecepcionMP(1L)).thenReturn(false);
            when(articuloMovTipoRepository.findById(1L)).thenReturn(Optional.of(tipoBase));
            when(articuloAlmacenRepository.findByAlmacenIdAndArticuloId(anyLong(), anyLong()))
                    .thenReturn(Optional.of(articuloAlmacen(10L, 100L, new BigDecimal("100"), new BigDecimal("5.00"))));
            when(articuloAlmacenRepository.save(any(ArticuloAlmacen.class))).thenAnswer(i -> i.getArgument(0));
            when(articuloSaldoMensualRepository.save(any(ArticuloSaldoMensual.class))).thenAnswer(i -> i.getArgument(0));
            when(valeMovRepository.save(any(ValeMov.class))).thenAnswer(i -> i.getArgument(0));

            MovimientoAnularRequest req = new MovimientoAnularRequest();
            req.setId(1L);
            req.setMotivo("Prueba");

            MovimientoDetalleResponse result = service.anular(req);

            assertThat(result).isNotNull();
            assertThat(result.getFlagEstado()).isEqualTo("0");
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // T8: Validación coherencia FK línea ↔ FK cabecera
    // ────────────────────────────────────────────────────────────────────

    @Nested
    @DisplayName("Validación: coherencia FK línea vs FK cabecera")
    class CoherenciaFKLineaTests {

        @Test
        @DisplayName("rechaza ocDetId sin ordenCompraId en cabecera")
        void crear_ocDetIdSinOrdenCompra_lanzaError() {
            setupMocksForCrear();

            MovimientoLineaRequest linea = new MovimientoLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantProcesada(new BigDecimal("10"));
            linea.setCostoUnitario(new BigDecimal("5"));
            linea.setOcDetId(500L);

            requestBase.setOrdenCompraId(null);
            requestBase.setLineas(List.of(linea));

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo(MovimientoErrorCode.FK_LINEA_NO_CORRESPONDE);
                    });
        }

        @Test
        @DisplayName("rechaza ordenTrasladoDetId sin ordenTrasladoId en cabecera")
        void crear_otDetIdSinOrdenTraslado_lanzaError() {
            setupMocksForCrear();

            MovimientoLineaRequest linea = new MovimientoLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantProcesada(new BigDecimal("10"));
            linea.setCostoUnitario(new BigDecimal("5"));
            linea.setOrdenTrasladoDetId(500L);

            requestBase.setOrdenTrasladoId(null);
            requestBase.setLineas(List.of(linea));

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo(MovimientoErrorCode.FK_LINEA_NO_CORRESPONDE);
                    });
        }

        @Test
        @DisplayName("rechaza ordenVentaDetId sin ordenVentaId en cabecera")
        void crear_ovDetIdSinOrdenVenta_lanzaError() {
            setupMocksForCrear();

            MovimientoLineaRequest linea = new MovimientoLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantProcesada(new BigDecimal("10"));
            linea.setCostoUnitario(new BigDecimal("5"));
            linea.setOrdenVentaDetId(500L);

            requestBase.setOrdenVentaId(null);
            requestBase.setLineas(List.of(linea));

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo(MovimientoErrorCode.FK_LINEA_NO_CORRESPONDE);
                    });
        }

        @Test
        @DisplayName("rechaza operacionesDetId sin ordenTrabajoId en cabecera")
        void crear_operDetIdSinOrdenTrabajo_lanzaError() {
            setupMocksForCrear();

            MovimientoLineaRequest linea = new MovimientoLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantProcesada(new BigDecimal("10"));
            linea.setCostoUnitario(new BigDecimal("5"));
            linea.setOperacionesDetId(500L);

            requestBase.setOrdenTrabajoId(null);
            requestBase.setLineas(List.of(linea));

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo(MovimientoErrorCode.FK_LINEA_NO_CORRESPONDE);
                    });
        }

        @Test
        @DisplayName("acepta ocDetId cuando ordenCompraId está presente en cabecera")
        void crear_ocDetIdConOrdenCompra_ok() {
            tipoBase.setFlagSolicitaRef("1");
            setupMocksForCrear();

            MovimientoLineaRequest linea = new MovimientoLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantProcesada(new BigDecimal("10"));
            linea.setCostoUnitario(new BigDecimal("5"));
            linea.setOcDetId(500L);

            requestBase.setTipoReferenciaOrigen("I");
            requestBase.setOrdenCompraId(50L);
            requestBase.setLineas(List.of(linea));

            when(valeMovRepository.obtenerFlagEstadoOrdenCompra(50L)).thenReturn("1");

            Map<String, Object> ocDetRow = new HashMap<>();
            ocDetRow.put("orden_compra_id", 50L);
            ocDetRow.put("articulo_id", 100L);
            ocDetRow.put("cant_proyectada", new BigDecimal("100"));
            ocDetRow.put("cant_procesada", BigDecimal.ZERO);
            when(jdbcTemplate.queryForList(contains("orden_compra_det"), eq(500L))).thenReturn(List.of(ocDetRow));

            MovimientoDetalleResponse result = service.crear(requestBase);

            assertThat(result).isNotNull();
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // T9: Artículo sin subcategoría en resolución de matriz
    // ────────────────────────────────────────────────────────────────────

    @Nested
    @DisplayName("Validación: artículo sin subcategoría con tipo que contabiliza")
    class ArticuloSinSubcategoriaTests {

        @Test
        @DisplayName("lanza error si artículo no tiene subcategoría y tipo contabiliza")
        void crear_sinSubcategoria_lanzaError() {
            tipoBase.setFlagContabiliza("1");
            setupMocksForCrear();

            when(articuloRefRepository.findById(100L)).thenReturn(Optional.of(crearArticuloRef(null)));

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo(MovimientoErrorCode.ARTICULO_SIN_SUBCATEGORIA);
                    });
        }

        @Test
        @DisplayName("lanza error si subcategoría del artículo no tiene cod_sub_cat")
        void crear_subcategoriaSinCodigo_lanzaError() {
            tipoBase.setFlagContabiliza("1");
            setupMocksForCrear();

            when(articuloRefRepository.findById(100L)).thenReturn(Optional.of(crearArticuloRef(50L)));
            when(articuloSubCategRefRepository.findById(50L)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo(MovimientoErrorCode.ARTICULO_SIN_SUBCATEGORIA);
                    });
        }

        private ArticuloRef crearArticuloRef(Long subCategId) {
            ArticuloRef ref = new ArticuloRef();
            ReflectionTestUtils.setField(ref, "id", 100L);
            ReflectionTestUtils.setField(ref, "articuloSubCategId", subCategId);
            return ref;
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // T1/T3: Response incluye campos nuevos (monedaId, pesoNetoTm, etc.)
    // ────────────────────────────────────────────────────────────────────

    @Nested
    @DisplayName("Response: campos nuevos en línea de detalle")
    class ResponseCamposNuevosTests {

        @Test
        @DisplayName("el response de detalle incluye monedaId, pesoNetoTm, precioUnitAnt y flagEstado")
        void crear_responseIncluyeCamposNuevos() {
            setupMocksForCrear();

            MovimientoLineaRequest linea = new MovimientoLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantProcesada(new BigDecimal("10"));
            linea.setCostoUnitario(new BigDecimal("5.00"));
            linea.setMonedaId(1L);
            linea.setPesoNetoTm(new BigDecimal("2.500"));
            requestBase.setLineas(List.of(linea));

            MovimientoDetalleResponse result = service.crear(requestBase);

            assertThat(result).isNotNull();
            assertThat(result.getLineas()).isNotEmpty();
            MovimientoLineaResponse lineaResp = result.getLineas().get(0);
            assertThat(lineaResp.getMonedaId()).isEqualTo(1L);
            assertThat(lineaResp.getPesoNetoTm()).isEqualByComparingTo("2.500");
            assertThat(lineaResp.getPrecioUnitAnt()).isNotNull();
            assertThat(lineaResp.getFlagEstado()).isEqualTo("1");
        }

        @Test
        @DisplayName("pesoNetoTm default a ZERO si no se envía")
        void crear_pesoNetoDefault() {
            setupMocksForCrear();

            MovimientoLineaRequest linea = new MovimientoLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantProcesada(new BigDecimal("10"));
            linea.setCostoUnitario(new BigDecimal("5.00"));
            requestBase.setLineas(List.of(linea));

            MovimientoDetalleResponse result = service.crear(requestBase);

            assertThat(result.getLineas().get(0).getPesoNetoTm()).isEqualByComparingTo("0");
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // Validación básica de tipoReferenciaOrigen
    // ────────────────────────────────────────────────────────────────────

    @Nested
    @DisplayName("Validación: tipoReferenciaOrigen básica")
    class TipoReferenciaBasicaTests {

        @Test
        @DisplayName("rechaza tipoReferenciaOrigen inválido")
        void crear_tipoReferenciaInvalido_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("X");

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo(MovimientoErrorCode.REFERENCIA_OBLIGATORIA);
                    });
        }

        @Test
        @DisplayName("rechaza tipoReferenciaOrigen vacío cuando se solicita")
        void crear_tipoReferenciaVacio_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("");

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo(MovimientoErrorCode.REFERENCIA_OBLIGATORIA);
                    });
        }

        @Test
        @DisplayName("rechaza clase I sin ordenCompraId")
        void crear_claseISinOC_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("I");
            requestBase.setOrdenCompraId(null);

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo(MovimientoErrorCode.REFERENCIA_OBLIGATORIA);
                    });
        }

        @Test
        @DisplayName("rechaza clase T sin ordenTrasladoId")
        void crear_claseTSinOT_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("T");
            requestBase.setOrdenTrasladoId(null);

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo(MovimientoErrorCode.REFERENCIA_OBLIGATORIA);
                    });
        }

        @Test
        @DisplayName("rechaza clase P sin ordenTrabajoId")
        void crear_clasePSinOTrabajo_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("P");
            requestBase.setOrdenTrabajoId(null);

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo(MovimientoErrorCode.REFERENCIA_OBLIGATORIA);
                    });
        }

        @Test
        @DisplayName("rechaza clase V sin ordenVentaId")
        void crear_claseVSinOV_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("V");
            requestBase.setOrdenVentaId(null);

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo(MovimientoErrorCode.REFERENCIA_OBLIGATORIA);
                    });
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // §2.5 bug 1 — API JSON cabecera (vale origen / estado crudo / etiqueta)
    // ────────────────────────────────────────────────────────────────────

    @Nested
    @DisplayName("obtener: cabecera expone valeMovOrigId y estados")
    class ObtenerCabeceraDtoTests {

        @Test
        @DisplayName("obtener incluye valeMovOrigId y flagEstado")
        void obtener_camposCabeceraContrato() {
            ValeMov mov = new ValeMov();
            mov.setId(7L);
            mov.setSucursalId(1L);
            mov.setAlmacenId(10L);
            mov.setArticuloMovTipoId(1L);
            mov.setFechaMov(LocalDate.of(2026, 5, 2));
            mov.setNroVale("VALE-X");
            mov.setFlagEstado(ValeMovFlagEstado.ACTIVO);
            mov.setValeMovOrigId(99L);

            when(valeMovRepository.findById(7L)).thenReturn(Optional.of(mov));

            MovimientoDetalleResponse r = service.obtener(7L);

            assertThat(r.getValeMovOrigId()).isEqualTo(99L);
            assertThat(r.getFlagEstado()).isEqualTo(ValeMovFlagEstado.ACTIVO);
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // §2.5 bug 4 — grp_cntbl desde core.parametro_sistema
    // ────────────────────────────────────────────────────────────────────

    @Nested
    @DisplayName("Resolución grp_cntbl (parámetro vs default)")
    class ResolverGrpCntblTests {

        @Test
        @DisplayName("crear usa grupo contable del parámetro ALMACEN_GRP_CNTBL_DEFAULT cuando existe")
        void crear_matrizUsaGrpDelParametro() {
            reset(jdbcTemplate);
            when(jdbcTemplate.queryForList(anyString(), ArgumentMatchers.<Object>any()))
                    .thenAnswer(invocation -> {
                        String sql = invocation.getArgument(0);
                        if (sql != null && sql.contains("parametro_sistema")) {
                            return List.of(Map.of("valor", "77"));
                        }
                        return List.of();
                    });
            when(jdbcTemplate.update(anyString(), any(), any(), any(), any())).thenReturn(1);

            tipoBase.setFlagContabiliza("1");
            setupMocksForCrear();

            ArticuloRef artRef = new ArticuloRef();
            ReflectionTestUtils.setField(artRef, "id", 100L);
            ReflectionTestUtils.setField(artRef, "articuloSubCategId", 50L);
            when(articuloRefRepository.findById(100L)).thenReturn(Optional.of(artRef));

            ArticuloSubCategRef sub = new ArticuloSubCategRef();
            ReflectionTestUtils.setField(sub, "id", 50L);
            ReflectionTestUtils.setField(sub, "codSubCat", "SC01");
            when(articuloSubCategRefRepository.findById(50L)).thenReturn(Optional.of(sub));

            TipoMovMatrizSubcat mat = new TipoMovMatrizSubcat();
            mat.setMatrizCntblFinanId(900L);
            when(tipoMovMatrizSubcatRepository
                    .findFirstByTipoMovAndGrpCntblAndCodSubCatOrderByItemAsc("I01", "77", "SC01"))
                    .thenReturn(Optional.of(mat));

            MovimientoDetalleResponse result = service.crear(requestBase);

            assertThat(result).isNotNull();
            assertThat(result.getLineas()).isNotEmpty();
            assertThat(result.getLineas().get(0).getMatrizContableId()).isEqualTo(900L);
            verify(tipoMovMatrizSubcatRepository)
                    .findFirstByTipoMovAndGrpCntblAndCodSubCatOrderByItemAsc("I01", "77", "SC01");
        }

        @Test
        @DisplayName("crear usa ALMACEN_GRP_CNTBL_<tipoMov> cuando existe antes que ALMACEN_GRP_CNTBL_DEFAULT")
        void crear_grpCntblPorTipoMovTienePrioridad() {
            reset(jdbcTemplate);
            when(jdbcTemplate.queryForList(anyString(), ArgumentMatchers.<Object>any()))
                    .thenAnswer(invocation -> {
                        String sql = invocation.getArgument(0);
                        Object p1 = invocation.getArgument(1);
                        if (sql != null && sql.contains("parametro_sistema")) {
                            if ("ALMACEN_GRP_CNTBL_I01".equals(String.valueOf(p1))) {
                                return List.of(Map.of("valor", "88"));
                            }
                            if ("ALMACEN_GRP_CNTBL_DEFAULT".equals(String.valueOf(p1))) {
                                return List.of(Map.of("valor", "77"));
                            }
                        }
                        return List.of();
                    });
            when(jdbcTemplate.update(anyString(), any(), any(), any(), any())).thenReturn(1);

            tipoBase.setFlagContabiliza("1");
            setupMocksForCrear();

            ArticuloRef artRef = new ArticuloRef();
            ReflectionTestUtils.setField(artRef, "id", 100L);
            ReflectionTestUtils.setField(artRef, "articuloSubCategId", 50L);
            when(articuloRefRepository.findById(100L)).thenReturn(Optional.of(artRef));

            ArticuloSubCategRef sub = new ArticuloSubCategRef();
            ReflectionTestUtils.setField(sub, "id", 50L);
            ReflectionTestUtils.setField(sub, "codSubCat", "SC01");
            when(articuloSubCategRefRepository.findById(50L)).thenReturn(Optional.of(sub));

            TipoMovMatrizSubcat mat = new TipoMovMatrizSubcat();
            mat.setMatrizCntblFinanId(901L);
            when(tipoMovMatrizSubcatRepository
                    .findFirstByTipoMovAndGrpCntblAndCodSubCatOrderByItemAsc("I01", "88", "SC01"))
                    .thenReturn(Optional.of(mat));

            MovimientoDetalleResponse result = service.crear(requestBase);

            assertThat(result.getLineas().get(0).getMatrizContableId()).isEqualTo(901L);
            verify(tipoMovMatrizSubcatRepository)
                    .findFirstByTipoMovAndGrpCntblAndCodSubCatOrderByItemAsc("I01", "88", "SC01");
            verify(tipoMovMatrizSubcatRepository, never())
                    .findFirstByTipoMovAndGrpCntblAndCodSubCatOrderByItemAsc(eq("I01"), eq("77"), any());
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // Programación de compras (clase C): flag_estado y saldo vs prog_compras_det
    // ────────────────────────────────────────────────────────────────────

    @Nested
    @DisplayName("Validación: programación de compras (clase C)")
    class ProgComprasClaseCTests {

        @Test
        @DisplayName("rechaza programación inactiva")
        void crear_progComprasInactiva_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            tipoBase.setFlagClaseMov("C");
            setupMocksForCrear();

            reset(jdbcTemplate);
            stubJdbcProgComprasClaseC(jdbcTemplate, "0");
            when(jdbcTemplate.update(anyString(), any(), any(), any(), any())).thenReturn(1);

            requestBase.setTipoReferenciaOrigen("C");
            requestBase.setProgComprasId(5L);

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo(MovimientoErrorCode.REFERENCIA_ESTADO_INVALIDO);
                    });
        }

        @Test
        @DisplayName("acepta clase C con programación CONFIRMADA y saldo suficiente")
        void crear_progComprasConfirmada_ok() {
            tipoBase.setFlagSolicitaRef("1");
            tipoBase.setFlagClaseMov("C");
            setupMocksForCrear();

            reset(jdbcTemplate);
            stubJdbcProgComprasClaseC(jdbcTemplate, "1");
            when(jdbcTemplate.update(anyString(), any(), any(), any(), any())).thenReturn(1);

            requestBase.setTipoReferenciaOrigen("C");
            requestBase.setProgComprasId(5L);

            MovimientoDetalleResponse result = service.crear(requestBase);

            assertThat(result).isNotNull();
            verify(valeMovRepository).save(any(ValeMov.class));
        }

        /** Stubs por aridad: un solo {@code any()} no cubre {@code queryForList(sql, a, b)}. */
        private void stubJdbcProgComprasClaseC(JdbcTemplate jdbc, String flagEstadoProg) {
            when(jdbc.queryForList(contains("FROM compras.prog_compras WHERE id"), eq(5L)))
                    .thenReturn(List.of(Map.of("flag_estado", flagEstadoProg)));
            when(jdbc.queryForList(contains("FROM compras.prog_compras_det WHERE"), eq(5L), eq(100L)))
                    .thenReturn(List.of(Map.of("total", new BigDecimal("100"))));
            when(jdbc.queryForList(contains("vale_mov_det vmd"), eq(5L), eq(100L), isNull(), isNull()))
                    .thenReturn(List.of(Map.of("total", BigDecimal.ZERO)));
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // §2.5 bug 5 — bloqueo anulación por vale hijo
    // ────────────────────────────────────────────────────────────────────

    @Nested
    @DisplayName("Anulación: vale hijo referenciando origen")
    class AnulacionValeHijoTests {

        @Test
        @DisplayName("rechaza anulación si existe vale activo hijo con vale_mov_orig_id a este vale")
        void anular_conValeHijo_lanzaError() {
            ValeMov valeActivo = new ValeMov();
            valeActivo.setId(1L);
            valeActivo.setFlagEstado(ValeMovFlagEstado.ACTIVO);
            valeActivo.setFechaMov(LocalDate.of(2026, 5, 2));
            valeActivo.setArticuloMovTipoId(1L);
            valeActivo.setAlmacenId(10L);
            ValeMovDet det = new ValeMovDet();
            det.setId(10L);
            det.setArticuloId(100L);
            det.setCantProcesada(new BigDecimal("5"));
            det.setCostoUnitario(new BigDecimal("10"));
            det.setFlagEstado("1");
            valeActivo.addLinea(det);

            when(valeMovRepository.findById(1L)).thenReturn(Optional.of(valeActivo));
            when(cntblCierreRepository.findByAnoAndMes(anyInt(), anyInt())).thenReturn(Optional.empty());
            when(valeMovRepository.tieneGuiaRemisionActiva(1L)).thenReturn(false);
            when(valeMovRepository.tieneCantidadFacturada(1L)).thenReturn(false);
            when(valeMovRepository.tieneConsignacionActiva(1L)).thenReturn(false);
            when(valeMovRepository.tieneGuiaRecepcionMP(1L)).thenReturn(false);
            when(valeMovRepository.tieneParteProduccionInsumoActivo(1L)).thenReturn(false);
            when(valeMovRepository.existeValeHijoReferenciandoOrigen(1L)).thenReturn(true);

            MovimientoAnularRequest req = new MovimientoAnularRequest();
            req.setId(1L);
            req.setMotivo("Prueba");

            assertThatThrownBy(() -> service.anular(req))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo(MovimientoErrorCode.NO_ANULAR_REFERENCIA_HIJO);
                    });
        }

        @Test
        @DisplayName("rechaza anulación si el vale está en parte_produccion_insumo activo")
        void anular_conParteProduccion_lanzaError() {
            ValeMov valeActivo = new ValeMov();
            valeActivo.setId(1L);
            valeActivo.setFlagEstado(ValeMovFlagEstado.ACTIVO);
            valeActivo.setFechaMov(LocalDate.of(2026, 5, 2));
            valeActivo.setArticuloMovTipoId(1L);
            valeActivo.setAlmacenId(10L);
            ValeMovDet det = new ValeMovDet();
            det.setId(10L);
            det.setArticuloId(100L);
            det.setCantProcesada(new BigDecimal("5"));
            det.setCostoUnitario(new BigDecimal("10"));
            det.setFlagEstado("1");
            valeActivo.addLinea(det);

            when(valeMovRepository.findById(1L)).thenReturn(Optional.of(valeActivo));
            when(cntblCierreRepository.findByAnoAndMes(anyInt(), anyInt())).thenReturn(Optional.empty());
            when(valeMovRepository.tieneGuiaRemisionActiva(1L)).thenReturn(false);
            when(valeMovRepository.tieneCantidadFacturada(1L)).thenReturn(false);
            when(valeMovRepository.tieneConsignacionActiva(1L)).thenReturn(false);
            when(valeMovRepository.tieneGuiaRecepcionMP(1L)).thenReturn(false);
            when(valeMovRepository.tieneParteProduccionInsumoActivo(1L)).thenReturn(true);

            MovimientoAnularRequest req = new MovimientoAnularRequest();
            req.setId(1L);
            req.setMotivo("Prueba");

            assertThatThrownBy(() -> service.anular(req))
                    .isInstanceOf(BusinessException.class)
                    .satisfies(ex -> {
                        BusinessException be = (BusinessException) ex;
                        assertThat(be.getErrorCode()).isEqualTo(MovimientoErrorCode.NO_ANULAR_PARTE_PRODUCCION);
                    });
        }
    }

    @Nested
    @DisplayName("Importar Excel — inferencia de sucursal")
    class ImportarExcelInferenciaTests {

        @Test
        @DisplayName("archivo vacío (0 bytes) → mensaje claro multipart/file")
        void archivoVacio_lanzaBusinessException() {
            MockMultipartFile file = new MockMultipartFile(
                    "file",
                    "vacio.xlsx",
                    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                    new byte[0]);

            assertThatThrownBy(() -> service.importarExcel(file, 1L))
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("multipart")
                    .satisfies(ex -> assertThat(((BusinessException) ex).getErrorCode())
                            .isEqualTo(MovimientoErrorCode.EXCEL_ERROR));
        }

        @Test
        @DisplayName("sin sucursalId y sin filas de datos inferibles → error")
        void sinSucursal_ySinFilasDatos_lanzaBusinessException() throws Exception {
            byte[] bytes;
            try (org.apache.poi.xssf.usermodel.XSSFWorkbook wb = new org.apache.poi.xssf.usermodel.XSSFWorkbook()) {
                wb.createSheet().createRow(0);
                ByteArrayOutputStream bos = new ByteArrayOutputStream();
                wb.write(bos);
                bytes = bos.toByteArray();
            }
            MockMultipartFile file = new MockMultipartFile(
                    "file", "empty.xlsx",
                    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                    bytes);

            assertThatThrownBy(() -> service.importarExcel(file, null))
                    .isInstanceOf(BusinessException.class)
                    .hasMessageContaining("sucursalId");
        }

        @Test
        @DisplayName("sin sucursalId infiere sucursal desde almacén de la fila y llama crear")
        void sinSucursal_inferDesdeAlmacen() throws Exception {
            ValeMovServiceImpl spyService = spy(service);
            MovimientoDetalleResponse detalle = MovimientoDetalleResponse.builder()
                    .id(999L)
                    .lineas(List.of())
                    .build();
            doReturn(detalle).when(spyService).crear(any(MovimientoCabeceraRequest.class));

            Almacen alm = new Almacen();
            alm.setId(10L);
            alm.setSucursalId(42L);
            when(almacenRepository.findById(10L)).thenReturn(Optional.of(alm));

            byte[] bytes;
            try (org.apache.poi.xssf.usermodel.XSSFWorkbook wb = new org.apache.poi.xssf.usermodel.XSSFWorkbook()) {
                org.apache.poi.ss.usermodel.Sheet sh = wb.createSheet();
                sh.createRow(0);
                org.apache.poi.ss.usermodel.Row row = sh.createRow(1);
                row.createCell(0).setCellValue(10);
                row.createCell(1).setCellValue(1);
                row.createCell(2).setCellValue("17/04/2026");
                row.createCell(3).setCellValue(100);
                row.createCell(4).setCellValue(2);
                row.createCell(5).setCellValue(0);
                ByteArrayOutputStream bos = new ByteArrayOutputStream();
                wb.write(bos);
                bytes = bos.toByteArray();
            }

            MockMultipartFile file = new MockMultipartFile(
                    "file", "data.xlsx",
                    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                    bytes);

            ImportResultResponse res = spyService.importarExcel(file, null);
            assertThat(res.getTotalImportadas()).isEqualTo(1);
            assertThat(res.getTotalErrores()).isZero();
            verify(spyService).crear(argThat(r -> r.getSucursalId().equals(42L)));
        }
    }

    @Test
    void listar_delegaEnRepositorio() {
        ValeMov vm = new ValeMov();
        vm.setId(1L);
        vm.setSucursalId(1L);
        vm.setAlmacenId(2L);
        vm.setArticuloMovTipoId(3L);
        vm.setNroVale("V-001");
        vm.setFechaMov(LocalDate.of(2026, 5, 1));
        vm.setFlagEstado("1");
        when(valeMovRepository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(vm)));

        var page = service.listar(1L, 2L, 3L, "1", null, null, null, null, null, Pageable.unpaged());

        assertThat(page.getContent()).hasSize(1);
        assertThat(page.getContent().get(0).getNroVale()).isEqualTo("V-001");
    }

    @Test
    void exportarExcel_sinRegistros_generaXlsx() {
        when(valeMovRepository.findAll(any(Specification.class))).thenReturn(List.of());

        byte[] bytes = service.exportarExcel(null, null, null, null, null, null);

        assertThat(bytes.length).isGreaterThan(8);
        assertThat(bytes[0]).isEqualTo((byte) 0x50);
    }

    @Test
    void confirmar_valeActivo_ok() {
        ValeMov mov = new ValeMov();
        mov.setId(1L);
        mov.setFlagEstado(ValeMovFlagEstado.ACTIVO);
        mov.setArticuloMovTipoId(1L);
        mov.setAlmacenId(10L);
        mov.setSucursalId(1L);
        mov.setFechaMov(LocalDate.now());
        ValeMovDet det = new ValeMovDet();
        det.setId(10L);
        det.setArticuloId(100L);
        det.setCantProcesada(new BigDecimal("5"));
        det.setCostoUnitario(new BigDecimal("10"));
        det.setFlagEstado("1");
        mov.addLinea(det);
        ArticuloRef ref = new ArticuloRef();
        ReflectionTestUtils.setField(ref, "id", 100L);
        ReflectionTestUtils.setField(ref, "articuloSubCategId", 50L);
        when(valeMovRepository.findById(1L)).thenReturn(Optional.of(mov));
        when(articuloMovTipoRepository.findById(1L)).thenReturn(Optional.of(tipoBase));
        when(articuloRefRepository.findById(100L)).thenReturn(Optional.of(ref));
        when(valeMovRepository.save(any(ValeMov.class))).thenAnswer(i -> i.getArgument(0));

        MovimientoConfirmarRequest req = new MovimientoConfirmarRequest();
        req.setId(1L);
        req.setObservacion("OK");

        var out = service.confirmar(req);
        assertThat(out.getId()).isEqualTo(1L);
        assertThat(mov.getObservaciones()).contains("OK");
    }

    @Test
    void confirmar_valeNoActivo_falla() {
        ValeMov mov = new ValeMov();
        mov.setId(2L);
        mov.setFlagEstado(ValeMovFlagEstado.CERRADO);
        when(valeMovRepository.findById(2L)).thenReturn(Optional.of(mov));

        MovimientoConfirmarRequest req = new MovimientoConfirmarRequest();
        req.setId(2L);

        assertThatThrownBy(() -> service.confirmar(req))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.SOLO_CONFIRMABLE_ACTIVO);
    }

    @Test
    void exportarExcel_conRegistro_incluyeFila() {
        ValeMov m = new ValeMov();
        m.setId(10L);
        m.setNroVale("V-010");
        m.setAlmacenId(2L);
        m.setArticuloMovTipoId(3L);
        m.setFechaMov(LocalDate.of(2026, 5, 10));
        m.setFlagEstado("1");
        m.setProveedorId(5L);
        m.setTipoReferenciaOrigen("OC");
        m.setObservaciones("obs");
        when(valeMovRepository.findAll(any(Specification.class))).thenReturn(List.of(m));

        byte[] bytes = service.exportarExcel(1L, 2L, 3L, "1", null, null);

        assertThat(bytes.length).isGreaterThan(100);
    }

    @Nested
    @DisplayName("Traslado entre almacenes — movimiento espejo")
    class MovimientoEspejoTests {

        @Test
        @DisplayName("flag mov entre alm genera vale espejo en almacén destino")
        void crear_generaMovimientoEspejo() {
            ArticuloMovTipo tipoSalida = articuloMovTipoTrasladoSalida(1L, true);
            tipoSalida.setFactorSldoTotal(new BigDecimal("-1"));
            tipoBase = tipoSalida;
            tipoBase.setFlagSolicitaRef("1");

            ArticuloMovTipo tipoIngreso = articuloMovTipoIngreso(2L);
            tipoIngreso.setFlagMovEntreAlm("1");
            tipoIngreso.setFactorSldoTotal(BigDecimal.ONE);
            tipoIngreso.setTipoMov("IT01");

            setupMocksForCrear();
            when(almacenRepository.existsById(20L)).thenReturn(true);
            when(articuloAlmacenRepository.findByAlmacenIdAndArticuloId(eq(20L), eq(100L)))
                    .thenReturn(Optional.of(articuloAlmacen(20L, 100L, new BigDecimal("50"), new BigDecimal("5.00"))));
            when(articuloMovTipoRepository.findFirstByFlagMovEntreAlmAndFactorSldoTotalGreaterThanAndFlagEstado(
                    "1", BigDecimal.ZERO, "1")).thenReturn(Optional.of(tipoIngreso));

            requestBase.setTipoReferenciaOrigen("T");
            requestBase.setOrdenTrasladoId(50L);

            OrdenTraslado ot = new OrdenTraslado();
            ot.setId(50L);
            ot.setAlmacenOrigenId(10L);
            ot.setAlmacenDestinoId(20L);
            ot.setFlagEstado("1");
            ot.setNumero("OT-50");
            when(ordenTrasladoRepository.findByIdForUpdate(50L)).thenReturn(Optional.of(ot));
            when(ordenTrasladoRepository.findById(50L)).thenReturn(Optional.of(ot));

            java.util.concurrent.atomic.AtomicLong ids = new java.util.concurrent.atomic.AtomicLong(1);
            when(valeMovRepository.save(any(ValeMov.class))).thenAnswer(inv -> {
                ValeMov v = inv.getArgument(0);
                v.setId(ids.getAndIncrement());
                return v;
            });
            when(numeradorDocumentoService.siguienteNroDocumento(anyString(), anyLong(), anyInt()))
                    .thenReturn("VALE-A", "VALE-B");

            MovimientoDetalleResponse result = service.crear(requestBase);

            assertThat(result).isNotNull();
            verify(valeMovRepository, times(2)).save(any(ValeMov.class));
        }

        @Test
        @DisplayName("sin orden de traslado rechaza movimiento espejo")
        void crear_movEntreAlmSinOt_lanzaError() {
            ArticuloMovTipo tipoSalida = articuloMovTipoTrasladoSalida(1L, true);
            tipoSalida.setFactorSldoTotal(new BigDecimal("-1"));
            tipoBase = tipoSalida;
            tipoBase.setFlagSolicitaRef("0");
            setupMocksForCrear();

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.ORDEN_TRASLADO_REQUERIDA);
        }
    }

    @Nested
    @DisplayName("Anulación — estados de vale")
    class AnulacionEstadoTests {

        @Test
        void anular_valeCerrado_lanzaError() {
            ValeMov mov = valeMov(1L);
            mov.setFlagEstado(ValeMovFlagEstado.CERRADO);
            when(valeMovRepository.findById(1L)).thenReturn(Optional.of(mov));

            MovimientoAnularRequest req = new MovimientoAnularRequest();
            req.setId(1L);
            req.setMotivo("test");

            assertThatThrownBy(() -> service.anular(req))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.NO_ANULAR_CERRADO);
        }

        @Test
        void anular_valeYaAnulado_lanzaError() {
            ValeMov mov = valeMov(1L);
            mov.setFlagEstado(ValeMovFlagEstado.ANULADO);
            when(valeMovRepository.findById(1L)).thenReturn(Optional.of(mov));

            MovimientoAnularRequest req = new MovimientoAnularRequest();
            req.setId(1L);
            req.setMotivo("test");

            assertThatThrownBy(() -> service.anular(req))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.MOVIMIENTO_YA_ANULADO);
        }

        @Test
        void obtener_valeInexistente_lanzaError() {
            when(valeMovRepository.findById(404L)).thenReturn(Optional.empty());

            assertThatThrownBy(() -> service.obtener(404L))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.MOVIMIENTO_NO_ENCONTRADO);
        }
    }

    @Nested
    @DisplayName("Tipo de movimiento — validaciones adicionales")
    class TipoMovValidacionesTests {

        @Test
        void crear_tipoMovInactivo_lanzaError() {
            ArticuloMovTipo inactivo = articuloMovTipoIngreso(1L);
            inactivo.setFlagEstado("0");
            when(articuloMovTipoRepository.findById(1L)).thenReturn(Optional.of(inactivo));

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.TIPO_MOV_NO_ENCONTRADO);
        }

        @Test
        void crear_almacenInexistente_lanzaError() {
            when(articuloMovTipoRepository.findById(1L)).thenReturn(Optional.of(tipoBase));
            when(almacenRepository.existsById(10L)).thenReturn(false);

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.ALMACEN_NO_ENCONTRADO);
        }

        @Test
        void crear_periodoContableCerrado_lanzaError() {
            when(articuloMovTipoRepository.findById(1L)).thenReturn(Optional.of(tipoBase));
            when(almacenRepository.existsById(10L)).thenReturn(true);
            when(almacenTipoMovRepository.existsByAlmacenIdAndArticuloMovTipoIdAndFlagEstado(10L, 1L, "1"))
                    .thenReturn(true);
            com.sigre.almacen.entity.CntblCierre cierre = new com.sigre.almacen.entity.CntblCierre();
            cierre.setFlagCierreMes("1");
            when(cntblCierreRepository.findByAnoAndMes(anyInt(), anyInt())).thenReturn(Optional.of(cierre));

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.PERIODO_CERRADO);
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // Cobertura: validarOrdenTrabajoExisteYEstado (clase P)
    // ────────────────────────────────────────────────────────────────────

    @Nested
    @DisplayName("Validación: orden de trabajo (clase P)")
    class ValidarOrdenTrabajoTests {

        @Test
        @DisplayName("rechaza orden de trabajo inexistente")
        void crear_ordenTrabajoNoExiste_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            tipoBase.setFlagClaseMov("P");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("P");
            requestBase.setOrdenTrabajoId(777L);

            when(jdbcTemplate.queryForList(contains("produccion.orden_trabajo"), eq(777L)))
                    .thenReturn(List.of());

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.REFERENCIA_NO_ENCONTRADA);
        }

        @Test
        @DisplayName("rechaza orden de trabajo con flag_estado != 1")
        void crear_ordenTrabajoEstadoInvalido_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            tipoBase.setFlagClaseMov("P");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("P");
            requestBase.setOrdenTrabajoId(777L);

            when(jdbcTemplate.queryForList(contains("produccion.orden_trabajo"), eq(777L)))
                    .thenReturn(List.of(Map.of("flag_estado", "0")));

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.REFERENCIA_ESTADO_INVALIDO);
        }

        @Test
        @DisplayName("acepta orden de trabajo con flag_estado = 1")
        void crear_ordenTrabajoActiva_ok() {
            tipoBase.setFlagSolicitaRef("1");
            tipoBase.setFlagClaseMov("P");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("P");
            requestBase.setOrdenTrabajoId(777L);

            when(jdbcTemplate.queryForList(contains("produccion.orden_trabajo"), eq(777L)))
                    .thenReturn(List.of(Map.of("flag_estado", "1")));

            MovimientoDetalleResponse result = service.crear(requestBase);
            assertThat(result).isNotNull();
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // Cobertura: validarOrdenVentaExisteYEstado (clase V)
    // ────────────────────────────────────────────────────────────────────

    @Nested
    @DisplayName("Validación: orden de venta (clase V)")
    class ValidarOrdenVentaTests {

        @Test
        @DisplayName("rechaza orden de venta inexistente")
        void crear_ordenVentaNoExiste_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            tipoBase.setFlagClaseMov("V");
            tipoBase.setFactorSldoTotal(new BigDecimal("-1"));
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("V");
            requestBase.setOrdenVentaId(888L);

            when(jdbcTemplate.queryForList(contains("ventas.orden_venta WHERE"), eq(888L)))
                    .thenReturn(List.of());

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.REFERENCIA_NO_ENCONTRADA);
        }

        @Test
        @DisplayName("rechaza orden de venta con estado inválido")
        void crear_ordenVentaEstadoInvalido_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            tipoBase.setFlagClaseMov("V");
            tipoBase.setFactorSldoTotal(new BigDecimal("-1"));
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("V");
            requestBase.setOrdenVentaId(888L);

            when(jdbcTemplate.queryForList(contains("ventas.orden_venta WHERE"), eq(888L)))
                    .thenReturn(List.of(Map.of("flag_estado", "2")));

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.REFERENCIA_ESTADO_INVALIDO);
        }

        @Test
        @DisplayName("acepta orden de venta activa")
        void crear_ordenVentaActiva_ok() {
            tipoBase.setFlagSolicitaRef("1");
            tipoBase.setFlagClaseMov("V");
            tipoBase.setFactorSldoTotal(new BigDecimal("-1"));
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("V");
            requestBase.setOrdenVentaId(888L);

            when(jdbcTemplate.queryForList(contains("ventas.orden_venta WHERE"), eq(888L)))
                    .thenReturn(List.of(Map.of("flag_estado", "1")));

            MovimientoDetalleResponse result = service.crear(requestBase);
            assertThat(result).isNotNull();
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // Cobertura: validarGuiaRecepcionReferencia (clase G)
    // ────────────────────────────────────────────────────────────────────

    @Nested
    @DisplayName("Validación: guía de recepción (clase G)")
    class ValidarGuiaRecepcionTests {

        @Test
        @DisplayName("rechaza si nroDocExt está vacío en clase G")
        void crear_claseGSinNroDocExt_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            tipoBase.setFlagClaseMov("G");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("G");
            requestBase.setNroDocExt(null);

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.REFERENCIA_OBLIGATORIA);
        }

        @Test
        @DisplayName("rechaza si nroDocExt sólo tiene espacios")
        void crear_claseGNroDocExtBlank_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            tipoBase.setFlagClaseMov("G");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("G");
            requestBase.setNroDocExt("   ");

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.REFERENCIA_OBLIGATORIA);
        }

        @Test
        @DisplayName("acepta nroDocExt como id numérico cuando la guía existe activa")
        void crear_claseGNroDocExtNumerico_ok() {
            tipoBase.setFlagSolicitaRef("1");
            tipoBase.setFlagClaseMov("G");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("G");
            requestBase.setNroDocExt("12345");

            Guia guia = new Guia();
            guia.setId(12345L);
            guia.setFlagEstado("1");
            when(guiaRepository.findByIdAndSucursalIdAndFlagEstado(12345L, 1L, "1"))
                    .thenReturn(Optional.of(guia));

            MovimientoDetalleResponse result = service.crear(requestBase);
            assertThat(result).isNotNull();
        }

        @Test
        @DisplayName("acepta nroDocExt en formato SERIE-NUMERO cuando guía existe activa")
        void crear_claseGSerieNumero_ok() {
            tipoBase.setFlagSolicitaRef("1");
            tipoBase.setFlagClaseMov("G");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("G");
            requestBase.setNroDocExt("T001-000123");

            Guia guia = new Guia();
            guia.setId(1L);
            guia.setSerie("T001");
            guia.setNumero("000123");
            guia.setFlagEstado("1");
            when(guiaRepository.findByIdAndSucursalIdAndFlagEstado(anyLong(), anyLong(), anyString()))
                    .thenReturn(Optional.empty());
            when(guiaRepository.findBySucursalIdAndSerieIgnoreCaseAndNumeroIgnoreCaseAndFlagEstado(
                    1L, "T001", "000123", "1")).thenReturn(Optional.of(guia));

            MovimientoDetalleResponse result = service.crear(requestBase);
            assertThat(result).isNotNull();
        }

        @Test
        @DisplayName("rechaza cuando la guía no existe (referencia inválida)")
        void crear_claseGGuiaNoExiste_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            tipoBase.setFlagClaseMov("G");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("G");
            requestBase.setNroDocExt("T001-NOEXISTE");

            when(guiaRepository.findByIdAndSucursalIdAndFlagEstado(anyLong(), anyLong(), anyString()))
                    .thenReturn(Optional.empty());
            when(guiaRepository.findBySucursalIdAndSerieIgnoreCaseAndNumeroIgnoreCaseAndFlagEstado(
                    anyLong(), anyString(), anyString(), anyString()))
                    .thenReturn(Optional.empty());

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.REFERENCIA_NO_ENCONTRADA);
        }

        @Test
        @DisplayName("rechaza guía referenciada anulada (mock devuelve guía con flag_estado=0)")
        void crear_claseGGuiaAnulada_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            tipoBase.setFlagClaseMov("G");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("G");
            requestBase.setNroDocExt("99");

            // Aunque la query filtra por flag_estado='1', el mock devuelve la guía con
            // flag_estado='0' para ejercitar la rama de validación posterior.
            Guia anulada = new Guia();
            anulada.setId(99L);
            anulada.setFlagEstado("0");
            when(guiaRepository.findByIdAndSucursalIdAndFlagEstado(eq(99L), eq(1L), anyString()))
                    .thenReturn(Optional.of(anulada));

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.REFERENCIA_ESTADO_INVALIDO);
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // Cobertura: validarCamposObligatoriosPorTipo
    // ────────────────────────────────────────────────────────────────────

    @Nested
    @DisplayName("Validación: campos obligatorios por tipo")
    class CamposObligatoriosPorTipoTests {

        @Test
        @DisplayName("rechaza cuando flagSolicitaProv=1 y proveedorId es null")
        void crear_proveedorObligatorio_lanzaError() {
            tipoBase.setFlagSolicitaProv("1");
            setupMocksForCrear();
            requestBase.setProveedorId(null);

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.PROVEEDOR_OBLIGATORIO);
        }

        @Test
        @DisplayName("rechaza cuando flagSolicitaDocExt=1 y nroDocExt es null")
        void crear_docExtNull_lanzaError() {
            tipoBase.setFlagSolicitaDocExt("1");
            setupMocksForCrear();
            requestBase.setTipoDocExtId(null);
            requestBase.setNroDocExt(null);

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.DOC_EXTERNO_OBLIGATORIO);
        }

        @Test
        @DisplayName("rechaza cuando flagSolicitaDocExt=1 y nroDocExt es blank (tipoDocExtId presente)")
        void crear_docExtBlank_lanzaError() {
            tipoBase.setFlagSolicitaDocExt("1");
            setupMocksForCrear();
            requestBase.setTipoDocExtId(5L);
            requestBase.setNroDocExt("   ");

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.DOC_EXTERNO_OBLIGATORIO);
        }

        @Test
        @DisplayName("rechaza cuando flagSolicitaDocInt=1 y nroDocInt es null")
        void crear_docIntNull_lanzaError() {
            tipoBase.setFlagSolicitaDocInt("1");
            setupMocksForCrear();
            requestBase.setTipoDocIntId(null);
            requestBase.setNroDocInt(null);

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.DOC_INTERNO_OBLIGATORIO);
        }

        @Test
        @DisplayName("rechaza cuando flagSolicitaDocInt=1 y nroDocInt es blank")
        void crear_docIntBlank_lanzaError() {
            tipoBase.setFlagSolicitaDocInt("1");
            setupMocksForCrear();
            requestBase.setTipoDocIntId(3L);
            requestBase.setNroDocInt("   ");

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.DOC_INTERNO_OBLIGATORIO);
        }

        @Test
        @DisplayName("acepta cuando docInt y docExt vienen completos")
        void crear_docCompletos_ok() {
            tipoBase.setFlagSolicitaDocInt("1");
            tipoBase.setFlagSolicitaDocExt("1");
            tipoBase.setFlagSolicitaProv("1");
            setupMocksForCrear();
            requestBase.setProveedorId(7L);
            requestBase.setTipoDocIntId(3L);
            requestBase.setNroDocInt("NI-1");
            requestBase.setTipoDocExtId(5L);
            requestBase.setNroDocExt("NE-1");

            MovimientoDetalleResponse result = service.crear(requestBase);
            assertThat(result).isNotNull();
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // Cobertura: validarExistenciaYCoherenciaReferenciasDetalle
    // ────────────────────────────────────────────────────────────────────

    @Nested
    @DisplayName("Validación: existencia y coherencia referencias línea detalle")
    class CoherenciaReferenciasDetalleTests {

        // ── OC det ──

        @Test
        @DisplayName("OC: rechaza ocDetId inexistente")
        void crear_ocDetIdNoExiste_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("I");
            requestBase.setOrdenCompraId(50L);
            when(valeMovRepository.obtenerFlagEstadoOrdenCompra(50L)).thenReturn("1");

            MovimientoLineaRequest linea = new MovimientoLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantProcesada(new BigDecimal("5"));
            linea.setCostoUnitario(new BigDecimal("10"));
            linea.setOcDetId(999L);
            requestBase.setLineas(List.of(linea));

            when(jdbcTemplate.queryForList(contains("orden_compra_det"), eq(999L)))
                    .thenReturn(List.of());

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.REFERENCIA_NO_ENCONTRADA);
        }

        @Test
        @DisplayName("OC: rechaza cuando orden_compra_id de la línea no coincide con cabecera")
        void crear_ocDetIdDistintoOC_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("I");
            requestBase.setOrdenCompraId(50L);
            when(valeMovRepository.obtenerFlagEstadoOrdenCompra(50L)).thenReturn("1");

            MovimientoLineaRequest linea = new MovimientoLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantProcesada(new BigDecimal("5"));
            linea.setCostoUnitario(new BigDecimal("10"));
            linea.setOcDetId(500L);
            requestBase.setLineas(List.of(linea));

            Map<String, Object> row = new HashMap<>();
            row.put("orden_compra_id", 99L);  // distinto a cabecera 50L
            row.put("articulo_id", 100L);
            row.put("cant_proyectada", new BigDecimal("10"));
            row.put("cant_procesada", BigDecimal.ZERO);
            when(jdbcTemplate.queryForList(contains("orden_compra_det"), eq(500L)))
                    .thenReturn(List.of(row));

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.FK_LINEA_NO_CORRESPONDE);
        }

        @Test
        @DisplayName("OC: rechaza cuando artículo de la línea no coincide con orden_compra_det")
        void crear_ocDetArticuloDistinto_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("I");
            requestBase.setOrdenCompraId(50L);
            when(valeMovRepository.obtenerFlagEstadoOrdenCompra(50L)).thenReturn("1");

            MovimientoLineaRequest linea = new MovimientoLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantProcesada(new BigDecimal("5"));
            linea.setCostoUnitario(new BigDecimal("10"));
            linea.setOcDetId(500L);
            requestBase.setLineas(List.of(linea));

            Map<String, Object> row = new HashMap<>();
            row.put("orden_compra_id", 50L);
            row.put("articulo_id", 200L);  // artículo no coincide
            row.put("cant_proyectada", new BigDecimal("10"));
            row.put("cant_procesada", BigDecimal.ZERO);
            when(jdbcTemplate.queryForList(contains("orden_compra_det"), eq(500L)))
                    .thenReturn(List.of(row));

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.FK_LINEA_NO_CORRESPONDE);
        }

        @Test
        @DisplayName("OC: rechaza cantidad procesada > saldo pendiente")
        void crear_ocDetCantidadExcedeSaldo_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("I");
            requestBase.setOrdenCompraId(50L);
            when(valeMovRepository.obtenerFlagEstadoOrdenCompra(50L)).thenReturn("1");

            MovimientoLineaRequest linea = new MovimientoLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantProcesada(new BigDecimal("100"));
            linea.setCostoUnitario(new BigDecimal("10"));
            linea.setOcDetId(500L);
            requestBase.setLineas(List.of(linea));

            Map<String, Object> row = new HashMap<>();
            row.put("orden_compra_id", 50L);
            row.put("articulo_id", 100L);
            row.put("cant_proyectada", new BigDecimal("10"));
            row.put("cant_procesada", new BigDecimal("3"));
            when(jdbcTemplate.queryForList(contains("orden_compra_det"), eq(500L)))
                    .thenReturn(List.of(row));

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.CANTIDAD_INVALIDA);
        }

        // ── OT det ──

        @Test
        @DisplayName("OT: rechaza ordenTrasladoDetId inexistente")
        void crear_otDetNoExiste_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            tipoBase.setFlagClaseMov("T");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("T");
            requestBase.setOrdenTrasladoId(50L);
            OrdenTraslado ot = new OrdenTraslado();
            ot.setId(50L);
            ot.setAlmacenOrigenId(10L);
            ot.setAlmacenDestinoId(20L);
            ot.setFlagEstado("1");
            ot.setNumero("OT-50");
            when(ordenTrasladoRepository.findByIdForUpdate(50L)).thenReturn(Optional.of(ot));
            when(ordenTrasladoRepository.findById(50L)).thenReturn(Optional.of(ot));

            MovimientoLineaRequest linea = new MovimientoLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantProcesada(new BigDecimal("5"));
            linea.setCostoUnitario(new BigDecimal("10"));
            linea.setOrdenTrasladoDetId(700L);
            requestBase.setLineas(List.of(linea));

            when(jdbcTemplate.queryForList(contains("orden_traslado_det"), eq(700L)))
                    .thenReturn(List.of());

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.REFERENCIA_NO_ENCONTRADA);
        }

        @Test
        @DisplayName("OT: rechaza cuando orden_traslado_id de línea no coincide con cabecera")
        void crear_otDetOrdenDistinta_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            tipoBase.setFlagClaseMov("T");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("T");
            requestBase.setOrdenTrasladoId(50L);
            OrdenTraslado ot = new OrdenTraslado();
            ot.setId(50L);
            ot.setAlmacenOrigenId(10L);
            ot.setAlmacenDestinoId(20L);
            ot.setFlagEstado("1");
            ot.setNumero("OT-50");
            when(ordenTrasladoRepository.findByIdForUpdate(50L)).thenReturn(Optional.of(ot));
            when(ordenTrasladoRepository.findById(50L)).thenReturn(Optional.of(ot));

            MovimientoLineaRequest linea = new MovimientoLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantProcesada(new BigDecimal("5"));
            linea.setCostoUnitario(new BigDecimal("10"));
            linea.setOrdenTrasladoDetId(700L);
            requestBase.setLineas(List.of(linea));

            Map<String, Object> row = new HashMap<>();
            row.put("orden_traslado_id", 99L);  // distinto
            row.put("articulo_id", 100L);
            row.put("cantidad", new BigDecimal("100"));
            row.put("cantidad_despachada", BigDecimal.ZERO);
            row.put("cantidad_recibida", BigDecimal.ZERO);
            when(jdbcTemplate.queryForList(contains("orden_traslado_det"), eq(700L)))
                    .thenReturn(List.of(row));

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.FK_LINEA_NO_CORRESPONDE);
        }

        @Test
        @DisplayName("OT origen: rechaza cantidad > saldo por despachar")
        void crear_otOrigenCantidadExcedeSaldoDespacho_lanzaError() {
            ArticuloMovTipo tipoSalida = articuloMovTipoTrasladoSalida(1L, false);
            tipoSalida.setFactorSldoTotal(new BigDecimal("-1"));
            tipoBase = tipoSalida;
            tipoBase.setFlagSolicitaRef("1");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("T");
            requestBase.setOrdenTrasladoId(50L);
            OrdenTraslado ot = new OrdenTraslado();
            ot.setId(50L);
            ot.setAlmacenOrigenId(10L);
            ot.setAlmacenDestinoId(20L);
            ot.setFlagEstado("1");
            ot.setNumero("OT-50");
            when(ordenTrasladoRepository.findByIdForUpdate(50L)).thenReturn(Optional.of(ot));
            when(ordenTrasladoRepository.findById(50L)).thenReturn(Optional.of(ot));

            MovimientoLineaRequest linea = new MovimientoLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantProcesada(new BigDecimal("50"));
            linea.setCostoUnitario(new BigDecimal("10"));
            linea.setOrdenTrasladoDetId(700L);
            requestBase.setLineas(List.of(linea));

            Map<String, Object> row = new HashMap<>();
            row.put("orden_traslado_id", 50L);
            row.put("articulo_id", 100L);
            row.put("cantidad", new BigDecimal("10"));
            row.put("cantidad_despachada", BigDecimal.ZERO);
            row.put("cantidad_recibida", BigDecimal.ZERO);
            when(jdbcTemplate.queryForList(contains("orden_traslado_det"), eq(700L)))
                    .thenReturn(List.of(row));

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.CANTIDAD_INVALIDA);
        }

        @Test
        @DisplayName("OT destino: rechaza cantidad > saldo por recibir")
        void crear_otDestinoCantidadExcedeSaldoRecibir_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            tipoBase.setFlagClaseMov("T");
            setupMocksForCrear();

            requestBase.setAlmacenId(20L);
            requestBase.setTipoReferenciaOrigen("T");
            requestBase.setOrdenTrasladoId(50L);
            when(almacenRepository.existsById(20L)).thenReturn(true);
            when(almacenTipoMovRepository.existsByAlmacenIdAndArticuloMovTipoIdAndFlagEstado(20L, 1L, "1"))
                    .thenReturn(true);
            when(articuloAlmacenRepository.findByAlmacenIdAndArticuloId(20L, 100L))
                    .thenReturn(Optional.of(articuloAlmacen(20L, 100L, new BigDecimal("100"), new BigDecimal("5.00"))));

            OrdenTraslado ot = new OrdenTraslado();
            ot.setId(50L);
            ot.setAlmacenOrigenId(10L);
            ot.setAlmacenDestinoId(20L);
            ot.setFlagEstado("1");
            ot.setNumero("OT-50");
            when(ordenTrasladoRepository.findByIdForUpdate(50L)).thenReturn(Optional.of(ot));
            when(ordenTrasladoRepository.findById(50L)).thenReturn(Optional.of(ot));

            MovimientoLineaRequest linea = new MovimientoLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantProcesada(new BigDecimal("50"));
            linea.setCostoUnitario(new BigDecimal("10"));
            linea.setOrdenTrasladoDetId(700L);
            requestBase.setLineas(List.of(linea));

            Map<String, Object> row = new HashMap<>();
            row.put("orden_traslado_id", 50L);
            row.put("articulo_id", 100L);
            row.put("cantidad", new BigDecimal("10"));
            row.put("cantidad_despachada", BigDecimal.ZERO);
            row.put("cantidad_recibida", BigDecimal.ZERO);
            when(jdbcTemplate.queryForList(contains("orden_traslado_det"), eq(700L)))
                    .thenReturn(List.of(row));

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.CANTIDAD_INVALIDA);
        }

        @Test
        @DisplayName("OT: rechaza cuando articulo de OT_det no coincide con línea")
        void crear_otDetArticuloDistinto_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            tipoBase.setFlagClaseMov("T");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("T");
            requestBase.setOrdenTrasladoId(50L);
            OrdenTraslado ot = new OrdenTraslado();
            ot.setId(50L);
            ot.setAlmacenOrigenId(10L);
            ot.setAlmacenDestinoId(20L);
            ot.setFlagEstado("1");
            ot.setNumero("OT-50");
            when(ordenTrasladoRepository.findByIdForUpdate(50L)).thenReturn(Optional.of(ot));
            when(ordenTrasladoRepository.findById(50L)).thenReturn(Optional.of(ot));

            MovimientoLineaRequest linea = new MovimientoLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantProcesada(new BigDecimal("5"));
            linea.setCostoUnitario(new BigDecimal("10"));
            linea.setOrdenTrasladoDetId(700L);
            requestBase.setLineas(List.of(linea));

            Map<String, Object> row = new HashMap<>();
            row.put("orden_traslado_id", 50L);
            row.put("articulo_id", 999L);  // articulo distinto
            row.put("cantidad", new BigDecimal("100"));
            row.put("cantidad_despachada", BigDecimal.ZERO);
            row.put("cantidad_recibida", BigDecimal.ZERO);
            when(jdbcTemplate.queryForList(contains("orden_traslado_det"), eq(700L)))
                    .thenReturn(List.of(row));

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.FK_LINEA_NO_CORRESPONDE);
        }

        @Test
        @DisplayName("OV: rechaza cuando articulo de OV_det no coincide con línea")
        void crear_ovDetArticuloDistinto_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            tipoBase.setFlagClaseMov("V");
            tipoBase.setFactorSldoTotal(new BigDecimal("-1"));
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("V");
            requestBase.setOrdenVentaId(88L);
            when(jdbcTemplate.queryForList(contains("ventas.orden_venta WHERE"), eq(88L)))
                    .thenReturn(List.of(Map.of("flag_estado", "1")));

            MovimientoLineaRequest linea = new MovimientoLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantProcesada(new BigDecimal("5"));
            linea.setCostoUnitario(new BigDecimal("10"));
            linea.setOrdenVentaDetId(900L);
            requestBase.setLineas(List.of(linea));

            Map<String, Object> row = new HashMap<>();
            row.put("orden_venta_id", 88L);
            row.put("articulo_id", 999L);  // articulo distinto
            row.put("cant_proyectada", new BigDecimal("10"));
            row.put("cant_procesada", BigDecimal.ZERO);
            when(jdbcTemplate.queryForList(contains("ventas.orden_venta_det"), eq(900L)))
                    .thenReturn(List.of(row));

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.FK_LINEA_NO_CORRESPONDE);
        }

        // ── OV det ──

        @Test
        @DisplayName("OV: rechaza ordenVentaDetId inexistente")
        void crear_ovDetNoExiste_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            tipoBase.setFlagClaseMov("V");
            tipoBase.setFactorSldoTotal(new BigDecimal("-1"));
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("V");
            requestBase.setOrdenVentaId(88L);
            when(jdbcTemplate.queryForList(contains("ventas.orden_venta WHERE"), eq(88L)))
                    .thenReturn(List.of(Map.of("flag_estado", "1")));

            MovimientoLineaRequest linea = new MovimientoLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantProcesada(new BigDecimal("5"));
            linea.setCostoUnitario(new BigDecimal("10"));
            linea.setOrdenVentaDetId(900L);
            requestBase.setLineas(List.of(linea));

            when(jdbcTemplate.queryForList(contains("ventas.orden_venta_det"), eq(900L)))
                    .thenReturn(List.of());

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.REFERENCIA_NO_ENCONTRADA);
        }

        @Test
        @DisplayName("OV: rechaza cantidad > saldo pendiente")
        void crear_ovDetCantidadExcedeSaldo_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            tipoBase.setFlagClaseMov("V");
            tipoBase.setFactorSldoTotal(new BigDecimal("-1"));
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("V");
            requestBase.setOrdenVentaId(88L);
            when(jdbcTemplate.queryForList(contains("ventas.orden_venta WHERE"), eq(88L)))
                    .thenReturn(List.of(Map.of("flag_estado", "1")));

            MovimientoLineaRequest linea = new MovimientoLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantProcesada(new BigDecimal("50"));
            linea.setCostoUnitario(new BigDecimal("10"));
            linea.setOrdenVentaDetId(900L);
            requestBase.setLineas(List.of(linea));

            Map<String, Object> row = new HashMap<>();
            row.put("orden_venta_id", 88L);
            row.put("articulo_id", 100L);
            row.put("cant_proyectada", new BigDecimal("10"));
            row.put("cant_procesada", BigDecimal.ZERO);
            when(jdbcTemplate.queryForList(contains("ventas.orden_venta_det"), eq(900L)))
                    .thenReturn(List.of(row));

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.CANTIDAD_INVALIDA);
        }

        @Test
        @DisplayName("OV: rechaza ovDet con ordenVentaId distinto de cabecera")
        void crear_ovDetOrdenDistinta_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            tipoBase.setFlagClaseMov("V");
            tipoBase.setFactorSldoTotal(new BigDecimal("-1"));
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("V");
            requestBase.setOrdenVentaId(88L);
            when(jdbcTemplate.queryForList(contains("ventas.orden_venta WHERE"), eq(88L)))
                    .thenReturn(List.of(Map.of("flag_estado", "1")));

            MovimientoLineaRequest linea = new MovimientoLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantProcesada(new BigDecimal("5"));
            linea.setCostoUnitario(new BigDecimal("10"));
            linea.setOrdenVentaDetId(900L);
            requestBase.setLineas(List.of(linea));

            Map<String, Object> row = new HashMap<>();
            row.put("orden_venta_id", 77L);  // distinto
            row.put("articulo_id", 100L);
            row.put("cant_proyectada", new BigDecimal("10"));
            row.put("cant_procesada", BigDecimal.ZERO);
            when(jdbcTemplate.queryForList(contains("ventas.orden_venta_det"), eq(900L)))
                    .thenReturn(List.of(row));

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.FK_LINEA_NO_CORRESPONDE);
        }

        // ── Operaciones det ──

        @Test
        @DisplayName("OP: rechaza operacionesDetId inexistente")
        void crear_operDetNoExiste_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            tipoBase.setFlagClaseMov("P");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("P");
            requestBase.setOrdenTrabajoId(33L);
            when(jdbcTemplate.queryForList(contains("produccion.orden_trabajo"), eq(33L)))
                    .thenReturn(List.of(Map.of("flag_estado", "1")));

            MovimientoLineaRequest linea = new MovimientoLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantProcesada(new BigDecimal("5"));
            linea.setCostoUnitario(new BigDecimal("10"));
            linea.setOperacionesDetId(450L);
            requestBase.setLineas(List.of(linea));

            when(jdbcTemplate.queryForList(contains("produccion.operaciones_det"), eq(450L)))
                    .thenReturn(List.of());

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.REFERENCIA_NO_ENCONTRADA);
        }

        @Test
        @DisplayName("OP: rechaza cuando orden_trabajo_id de op_det no coincide con cabecera")
        void crear_operDetOrdenDistinta_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            tipoBase.setFlagClaseMov("P");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("P");
            requestBase.setOrdenTrabajoId(33L);
            when(jdbcTemplate.queryForList(contains("produccion.orden_trabajo"), eq(33L)))
                    .thenReturn(List.of(Map.of("flag_estado", "1")));

            MovimientoLineaRequest linea = new MovimientoLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantProcesada(new BigDecimal("5"));
            linea.setCostoUnitario(new BigDecimal("10"));
            linea.setOperacionesDetId(450L);
            requestBase.setLineas(List.of(linea));

            Map<String, Object> row = new HashMap<>();
            row.put("orden_trabajo_id", 99L);  // distinto a cabecera
            row.put("articulo_id", 100L);
            when(jdbcTemplate.queryForList(contains("produccion.operaciones_det"), eq(450L)))
                    .thenReturn(List.of(row));

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.FK_LINEA_NO_CORRESPONDE);
        }

        @Test
        @DisplayName("OP: rechaza cuando articulo_id de op_det no coincide con línea")
        void crear_operDetArticuloDistinto_lanzaError() {
            tipoBase.setFlagSolicitaRef("1");
            tipoBase.setFlagClaseMov("P");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("P");
            requestBase.setOrdenTrabajoId(33L);
            when(jdbcTemplate.queryForList(contains("produccion.orden_trabajo"), eq(33L)))
                    .thenReturn(List.of(Map.of("flag_estado", "1")));

            MovimientoLineaRequest linea = new MovimientoLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantProcesada(new BigDecimal("5"));
            linea.setCostoUnitario(new BigDecimal("10"));
            linea.setOperacionesDetId(450L);
            requestBase.setLineas(List.of(linea));

            Map<String, Object> row = new HashMap<>();
            row.put("orden_trabajo_id", 33L);
            row.put("articulo_id", 200L);  // artículo distinto
            when(jdbcTemplate.queryForList(contains("produccion.operaciones_det"), eq(450L)))
                    .thenReturn(List.of(row));

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.FK_LINEA_NO_CORRESPONDE);
        }

        @Test
        @DisplayName("OP: acepta op_det válido")
        void crear_operDetValido_ok() {
            tipoBase.setFlagSolicitaRef("1");
            tipoBase.setFlagClaseMov("P");
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("P");
            requestBase.setOrdenTrabajoId(33L);
            when(jdbcTemplate.queryForList(contains("produccion.orden_trabajo"), eq(33L)))
                    .thenReturn(List.of(Map.of("flag_estado", "1")));

            MovimientoLineaRequest linea = new MovimientoLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantProcesada(new BigDecimal("5"));
            linea.setCostoUnitario(new BigDecimal("10"));
            linea.setOperacionesDetId(450L);
            requestBase.setLineas(List.of(linea));

            Map<String, Object> row = new HashMap<>();
            row.put("orden_trabajo_id", 33L);
            row.put("articulo_id", 100L);
            when(jdbcTemplate.queryForList(contains("produccion.operaciones_det"), eq(450L)))
                    .thenReturn(List.of(row));

            MovimientoDetalleResponse result = service.crear(requestBase);
            assertThat(result).isNotNull();
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // Cobertura: actualizarPosicion (línea con ubicación)
    // ────────────────────────────────────────────────────────────────────

    @Nested
    @DisplayName("Stock: actualizarPosicion en ubicación")
    class ActualizarPosicionTests {

        @Test
        @DisplayName("crear con ubicación: crea posición nueva (saldoAnterior=0, ingreso)")
        void crear_conUbicacionNueva_creaYActualizaPosicion() {
            setupMocksForCrear();
            when(ubicacionAlmacenRepository.findByIdAndAlmacenId(77L, 10L))
                    .thenReturn(Optional.of(new com.sigre.almacen.entity.UbicacionAlmacen()));
            when(articuloAlmacenPosicionRepository.findByUbicacionAlmacenIdAndArticuloId(77L, 100L))
                    .thenReturn(Optional.empty());
            when(articuloAlmacenPosicionRepository.save(any(ArticuloAlmacenPosicion.class)))
                    .thenAnswer(i -> i.getArgument(0));

            MovimientoLineaRequest linea = new MovimientoLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantProcesada(new BigDecimal("5"));
            linea.setCostoUnitario(new BigDecimal("10"));
            linea.setUbicacionAlmacenId(77L);
            requestBase.setLineas(List.of(linea));

            MovimientoDetalleResponse result = service.crear(requestBase);
            assertThat(result).isNotNull();
            verify(articuloAlmacenPosicionRepository).save(any(ArticuloAlmacenPosicion.class));
        }

        @Test
        @DisplayName("crear con ubicación: existente con saldo previo, actualiza costo promedio ponderado")
        void crear_conUbicacionExistente_actualizaCostoPromedio() {
            setupMocksForCrear();
            when(ubicacionAlmacenRepository.findByIdAndAlmacenId(77L, 10L))
                    .thenReturn(Optional.of(new com.sigre.almacen.entity.UbicacionAlmacen()));
            ArticuloAlmacenPosicion existente = new ArticuloAlmacenPosicion();
            existente.setUbicacionAlmacenId(77L);
            existente.setArticuloId(100L);
            existente.setCantidadDisponible(new BigDecimal("20"));
            existente.setCostoPromedio(new BigDecimal("5.00"));
            when(articuloAlmacenPosicionRepository.findByUbicacionAlmacenIdAndArticuloId(77L, 100L))
                    .thenReturn(Optional.of(existente));
            when(articuloAlmacenPosicionRepository.save(any(ArticuloAlmacenPosicion.class)))
                    .thenAnswer(i -> i.getArgument(0));

            MovimientoLineaRequest linea = new MovimientoLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantProcesada(new BigDecimal("10"));
            linea.setCostoUnitario(new BigDecimal("8"));
            linea.setUbicacionAlmacenId(77L);
            requestBase.setLineas(List.of(linea));

            MovimientoDetalleResponse result = service.crear(requestBase);
            assertThat(result).isNotNull();
            assertThat(existente.getCantidadDisponible()).isEqualByComparingTo("30");
            // (20*5 + 10*8) / 30 = 180/30 = 6.0
            assertThat(existente.getCostoPromedio()).isEqualByComparingTo("6.000000");
        }

        @Test
        @DisplayName("anular con ubicación: rechaza si reversa deja saldo negativo en posición")
        void anular_conUbicacion_stockInsuficienteEnPosicion() {
            // Vale activo con línea de salida ingresada (debió haber dejado saldo en la posición).
            ValeMov mov = new ValeMov();
            mov.setId(1L);
            mov.setFlagEstado(ValeMovFlagEstado.ACTIVO);
            mov.setFechaMov(LocalDate.of(2026, 4, 17));
            mov.setArticuloMovTipoId(1L);
            mov.setAlmacenId(10L);
            mov.setSucursalId(1L);
            ValeMovDet det = new ValeMovDet();
            det.setId(10L);
            det.setArticuloId(100L);
            det.setCantProcesada(new BigDecimal("999")); // muy grande
            det.setCostoUnitario(new BigDecimal("10"));
            det.setUbicacionAlmacenId(77L);
            det.setFlagEstado("1");
            mov.addLinea(det);

            when(valeMovRepository.findById(1L)).thenReturn(Optional.of(mov));
            when(cntblCierreRepository.findByAnoAndMes(anyInt(), anyInt())).thenReturn(Optional.empty());
            when(valeMovRepository.tieneGuiaRemisionActiva(1L)).thenReturn(false);
            when(valeMovRepository.tieneCantidadFacturada(1L)).thenReturn(false);
            when(valeMovRepository.tieneConsignacionActiva(1L)).thenReturn(false);
            when(valeMovRepository.tieneGuiaRecepcionMP(1L)).thenReturn(false);
            when(valeMovRepository.tieneParteProduccionInsumoActivo(1L)).thenReturn(false);
            when(valeMovRepository.existeValeHijoReferenciandoOrigen(1L)).thenReturn(false);
            when(articuloMovTipoRepository.findById(1L)).thenReturn(Optional.of(tipoBase));
            when(articuloAlmacenRepository.findByAlmacenIdAndArticuloId(10L, 100L))
                    .thenReturn(Optional.of(articuloAlmacen(10L, 100L, new BigDecimal("9999"), new BigDecimal("5"))));
            ArticuloAlmacenPosicion pos = new ArticuloAlmacenPosicion();
            pos.setUbicacionAlmacenId(77L);
            pos.setArticuloId(100L);
            pos.setCantidadDisponible(new BigDecimal("1"));  // muy poco
            pos.setCostoPromedio(new BigDecimal("5"));
            when(articuloAlmacenPosicionRepository.findByUbicacionAlmacenIdAndArticuloId(77L, 100L))
                    .thenReturn(Optional.of(pos));

            MovimientoAnularRequest req = new MovimientoAnularRequest();
            req.setId(1L);
            req.setMotivo("test");

            assertThatThrownBy(() -> service.anular(req))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.STOCK_INSUFICIENTE);
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // Cobertura: ejecutarUpdateAcumuladoOrdenTrasladoDet
    // ────────────────────────────────────────────────────────────────────

    @Nested
    @DisplayName("Sync acumulados orden_traslado_det")
    class SyncAcumuladoOrdenTrasladoTests {

        private ArticuloMovTipo tipoSalidaSimple() {
            ArticuloMovTipo t = articuloMovTipoTrasladoSalida(1L, false);
            t.setFactorSldoTotal(new BigDecimal("-1"));
            t.setFlagSolicitaRef("1");
            return t;
        }

        @Test
        @DisplayName("origen: crear actualiza cantidad_despachada (UPDATE +)")
        void crear_otOrigen_updateCantidadDespachada() {
            tipoBase = tipoSalidaSimple();
            setupMocksForCrear();

            requestBase.setTipoReferenciaOrigen("T");
            requestBase.setOrdenTrasladoId(50L);

            OrdenTraslado ot = new OrdenTraslado();
            ot.setId(50L);
            ot.setAlmacenOrigenId(10L);
            ot.setAlmacenDestinoId(20L);
            ot.setFlagEstado("1");
            ot.setNumero("OT-50");
            when(ordenTrasladoRepository.findByIdForUpdate(50L)).thenReturn(Optional.of(ot));
            when(ordenTrasladoRepository.findById(50L)).thenReturn(Optional.of(ot));

            MovimientoLineaRequest linea = new MovimientoLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantProcesada(new BigDecimal("5"));
            linea.setCostoUnitario(new BigDecimal("10"));
            linea.setOrdenTrasladoDetId(700L);
            requestBase.setLineas(List.of(linea));

            Map<String, Object> row = new HashMap<>();
            row.put("orden_traslado_id", 50L);
            row.put("articulo_id", 100L);
            row.put("cantidad", new BigDecimal("100"));
            row.put("cantidad_despachada", BigDecimal.ZERO);
            row.put("cantidad_recibida", BigDecimal.ZERO);
            when(jdbcTemplate.queryForList(contains("orden_traslado_det"), eq(700L)))
                    .thenReturn(List.of(row));
            when(jdbcTemplate.update(contains("cantidad_despachada"),
                    any(), any(), any(), any(), any())).thenReturn(1);

            MovimientoDetalleResponse result = service.crear(requestBase);
            assertThat(result).isNotNull();
            verify(jdbcTemplate, atLeastOnce()).update(contains("cantidad_despachada"),
                    any(), any(), any(), any(), any());
        }

        @Test
        @DisplayName("destino: crear actualiza cantidad_recibida (UPDATE +)")
        void crear_otDestino_updateCantidadRecibida() {
            ArticuloMovTipo tipoIngreso = articuloMovTipoIngreso(1L);
            tipoIngreso.setFlagClaseMov("T");
            tipoIngreso.setFlagSolicitaRef("1");
            tipoBase = tipoIngreso;
            setupMocksForCrear();

            requestBase.setAlmacenId(20L);
            requestBase.setTipoReferenciaOrigen("T");
            requestBase.setOrdenTrasladoId(50L);
            when(almacenRepository.existsById(20L)).thenReturn(true);
            when(almacenTipoMovRepository.existsByAlmacenIdAndArticuloMovTipoIdAndFlagEstado(20L, 1L, "1"))
                    .thenReturn(true);
            when(articuloAlmacenRepository.findByAlmacenIdAndArticuloId(20L, 100L))
                    .thenReturn(Optional.of(articuloAlmacen(20L, 100L, new BigDecimal("100"), new BigDecimal("5"))));

            OrdenTraslado ot = new OrdenTraslado();
            ot.setId(50L);
            ot.setAlmacenOrigenId(10L);
            ot.setAlmacenDestinoId(20L);
            ot.setFlagEstado("1");
            ot.setNumero("OT-50");
            when(ordenTrasladoRepository.findByIdForUpdate(50L)).thenReturn(Optional.of(ot));
            when(ordenTrasladoRepository.findById(50L)).thenReturn(Optional.of(ot));

            MovimientoLineaRequest linea = new MovimientoLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantProcesada(new BigDecimal("5"));
            linea.setCostoUnitario(new BigDecimal("10"));
            linea.setOrdenTrasladoDetId(700L);
            requestBase.setLineas(List.of(linea));

            Map<String, Object> row = new HashMap<>();
            row.put("orden_traslado_id", 50L);
            row.put("articulo_id", 100L);
            row.put("cantidad", new BigDecimal("100"));
            row.put("cantidad_despachada", BigDecimal.ZERO);
            row.put("cantidad_recibida", BigDecimal.ZERO);
            when(jdbcTemplate.queryForList(contains("orden_traslado_det"), eq(700L)))
                    .thenReturn(List.of(row));
            when(jdbcTemplate.update(contains("cantidad_recibida"),
                    any(), any(), any(), any(), any())).thenReturn(1);

            MovimientoDetalleResponse result = service.crear(requestBase);
            assertThat(result).isNotNull();
            verify(jdbcTemplate, atLeastOnce()).update(contains("cantidad_recibida"),
                    any(), any(), any(), any(), any());
        }

        @Test
        @DisplayName("origen: anular ejecuta UPDATE de cantidad_despachada negativo (reversa)")
        void anular_otOrigen_updateCantidadDespachadaNegativo() {
            ArticuloMovTipo tipoSal = tipoSalidaSimple();
            ValeMov mov = new ValeMov();
            mov.setId(1L);
            mov.setFlagEstado(ValeMovFlagEstado.ACTIVO);
            mov.setFechaMov(LocalDate.of(2026, 4, 17));
            mov.setArticuloMovTipoId(1L);
            mov.setAlmacenId(10L);
            mov.setSucursalId(1L);
            mov.setOrdenTrasladoId(50L);
            mov.setTipoReferenciaOrigen("T");
            ValeMovDet det = new ValeMovDet();
            det.setId(10L);
            det.setArticuloId(100L);
            det.setCantProcesada(new BigDecimal("5"));
            det.setCostoUnitario(new BigDecimal("10"));
            det.setOrdenTrasladoDetId(700L);
            det.setFlagEstado("1");
            mov.addLinea(det);

            OrdenTraslado ot = new OrdenTraslado();
            ot.setId(50L);
            ot.setAlmacenOrigenId(10L);
            ot.setAlmacenDestinoId(20L);
            when(ordenTrasladoRepository.findById(50L)).thenReturn(Optional.of(ot));

            when(valeMovRepository.findById(1L)).thenReturn(Optional.of(mov));
            when(cntblCierreRepository.findByAnoAndMes(anyInt(), anyInt())).thenReturn(Optional.empty());
            when(valeMovRepository.tieneGuiaRemisionActiva(1L)).thenReturn(false);
            when(valeMovRepository.tieneCantidadFacturada(1L)).thenReturn(false);
            when(valeMovRepository.tieneConsignacionActiva(1L)).thenReturn(false);
            when(valeMovRepository.tieneGuiaRecepcionMP(1L)).thenReturn(false);
            when(valeMovRepository.tieneParteProduccionInsumoActivo(1L)).thenReturn(false);
            when(valeMovRepository.existeValeHijoReferenciandoOrigen(1L)).thenReturn(false);
            when(articuloMovTipoRepository.findById(1L)).thenReturn(Optional.of(tipoSal));
            when(articuloAlmacenRepository.findByAlmacenIdAndArticuloId(10L, 100L))
                    .thenReturn(Optional.of(articuloAlmacen(10L, 100L, new BigDecimal("100"), new BigDecimal("5"))));
            when(articuloAlmacenRepository.save(any(ArticuloAlmacen.class))).thenAnswer(i -> i.getArgument(0));
            when(articuloSaldoMensualRepository.save(any(ArticuloSaldoMensual.class))).thenAnswer(i -> i.getArgument(0));
            when(valeMovRepository.save(any(ValeMov.class))).thenAnswer(i -> i.getArgument(0));
            // Saldo acumulado suficiente para revertir
            when(jdbcTemplate.queryForList(contains("orden_traslado_det WHERE id"),
                    eq(700L), eq(50L), eq(100L)))
                    .thenReturn(List.of(Map.of("desp", new BigDecimal("5"), "rec", BigDecimal.ZERO)));
            when(jdbcTemplate.update(contains("cantidad_despachada"),
                    any(), any(), any(), any(), any())).thenReturn(1);

            MovimientoAnularRequest req = new MovimientoAnularRequest();
            req.setId(1L);
            req.setMotivo("test");

            MovimientoDetalleResponse out = service.anular(req);
            assertThat(out).isNotNull();
            verify(jdbcTemplate, atLeastOnce()).update(contains("cantidad_despachada"),
                    any(), any(), any(), any(), any());
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // Cobertura: validarSaldoAcumuladoPermiteReversa
    // ────────────────────────────────────────────────────────────────────

    @Nested
    @DisplayName("Reversa: validarSaldoAcumuladoPermiteReversa")
    class ValidarSaldoAcumuladoReversaTests {

        private ValeMov valeAnulable(Long otId, boolean ocRef, boolean ovRef, boolean otRef) {
            ValeMov mov = new ValeMov();
            mov.setId(1L);
            mov.setFlagEstado(ValeMovFlagEstado.ACTIVO);
            mov.setFechaMov(LocalDate.of(2026, 4, 17));
            mov.setArticuloMovTipoId(1L);
            mov.setAlmacenId(10L);
            mov.setSucursalId(1L);
            if (otId != null) {
                mov.setOrdenTrasladoId(otId);
            }
            if (ocRef) {
                mov.setOrdenCompraId(60L);
            }
            if (ovRef) {
                mov.setOrdenVentaId(70L);
            }
            ValeMovDet det = new ValeMovDet();
            det.setId(10L);
            det.setArticuloId(100L);
            det.setCantProcesada(new BigDecimal("5"));
            det.setCostoUnitario(new BigDecimal("10"));
            det.setFlagEstado("1");
            if (ocRef) {
                det.setOcDetId(500L);
            }
            if (ovRef) {
                det.setOrdenVentaDetId(800L);
            }
            if (otRef) {
                det.setOrdenTrasladoDetId(700L);
            }
            mov.addLinea(det);
            return mov;
        }

        private void stubAnulacionComun() {
            when(cntblCierreRepository.findByAnoAndMes(anyInt(), anyInt())).thenReturn(Optional.empty());
            when(valeMovRepository.tieneGuiaRemisionActiva(1L)).thenReturn(false);
            when(valeMovRepository.tieneCantidadFacturada(1L)).thenReturn(false);
            when(valeMovRepository.tieneConsignacionActiva(1L)).thenReturn(false);
            when(valeMovRepository.tieneGuiaRecepcionMP(1L)).thenReturn(false);
            when(valeMovRepository.tieneParteProduccionInsumoActivo(1L)).thenReturn(false);
            when(valeMovRepository.existeValeHijoReferenciandoOrigen(1L)).thenReturn(false);
            when(articuloMovTipoRepository.findById(1L)).thenReturn(Optional.of(tipoBase));
            when(articuloAlmacenRepository.findByAlmacenIdAndArticuloId(anyLong(), anyLong()))
                    .thenReturn(Optional.of(articuloAlmacen(10L, 100L, new BigDecimal("100"), new BigDecimal("5"))));
            when(articuloAlmacenRepository.save(any(ArticuloAlmacen.class))).thenAnswer(i -> i.getArgument(0));
            when(articuloSaldoMensualRepository.save(any(ArticuloSaldoMensual.class))).thenAnswer(i -> i.getArgument(0));
            when(valeMovRepository.save(any(ValeMov.class))).thenAnswer(i -> i.getArgument(0));
        }

        @Test
        @DisplayName("OC: rechaza reversa si fila orden_compra_det no existe")
        void anular_oc_saldoNoEncontrado_lanzaConflict() {
            ValeMov mov = valeAnulable(null, true, false, false);
            when(valeMovRepository.findById(1L)).thenReturn(Optional.of(mov));
            stubAnulacionComun();
            when(jdbcTemplate.queryForList(contains("compras.orden_compra_det"), eq(500L), eq(60L), eq(100L)))
                    .thenReturn(List.of());

            MovimientoAnularRequest req = new MovimientoAnularRequest();
            req.setId(1L);
            req.setMotivo("test");

            assertThatThrownBy(() -> service.anular(req))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.SYNC_ACUMULADO_ORIGEN_FALLIDO);
        }

        @Test
        @DisplayName("OC: rechaza reversa si cant_procesada acumulada es menor que la del vale")
        void anular_oc_saldoMenor_lanzaConflict() {
            ValeMov mov = valeAnulable(null, true, false, false);
            when(valeMovRepository.findById(1L)).thenReturn(Optional.of(mov));
            stubAnulacionComun();
            when(jdbcTemplate.queryForList(contains("compras.orden_compra_det"), eq(500L), eq(60L), eq(100L)))
                    .thenReturn(List.of(Map.of("c", new BigDecimal("2"))));

            MovimientoAnularRequest req = new MovimientoAnularRequest();
            req.setId(1L);
            req.setMotivo("test");

            assertThatThrownBy(() -> service.anular(req))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.SYNC_ACUMULADO_ORIGEN_FALLIDO);
        }

        @Test
        @DisplayName("OV: rechaza reversa si fila orden_venta_det no existe")
        void anular_ov_saldoNoEncontrado_lanzaConflict() {
            ValeMov mov = valeAnulable(null, false, true, false);
            when(valeMovRepository.findById(1L)).thenReturn(Optional.of(mov));
            stubAnulacionComun();
            when(jdbcTemplate.queryForList(contains("ventas.orden_venta_det"), eq(800L), eq(70L), eq(100L)))
                    .thenReturn(List.of());

            MovimientoAnularRequest req = new MovimientoAnularRequest();
            req.setId(1L);
            req.setMotivo("test");

            assertThatThrownBy(() -> service.anular(req))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.SYNC_ACUMULADO_ORIGEN_FALLIDO);
        }

        @Test
        @DisplayName("OV: rechaza reversa si cant_procesada acumulada es menor que la del vale")
        void anular_ov_saldoMenor_lanzaConflict() {
            ValeMov mov = valeAnulable(null, false, true, false);
            when(valeMovRepository.findById(1L)).thenReturn(Optional.of(mov));
            stubAnulacionComun();
            when(jdbcTemplate.queryForList(contains("ventas.orden_venta_det"), eq(800L), eq(70L), eq(100L)))
                    .thenReturn(List.of(Map.of("c", new BigDecimal("1"))));

            MovimientoAnularRequest req = new MovimientoAnularRequest();
            req.setId(1L);
            req.setMotivo("test");

            assertThatThrownBy(() -> service.anular(req))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.SYNC_ACUMULADO_ORIGEN_FALLIDO);
        }

        @Test
        @DisplayName("OT origen: rechaza reversa si cantidad_despachada acumulada es menor")
        void anular_otOrigen_despachadaMenor_lanzaConflict() {
            ValeMov mov = valeAnulable(50L, false, false, true);
            OrdenTraslado ot = new OrdenTraslado();
            ot.setId(50L);
            ot.setAlmacenOrigenId(10L);
            ot.setAlmacenDestinoId(20L);
            when(ordenTrasladoRepository.findById(50L)).thenReturn(Optional.of(ot));
            when(valeMovRepository.findById(1L)).thenReturn(Optional.of(mov));
            stubAnulacionComun();
            when(jdbcTemplate.queryForList(contains("orden_traslado_det"), eq(700L), eq(50L), eq(100L)))
                    .thenReturn(List.of(Map.of("desp", new BigDecimal("2"), "rec", BigDecimal.ZERO)));

            MovimientoAnularRequest req = new MovimientoAnularRequest();
            req.setId(1L);
            req.setMotivo("test");

            assertThatThrownBy(() -> service.anular(req))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.SYNC_ACUMULADO_ORIGEN_FALLIDO);
        }

        @Test
        @DisplayName("OT destino: rechaza reversa si cantidad_recibida acumulada es menor")
        void anular_otDestino_recibidaMenor_lanzaConflict() {
            ValeMov mov = valeAnulable(50L, false, false, true);
            mov.setAlmacenId(20L);  // almacén destino
            OrdenTraslado ot = new OrdenTraslado();
            ot.setId(50L);
            ot.setAlmacenOrigenId(10L);
            ot.setAlmacenDestinoId(20L);
            when(ordenTrasladoRepository.findById(50L)).thenReturn(Optional.of(ot));
            when(valeMovRepository.findById(1L)).thenReturn(Optional.of(mov));
            stubAnulacionComun();
            when(articuloAlmacenRepository.findByAlmacenIdAndArticuloId(20L, 100L))
                    .thenReturn(Optional.of(articuloAlmacen(20L, 100L, new BigDecimal("100"), new BigDecimal("5"))));
            when(jdbcTemplate.queryForList(contains("orden_traslado_det"), eq(700L), eq(50L), eq(100L)))
                    .thenReturn(List.of(Map.of("desp", BigDecimal.ZERO, "rec", new BigDecimal("1"))));

            MovimientoAnularRequest req = new MovimientoAnularRequest();
            req.setId(1L);
            req.setMotivo("test");

            assertThatThrownBy(() -> service.anular(req))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.SYNC_ACUMULADO_ORIGEN_FALLIDO);
        }

        @Test
        @DisplayName("OT: rechaza reversa si fila orden_traslado_det no existe")
        void anular_ot_filaNoExiste_lanzaConflict() {
            ValeMov mov = valeAnulable(50L, false, false, true);
            OrdenTraslado ot = new OrdenTraslado();
            ot.setId(50L);
            ot.setAlmacenOrigenId(10L);
            ot.setAlmacenDestinoId(20L);
            when(ordenTrasladoRepository.findById(50L)).thenReturn(Optional.of(ot));
            when(valeMovRepository.findById(1L)).thenReturn(Optional.of(mov));
            stubAnulacionComun();
            when(jdbcTemplate.queryForList(contains("orden_traslado_det"), eq(700L), eq(50L), eq(100L)))
                    .thenReturn(List.of());

            MovimientoAnularRequest req = new MovimientoAnularRequest();
            req.setId(1L);
            req.setMotivo("test");

            assertThatThrownBy(() -> service.anular(req))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.SYNC_ACUMULADO_ORIGEN_FALLIDO);
        }

        @Test
        @DisplayName("OT: reversa OK cuando saldo es suficiente (origen)")
        void anular_otOrigen_saldoSuficiente_ok() {
            ValeMov mov = valeAnulable(50L, false, false, true);
            OrdenTraslado ot = new OrdenTraslado();
            ot.setId(50L);
            ot.setAlmacenOrigenId(10L);
            ot.setAlmacenDestinoId(20L);
            when(ordenTrasladoRepository.findById(50L)).thenReturn(Optional.of(ot));
            when(valeMovRepository.findById(1L)).thenReturn(Optional.of(mov));
            stubAnulacionComun();
            when(jdbcTemplate.queryForList(contains("orden_traslado_det"), eq(700L), eq(50L), eq(100L)))
                    .thenReturn(List.of(Map.of("desp", new BigDecimal("100"), "rec", BigDecimal.ZERO)));
            when(jdbcTemplate.update(contains("cantidad_despachada"),
                    any(), any(), any(), any(), any())).thenReturn(1);

            MovimientoAnularRequest req = new MovimientoAnularRequest();
            req.setId(1L);
            req.setMotivo("test");

            MovimientoDetalleResponse out = service.anular(req);
            assertThat(out).isNotNull();
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // Cobertura: validarMatrizManual
    // ────────────────────────────────────────────────────────────────────

    @Nested
    @DisplayName("Matriz contable: validación manual cuando se envía explícita")
    class ValidarMatrizManualTests {

        @Test
        @DisplayName("acepta matriz manual coincidente")
        void crear_matrizManualCoincide_ok() {
            tipoBase.setFlagContabiliza("1");
            setupMocksForCrear();

            ArticuloRef artRef = new ArticuloRef();
            ReflectionTestUtils.setField(artRef, "id", 100L);
            ReflectionTestUtils.setField(artRef, "articuloSubCategId", 50L);
            when(articuloRefRepository.findById(100L)).thenReturn(Optional.of(artRef));

            ArticuloSubCategRef sub = new ArticuloSubCategRef();
            ReflectionTestUtils.setField(sub, "id", 50L);
            ReflectionTestUtils.setField(sub, "codSubCat", "SC01");
            when(articuloSubCategRefRepository.findById(50L)).thenReturn(Optional.of(sub));

            TipoMovMatrizSubcat mat = new TipoMovMatrizSubcat();
            mat.setMatrizCntblFinanId(900L);
            when(tipoMovMatrizSubcatRepository
                    .findFirstByTipoMovAndGrpCntblAndCodSubCatOrderByItemAsc(eq("I01"), anyString(), eq("SC01")))
                    .thenReturn(Optional.of(mat));

            MovimientoLineaRequest linea = new MovimientoLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantProcesada(new BigDecimal("5"));
            linea.setCostoUnitario(new BigDecimal("10"));
            linea.setMatrizContableId(900L);
            requestBase.setLineas(List.of(linea));

            MovimientoDetalleResponse result = service.crear(requestBase);
            assertThat(result).isNotNull();
        }

        @Test
        @DisplayName("rechaza matriz manual que no coincide con la subcategoría/tipo")
        void crear_matrizManualNoCoincide_lanzaError() {
            tipoBase.setFlagContabiliza("1");
            setupMocksForCrear();

            ArticuloRef artRef = new ArticuloRef();
            ReflectionTestUtils.setField(artRef, "id", 100L);
            ReflectionTestUtils.setField(artRef, "articuloSubCategId", 50L);
            when(articuloRefRepository.findById(100L)).thenReturn(Optional.of(artRef));

            ArticuloSubCategRef sub = new ArticuloSubCategRef();
            ReflectionTestUtils.setField(sub, "id", 50L);
            ReflectionTestUtils.setField(sub, "codSubCat", "SC01");
            when(articuloSubCategRefRepository.findById(50L)).thenReturn(Optional.of(sub));

            TipoMovMatrizSubcat mat = new TipoMovMatrizSubcat();
            mat.setMatrizCntblFinanId(900L);
            when(tipoMovMatrizSubcatRepository
                    .findFirstByTipoMovAndGrpCntblAndCodSubCatOrderByItemAsc(eq("I01"), anyString(), eq("SC01")))
                    .thenReturn(Optional.of(mat));

            MovimientoLineaRequest linea = new MovimientoLineaRequest();
            linea.setArticuloId(100L);
            linea.setCantProcesada(new BigDecimal("5"));
            linea.setCostoUnitario(new BigDecimal("10"));
            linea.setMatrizContableId(901L);  // diferente al found 900
            requestBase.setLineas(List.of(linea));

            assertThatThrownBy(() -> service.crear(requestBase))
                    .isInstanceOf(BusinessException.class)
                    .hasFieldOrPropertyWithValue("errorCode", MovimientoErrorCode.MATRIZ_INVALIDA);
        }
    }

    // ────────────────────────────────────────────────────────────────────
    // Cobertura: resolverNombreUsuarioGeneradorPdf
    // ────────────────────────────────────────────────────────────────────

    @Nested
    @DisplayName("PDF: resolverNombreUsuarioGeneradorPdf")
    class ResolverNombreUsuarioGeneradorPdfTests {

        @org.junit.jupiter.api.AfterEach
        void clearTenant() {
            com.sigre.common.security.TenantContext.clear();
        }

        @Test
        @DisplayName("retorna vacío cuando TenantContext.usuarioId es null")
        void generarPdf_sinUsuario_nombreVacio() {
            com.sigre.common.security.TenantContext.clear();
            // Es difícil ejecutar generarPdf completo (compila JasperReport).
            // Verificamos vía ReflectionTestUtils invocando el método privado.
            String nombre = (String) ReflectionTestUtils.invokeMethod(service, "resolverNombreUsuarioGeneradorPdf");
            assertThat(nombre).isEmpty();
        }

        @Test
        @DisplayName("retorna nombre cuando el usuario existe en auth.usuario")
        void resolverNombre_usuarioExiste_devuelveNombre() {
            com.sigre.common.security.TenantContext.setUsuarioId(42L);
            try {
                when(jdbcTemplate.queryForList(contains("auth.usuario"), eq(42L)))
                        .thenReturn(List.of(Map.of("nombre_completo", "Juan Perez")));
                String nombre = (String) ReflectionTestUtils.invokeMethod(service, "resolverNombreUsuarioGeneradorPdf");
                assertThat(nombre).isEqualTo("Juan Perez");
            } finally {
                com.sigre.common.security.TenantContext.clear();
            }
        }

        @Test
        @DisplayName("retorna vacío cuando query no encuentra al usuario")
        void resolverNombre_usuarioNoExiste_devuelveVacio() {
            com.sigre.common.security.TenantContext.setUsuarioId(42L);
            try {
                when(jdbcTemplate.queryForList(contains("auth.usuario"), eq(42L)))
                        .thenReturn(List.of());
                String nombre = (String) ReflectionTestUtils.invokeMethod(service, "resolverNombreUsuarioGeneradorPdf");
                assertThat(nombre).isEmpty();
            } finally {
                com.sigre.common.security.TenantContext.clear();
            }
        }

        @Test
        @DisplayName("retorna vacío cuando jdbc lanza excepción (manejo de error)")
        void resolverNombre_jdbcLanzaExcepcion_devuelveVacio() {
            com.sigre.common.security.TenantContext.setUsuarioId(42L);
            try {
                when(jdbcTemplate.queryForList(contains("auth.usuario"), eq(42L)))
                        .thenThrow(new RuntimeException("DB down"));
                String nombre = (String) ReflectionTestUtils.invokeMethod(service, "resolverNombreUsuarioGeneradorPdf");
                assertThat(nombre).isEmpty();
            } finally {
                com.sigre.common.security.TenantContext.clear();
            }
        }

        @Test
        @DisplayName("retorna vacío si la fila no contiene nombre_completo (null)")
        void resolverNombre_nombreNull_devuelveVacio() {
            com.sigre.common.security.TenantContext.setUsuarioId(42L);
            try {
                Map<String, Object> row = new HashMap<>();
                row.put("nombre_completo", null);
                when(jdbcTemplate.queryForList(contains("auth.usuario"), eq(42L)))
                        .thenReturn(List.of(row));
                String nombre = (String) ReflectionTestUtils.invokeMethod(service, "resolverNombreUsuarioGeneradorPdf");
                assertThat(nombre).isEmpty();
            } finally {
                com.sigre.common.security.TenantContext.clear();
            }
        }
    }
}
