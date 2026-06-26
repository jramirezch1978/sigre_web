package pe.restaurant.compras.service.impl;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.compras.dto.*;
import pe.restaurant.compras.entity.*;
import pe.restaurant.compras.repository.*;
import pe.restaurant.compras.service.OrdenServicioCalculator;
import pe.restaurant.compras.service.OrdenServicioValidator;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.common.service.ConfigParameterService;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static pe.restaurant.compras.ComprasTestFixtures.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("OrdenServicioServiceImpl — Pruebas Unitarias")
class OrdenServicioServiceImplTest {

    @Mock private OrdenServicioRepository ordenServicioRepository;
    @Mock private NumOrdSrvRepository numOrdSrvRepository;
    @Mock private AprobacionRepository aprobacionRepository;
    @Mock private OsAjusteValorRepository osAjusteValorRepository;
    @Mock private OsConformidadLogRepository osConformidadLogRepository;
    @Mock private AsignacionOsOcRepository asignacionOsOcRepository;
    @Mock private OrdenCompraRepository ordenCompraRepository;
    @Mock private EntidadBancoCntaRepository entidadBancoCntaRepository;
    @Mock private ConfigParameterService configParameterService;
    @Mock private EntidadContribuyenteRefRepository entidadContribuyenteRefRepository;
    @Mock private CompradorRepository compradorRepository;
    @Mock private ServicioCatalogoRepository servicioCatalogoRepository;
    @Mock private MonedaRefRepository monedaRefRepository;
    @Mock private UsuarioRefRepository usuarioRefRepository;
    @Mock private OrdenServicioCalculator calculator;
    @Mock private OrdenServicioValidator validator;
    @Mock private CntasPagarRefRepository cntasPagarRefRepository;
    @Mock private org.springframework.jdbc.core.JdbcTemplate jdbcTemplate;

    @InjectMocks private OrdenServicioServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
        lenient().when(configParameterService.getDec(anyString(), isNull())).thenReturn(null);
        lenient().when(entidadContribuyenteRefRepository.findById(anyLong())).thenReturn(Optional.empty());
        lenient().when(monedaRefRepository.findById(anyLong())).thenReturn(Optional.empty());
        lenient().when(compradorRepository.findById(anyLong())).thenReturn(Optional.empty());
        lenient().when(usuarioRefRepository.findById(anyLong())).thenReturn(Optional.empty());
        lenient().when(servicioCatalogoRepository.findById(anyLong())).thenReturn(Optional.empty());
        lenient().when(jdbcTemplate.queryForObject(
                eq("SELECT id FROM core.doc_tipo WHERE codigo = ? AND flag_estado = '1'"),
                eq(Long.class), eq("OS")))
                .thenReturn(2L);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    // ── listar ──

    @Test
    @DisplayName("listar() retorna página de resúmenes")
    @SuppressWarnings("unchecked")
    void listar_retornaPaginaDeResumenes() {
        OrdenServicio os = ordenServicio(1L);
        Page<OrdenServicio> page = new PageImpl<>(List.of(os));

        when(ordenServicioRepository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(page);

        Page<OrdenServicioResumenResponse> result = service.listar(
                null, null, null, null, null, null, null,
                null, null, null, null, null, Pageable.unpaged());

        assertThat(result.getContent()).hasSize(1);
        assertThat(result.getContent().get(0).getId()).isEqualTo(1L);
    }

    // ── pendientesAprobacion ──

    @Test
    @DisplayName("pendientesAprobacion() retorna página")
    @SuppressWarnings("unchecked")
    void pendientesAprobacion_retornaPagina() {
        OrdenServicio os = ordenServicio(1L, "3");
        when(ordenServicioRepository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(os)));

        Page<OrdenServicioResumenResponse> result = service.pendientesAprobacion(Pageable.unpaged());

        assertThat(result.getContent()).hasSize(1);
    }

    // ── obtener ──

    @Test
    @DisplayName("obtener() existente -> retorna detalle")
    void obtener_existente_retornaDetalle() {
        OrdenServicio os = ordenServicio(1L);
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));

        OrdenServicioDetalleResponse result = service.obtener(1L);

        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getNroOs()).isEqualTo("OS-00000001");
    }

    @Test
    @DisplayName("obtener() no existente -> lanza excepción")
    void obtener_noExistente_lanzaExcepcion() {
        when(ordenServicioRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtener(99L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    // ── crear ──

    @Test
    @DisplayName("crear() ok -> genera nro y guarda")
    void crear_ok_generaNroYGuarda() {
        when(validator.verificarCompradorActivo()).thenReturn(10L);

        NumOrdSrv num = numOrdSrv(0L);
        when(numOrdSrvRepository.findForUpdate(eq(1L), eq("OS")))
                .thenReturn(Optional.of(num));

        when(entidadBancoCntaRepository.findFirstByEntidadContribuyenteIdAndMonedaIdAndFlagEstadoOrderByIdDesc(any(), any(), any()))
                .thenReturn(Optional.empty());

        OrdenServicio savedOs = ordenServicio(1L);
        savedOs.setNroOs("OS-00000001");
        when(ordenServicioRepository.save(any(OrdenServicio.class))).thenReturn(savedOs);

        OrdenServicioCabeceraRequest req = ordenServicioRequest();
        OrdenServicioDetalleResponse result = service.crear(req);

        assertThat(result).isNotNull();
        verify(validator).verificarCompradorActivo();
        verify(validator).validarCabecera(req);
        verify(validator).validarDetalle(req.getLineas());
        verify(calculator).calcularTotales(any(OrdenServicio.class));
        verify(numOrdSrvRepository).save(any(NumOrdSrv.class));
        verify(ordenServicioRepository).save(any(OrdenServicio.class));
    }

    @Test
    @DisplayName("crear() con aprobación estado generada")
    void crear_conAprobacion_estadoGenerada() {
        when(validator.verificarCompradorActivo()).thenReturn(10L);

        NumOrdSrv num = numOrdSrv(0L);
        when(numOrdSrvRepository.findForUpdate(any(), any())).thenReturn(Optional.of(num));
        when(entidadBancoCntaRepository.findFirstByEntidadContribuyenteIdAndMonedaIdAndFlagEstadoOrderByIdDesc(any(), any(), any()))
                .thenReturn(Optional.empty());

        when(ordenServicioRepository.save(any(OrdenServicio.class))).thenAnswer(inv -> {
            OrdenServicio captured = inv.getArgument(0);
            captured.setId(5L);
            captured.setNroOs("OS-00000001");
            return captured;
        });

        OrdenServicioDetalleResponse result = service.crear(ordenServicioRequest());

        assertThat(result).isNotNull();
        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("crear() sin aprobación estado aprobada")
    void crear_sinAprobacion_estadoAprobada() {
        when(validator.verificarCompradorActivo()).thenReturn(10L);

        NumOrdSrv num = numOrdSrv(0L);
        when(numOrdSrvRepository.findForUpdate(any(), any())).thenReturn(Optional.of(num));
        when(entidadBancoCntaRepository.findFirstByEntidadContribuyenteIdAndMonedaIdAndFlagEstadoOrderByIdDesc(any(), any(), any()))
                .thenReturn(Optional.empty());

        when(ordenServicioRepository.save(any(OrdenServicio.class))).thenAnswer(inv -> {
            OrdenServicio captured = inv.getArgument(0);
            captured.setId(6L);
            captured.setNroOs("OS-00000002");
            return captured;
        });

        OrdenServicioDetalleResponse result = service.crear(ordenServicioRequest());

        assertThat(result).isNotNull();
        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    // ── actualizar ──

    @Test
    @DisplayName("actualizar() generada -> ok")
    void actualizar_generada_ok() {
        OrdenServicio existing = ordenServicio(1L, "1");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(existing));
        when(entidadBancoCntaRepository.findFirstByEntidadContribuyenteIdAndMonedaIdAndFlagEstadoOrderByIdDesc(any(), any(), any()))
                .thenReturn(Optional.empty());
        when(ordenServicioRepository.save(any(OrdenServicio.class))).thenReturn(existing);

        OrdenServicioCabeceraRequest req = ordenServicioRequest();
        OrdenServicioDetalleResponse result = service.actualizar(1L, req);

        assertThat(result).isNotNull();
        verify(validator).validarCabecera(req);
        verify(validator).validarDetalle(req.getLineas());
        verify(calculator).calcularTotales(any(OrdenServicio.class));
    }

    @Test
    @DisplayName("actualizar() pendiente aprobación -> lanza COM-125")
    void actualizar_pendienteAprobacion_lanzaCOM125() {
        OrdenServicio existing = ordenServicio(1L, "3");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(existing));

        assertThatThrownBy(() -> service.actualizar(1L, ordenServicioRequest()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("activo o rechazada");
    }

    @Test
    @DisplayName("actualizar() aprobada -> lanza COM-125")
    void actualizar_aprobada_lanzaCOM125() {
        OrdenServicio existing = ordenServicio(1L, "2");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(existing));

        assertThatThrownBy(() -> service.actualizar(1L, ordenServicioRequest()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("activo o rechazada");
    }

    // ── enviarAprobacion ──

    @Test
    @DisplayName("enviarAprobacion() generada -> ok")
    void enviarAprobacion_generada_ok() {
        OrdenServicio os = ordenServicio(1L, "1");
        os.setFlagEstado("1");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));
        when(ordenServicioRepository.save(any(OrdenServicio.class))).thenReturn(os);

        OrdenServicioDetalleResponse result = service.enviarAprobacion(1L);

        assertThat(result).isNotNull();
        verify(validator).verificarPrecios(os);
        verify(aprobacionRepository).save(any(Aprobacion.class));
    }

    @Test
    @DisplayName("enviarAprobacion() estado incorrecto -> lanza COM-120")
    void enviarAprobacion_estadoIncorrecto_lanzaCOM120() {
        OrdenServicio os = ordenServicio(1L, "2");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));

        assertThatThrownBy(() -> service.enviarAprobacion(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("activa o rechazada");
    }

    // ── aprobar ──

    @Test
    @DisplayName("aprobar() pendiente -> ok")
    void aprobar_pendiente_ok() {
        OrdenServicio os = ordenServicio(1L, "3");
        os.setMontoTotal(new BigDecimal("1000"));
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));
        when(ordenServicioRepository.save(any(OrdenServicio.class))).thenReturn(os);

        OrdenServicioDetalleResponse result = service.aprobar(1L, "OK");

        assertThat(result).isNotNull();
        verify(validator).validarAprobadorConfigurado(eq(1L), any(BigDecimal.class));
        verify(aprobacionRepository).save(any(Aprobacion.class));
    }

    @Test
    @DisplayName("aprobar() no es pendiente -> lanza COM-121")
    void aprobar_noEsPendiente_lanzaCOM121() {
        OrdenServicio os = ordenServicio(1L, "1");
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));

        assertThatThrownBy(() -> service.aprobar(1L, "OK"))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("pendiente de aprobación");
    }

    // ── rechazar ──

    @Test
    @DisplayName("rechazar() pendiente -> ok")
    void rechazar_pendiente_ok() {
        OrdenServicio os = ordenServicio(1L, "3");
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));
        when(ordenServicioRepository.save(any(OrdenServicio.class))).thenReturn(os);

        OrdenServicioDetalleResponse result = service.rechazar(1L, "No cumple");

        assertThat(result).isNotNull();
        assertThat(os.getFlagEstado()).isEqualTo("0");
        verify(aprobacionRepository).save(any(Aprobacion.class));
    }

    // ── devolver ──

    @Test
    @DisplayName("devolver() pendiente -> ok")
    void devolver_pendiente_ok() {
        OrdenServicio os = ordenServicio(1L, "3");
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));
        when(ordenServicioRepository.save(any(OrdenServicio.class))).thenReturn(os);

        OrdenServicioDetalleResponse result = service.devolver(1L, "Revisar importes");

        assertThat(result).isNotNull();
        assertThat(os.getFlagEstado()).isEqualTo("1");
    }

    // ── anular ──

    @Test
    @DisplayName("anular() sin conformidad -> ok")
    void anular_sinConformidad_ok() {
        OrdenServicio os = ordenServicioConDetalle(1L, "1");
        os.setFlagEstado("1");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));
        when(ordenServicioRepository.save(any(OrdenServicio.class))).thenReturn(os);

        OrdenServicioDetalleResponse result = service.anular(1L, "Por error");

        assertThat(result).isNotNull();
        assertThat(os.getFlagEstado()).isEqualTo("0");
        assertThat(os.getFlagEstado()).isEqualTo("0");
        verify(validator).verificarSinProvisionesAprovisionamiento(1L);
        verify(validator).verificarSinGastosFlota(1L);
    }

    @Test
    @DisplayName("anular() con conformidad -> lanza COM-141")
    void anular_conConformidad_lanzaCOM141() {
        OrdenServicio os = ordenServicioConDetalle(1L);
        os.setFlagEstado("1");
        os.getLineas().get(0).setConformidadFecha(OffsetDateTime.now());
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));

        assertThatThrownBy(() -> service.anular(1L, "Motivo"))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("conformidad");
    }

    @Test
    @DisplayName("anular() con provisiónes -> lanza COM-142")
    void anular_conProvisiones_lanzaCOM142() {
        OrdenServicio os = ordenServicioConDetalle(1L);
        os.setFlagEstado("1");
        os.getLineas().get(0).setImpProvisionado(new BigDecimal("500"));
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));

        assertThatThrownBy(() -> service.anular(1L, "Motivo"))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("provisionados");
    }

    @Test
    @DisplayName("anular() ya anulada -> lanza COM-140")
    void anular_yaAnulada_lanzaCOM140() {
        OrdenServicio os = ordenServicio(1L);
        os.setFlagEstado("0");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));

        assertThatThrownBy(() -> service.anular(1L, "Motivo"))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("anulada");
    }

    // ── cerrar ──

    @Test
    @DisplayName("cerrar() aprobada -> ok")
    void cerrar_aprobada_ok() {
        OrdenServicio os = ordenServicioConDetalle(1L, "1");
        os.setFlagEstado("1");
        os.setFlagSolicitaActa("0");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));
        when(ordenServicioRepository.save(any(OrdenServicio.class))).thenReturn(os);

        OrdenServicioDetalleResponse result = service.cerrar(1L);

        assertThat(result).isNotNull();
        assertThat(os.getFlagEstado()).isEqualTo("2");
        assertThat(os.getFlagEstado()).isEqualTo("2");
    }

    @Test
    @DisplayName("cerrar() anulada -> lanza COM-150")
    void cerrar_anulada_lanzaCOM150() {
        OrdenServicio os = ordenServicio(1L);
        os.setFlagEstado("0");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));

        assertThatThrownBy(() -> service.cerrar(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("anulada");
    }

    @Test
    @DisplayName("cerrar() no aprobada -> lanza COM-151")
    void cerrar_noAprobada_lanzaCOM151() {
        OrdenServicio os = ordenServicio(1L, "3");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));

        assertThatThrownBy(() -> service.cerrar(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("activa");
    }

    @Test
    @DisplayName("cerrar() con acta sin conformidad -> lanza COM-152")
    void cerrar_conActaSinConformidad_lanzaCOM152() {
        OrdenServicio os = ordenServicioConDetalle(1L, "1");
        os.setFlagEstado("1");
        os.setFlagSolicitaActa("1");
        os.getLineas().get(0).setConformidadFecha(null);
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));

        assertThatThrownBy(() -> service.cerrar(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("conformidad");
    }

    // ── registrarConformidad ──

    @Test
    @DisplayName("registrarConformidad() ok")
    void registrarConformidad_ok() {
        OrdenServicio os = ordenServicioConDetalle(1L, "1");
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));
        when(ordenServicioRepository.save(any(OrdenServicio.class))).thenReturn(os);

        ConformidadOsRequest req = new ConformidadOsRequest();
        req.setObservacion("Todo bien");
        OrdenServicioDetalleResponse result = service.registrarConformidad(1L, 100L, req);

        assertThat(result).isNotNull();
        assertThat(os.getLineas().get(0).getConformidadFecha()).isNotNull();
        verify(osConformidadLogRepository).save(any(OsConformidadLog.class));
    }

    @Test
    @DisplayName("registrarConformidad() no aprobada -> lanza COM-160")
    void registrarConformidad_noAprobada_lanzaCOM160() {
        OrdenServicio os = ordenServicioConDetalle(1L, "0");
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));

        assertThatThrownBy(() -> service.registrarConformidad(1L, 100L, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("activa");
    }

    @Test
    @DisplayName("registrarConformidad() ya conformada -> lanza COM-163")
    void registrarConformidad_yaConformada_lanzaCOM163() {
        OrdenServicio os = ordenServicioConDetalle(1L, "1");
        os.getLineas().get(0).setConformidadFecha(OffsetDateTime.now());
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));

        assertThatThrownBy(() -> service.registrarConformidad(1L, 100L, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("ya tiene conformidad");
    }

    // ── revertirConformidad ──

    @Test
    @DisplayName("revertirConformidad() ok")
    void revertirConformidad_ok() {
        OrdenServicio os = ordenServicioConDetalle(1L, "1");
        os.getLineas().get(0).setConformidadFecha(OffsetDateTime.now());
        os.getLineas().get(0).setConformidadUsr(1L);
        os.getLineas().get(0).setImpProvisionado(BigDecimal.ZERO);
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));
        when(ordenServicioRepository.save(any(OrdenServicio.class))).thenReturn(os);

        ConformidadOsRequest req = new ConformidadOsRequest();
        req.setObservacion("Revertir");
        OrdenServicioDetalleResponse result = service.revertirConformidad(1L, 100L, req);

        assertThat(result).isNotNull();
        assertThat(os.getLineas().get(0).getConformidadFecha()).isNull();
        verify(validator).insertarLogDiario(eq(1L), eq(100L), eq("DESAPROBAR_CONFORMIDAD"), eq(1L), eq("Revertir"));
        verify(osConformidadLogRepository).save(any(OsConformidadLog.class));
    }

    @Test
    @DisplayName("revertirConformidad() con provisión -> lanza COM-165")
    void revertirConformidad_conProvision_lanzaCOM165() {
        OrdenServicio os = ordenServicioConDetalle(1L, "1");
        os.getLineas().get(0).setConformidadFecha(OffsetDateTime.now());
        os.getLineas().get(0).setImpProvisionado(new BigDecimal("500"));
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));

        assertThatThrownBy(() -> service.revertirConformidad(1L, 100L, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("provisionados");
    }

    // ── ajustarValor ──

    @Test
    @DisplayName("ajustarValor() ok")
    void ajustarValor_ok() {
        OrdenServicio os = ordenServicioConDetalle(1L, "1");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));
        when(ordenServicioRepository.save(any(OrdenServicio.class))).thenReturn(os);

        AjusteValorOsRequest req = new AjusteValorOsRequest();
        req.setLineaId(100L);
        req.setNuevoImporte(new BigDecimal("1500"));
        req.setMotivo("Ajuste contractual");

        OrdenServicioDetalleResponse result = service.ajustarValor(1L, req);

        assertThat(result).isNotNull();
        verify(osAjusteValorRepository).save(any(OsAjusteValor.class));
        verify(calculator).calcularTotales(any(OrdenServicio.class));
    }

    @Test
    @DisplayName("ajustarValor() no aprobada -> lanza COM-170")
    void ajustarValor_noAprobada_lanzaCOM170() {
        OrdenServicio os = ordenServicioConDetalle(1L, "0");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));

        AjusteValorOsRequest req = new AjusteValorOsRequest();
        req.setLineaId(100L);
        req.setNuevoImporte(new BigDecimal("1500"));

        assertThatThrownBy(() -> service.ajustarValor(1L, req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("activa");
    }

    // ── historial ──

    @Test
    @DisplayName("historial() retorna lista de aprobaciónes")
    void historial_retornaListaDeAprobaciones() {
        OrdenServicio os = ordenServicio(1L);
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));

        Aprobacion a = aprobacion(1L, "APROBADA");

        when(jdbcTemplate.queryForObject(
                eq("SELECT id FROM core.doc_tipo WHERE codigo = ? AND flag_estado = '1'"),
                eq(Long.class), eq("OS")))
                .thenReturn(2L);
        when(aprobacionRepository.findByDocTipoIdAndDocumentoIdOrderByFechaAsc(2L, 1L))
                .thenReturn(List.of(a));

        List<HistorialAprobacionResponse> result = service.historial(1L);

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getAccion()).isEqualTo("APROBADA");
    }

    // ── saldoPendiente ──

    @Test
    @DisplayName("saldoPendiente() con líneas -> calcula correctamente")
    void saldoPendiente_conLineas_calculaCorrectamente() {
        OrdenServicio os = ordenServicioConDetalle(1L);
        os.setMontoTotal(new BigDecimal("1000"));
        os.setNroOs("OS-00000001");
        os.getLineas().get(0).setId(10L);
        os.getLineas().get(0).setSubtotal(new BigDecimal("1000"));
        os.getLineas().get(0).setImpProvisionado(new BigDecimal("400"));
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));

        OrdenServicioSaldoPendienteResponse result = service.saldoPendiente(1L);

        assertThat(result.getOrdenServicioId()).isEqualTo(1L);
        assertThat(result.getLineas()).hasSize(1);
        assertThat(result.getLineas().get(0).getSaldoPendiente()).isEqualByComparingTo("600");
        assertThat(result.getPorcentajeProvisionado()).isEqualByComparingTo("40.00");
        assertThat(result.getImpProvisionadoTotal()).isEqualByComparingTo("400");
        assertThat(result.getSaldoPendiente()).isEqualByComparingTo("600");
    }

    @Test
    @DisplayName("pendientesConformidad() modo aprobacion retorna lineas sin conformidad")
    void pendientesConformidad_modoAprobacion_retornaLineasSinConformidad() {
        OrdenServicio os = ordenServicioConDetalle(1L, "1");
        os.setProveedorId(10L);
        os.getLineas().get(0).setFlagEstado("1");
        os.getLineas().get(0).setConformidadFecha(null);

        EntidadContribuyenteRef proveedor = mock(EntidadContribuyenteRef.class);
        when(proveedor.getNombreCompleto()).thenReturn("Proveedor Test");
        when(ordenServicioRepository.findAll(any(Specification.class))).thenReturn(List.of(os));
        when(entidadContribuyenteRefRepository.findById(10L)).thenReturn(Optional.of(proveedor));

        ServicioCatalogo servicio = mock(ServicioCatalogo.class);
        when(servicio.getServicio()).thenReturn("SRV-001");
        when(servicioCatalogoRepository.findById(anyLong())).thenReturn(Optional.of(servicio));

        Page<LineaConformidadResponse> result =
                service.pendientesConformidad(null, 10L, LocalDate.now().minusDays(1), LocalDate.now().plusDays(1), Pageable.ofSize(10));

        assertThat(result.getContent()).hasSize(1);
        assertThat(result.getContent().get(0).getProveedorNombre()).isEqualTo("Proveedor Test");
        assertThat(result.getContent().get(0).getServicioCodigo()).isEqualTo("SRV-001");
    }

    @Test
    @DisplayName("pendientesConformidad() modo desaprobacion retorna lineas conformadas")
    void pendientesConformidad_modoDesaprobacion_retornaLineasConformadas() {
        OrdenServicio os = ordenServicioConDetalle(2L, "1");
        os.setProveedorId(10L);
        os.getLineas().get(0).setFlagEstado("1");
        os.getLineas().get(0).setConformidadFecha(OffsetDateTime.now());
        os.getLineas().get(0).setConformidadUsr(8L);

        when(ordenServicioRepository.findAll(any(Specification.class))).thenReturn(List.of(os));
        when(entidadContribuyenteRefRepository.findById(10L)).thenReturn(Optional.empty());
        when(servicioCatalogoRepository.findById(anyLong())).thenReturn(Optional.empty());

        UsuarioRef usuario = mock(UsuarioRef.class);
        when(usuario.getUsername()).thenReturn("qa.user");
        when(usuarioRefRepository.findById(8L)).thenReturn(Optional.of(usuario));

        Page<LineaConformidadResponse> result =
                service.pendientesConformidad("DESAPROBACION", null, null, null, Pageable.ofSize(10));

        assertThat(result.getContent()).hasSize(1);
        assertThat(result.getContent().get(0).getConformidadUsrNombre()).isEqualTo("qa.user");
    }

    @Test
    @DisplayName("serviciosDisponibles() filtra activos y subcategoria")
    void serviciosDisponibles_filtraActivosYSubcategoria() {
        ServicioCatalogo activo = mock(ServicioCatalogo.class);
        when(activo.getFlagEstado()).thenReturn("1");
        when(activo.getArticuloSubCategId()).thenReturn(5L);
        when(activo.getId()).thenReturn(1L);
        when(activo.getServicio()).thenReturn("SRV-1");

        ServicioCatalogo inactivo = mock(ServicioCatalogo.class);
        when(inactivo.getFlagEstado()).thenReturn("0");

        when(servicioCatalogoRepository.findAll()).thenReturn(List.of(activo, inactivo));

        List<ServicioDisponibleResponse> result = service.serviciosDisponibles(null, null, LocalDate.now(), "5");

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getServicio()).isEqualTo("SRV-1");
    }

    @Test
    @DisplayName("obtenerAsignaciones() retorna detalle")
    void obtenerAsignaciones_retornaDetalle() {
        OrdenServicio os = ordenServicio(1L, "1");
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));

        AsignacionOsOc asignacion = new AsignacionOsOc();
        AsignacionOsOcDet detalle = new AsignacionOsOcDet();
        detalle.setOrdenServicioDetId(11L);
        detalle.setOrdenCompraDetId(22L);
        detalle.setMontoAplicado(new BigDecimal("99.90"));
        asignacion.getDetalles().add(detalle);
        when(asignacionOsOcRepository.findByOrdenServicioId(1L)).thenReturn(List.of(asignacion));

        List<AsignacionOsOcRequest.LineaAsignacion> result = service.obtenerAsignaciones(1L);

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getLineaOsId()).isEqualTo(11L);
        assertThat(result.get(0).getLineaOcId()).isEqualTo(22L);
    }

    @Test
    @DisplayName("cuentasPagar() mapea referencias vinculadas")
    void cuentasPagar_mapeaReferencias() {
        OrdenServicio os = ordenServicio(1L, "1");
        when(ordenServicioRepository.findById(1L)).thenReturn(Optional.of(os));

        pe.restaurant.compras.entity.CntasPagarRef cp = mock(pe.restaurant.compras.entity.CntasPagarRef.class);
        when(cp.getId()).thenReturn(7L);
        when(cp.getCodRelacion()).thenReturn("CP-001");
        when(cp.getTipoDoc()).thenReturn("FAC");
        when(cp.getNroDoc()).thenReturn("F001-1");
        when(cp.getFecha()).thenReturn(LocalDate.now());
        when(cp.getMontoTotal()).thenReturn(new BigDecimal("450.00"));
        when(cp.getFlagEstado()).thenReturn("1");
        when(cntasPagarRefRepository.findByOrdenServicioIdAndFlagEstadoOrderByFechaDesc(1L, "1"))
                .thenReturn(List.of(cp));

        List<CuentaPagarVinculadaResponse> result = service.cuentasPagar(1L);

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getCodRelacion()).isEqualTo("CP-001");
        assertThat(result.get(0).getMontoTotal()).isEqualByComparingTo("450.00");
    }
}
