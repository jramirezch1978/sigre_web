package com.sigre.compras.service.impl;

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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.mail.javamail.JavaMailSender;
import com.sigre.compras.dto.*;
import com.sigre.compras.entity.*;
import com.sigre.compras.client.AlmacenClient;
import com.sigre.compras.repository.*;
import com.sigre.compras.service.OrdenCompraCalculator;
import com.sigre.compras.service.OrdenCompraPdfService;
import com.sigre.compras.service.OrdenCompraValidator;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.common.service.NumeradorDocumentoService;
import org.springframework.http.HttpStatus;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.OffsetDateTime;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static com.sigre.compras.ComprasTestFixtures.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("OrdenCompraServiceImpl — Pruebas Unitarias")
class OrdenCompraServiceImplTest {

    @Mock private OrdenCompraRepository ordenCompraRepository;
    @Mock private AprobacionRepository aprobacionRepository;
    @Mock private OcImportacionRepository ocImportacionRepository;
    @Mock private ArticuloMovProyRepository articuloMovProyRepository;
    @Mock private EntidadBancoCntaRepository entidadBancoCntaRepository;
    @Mock private NumeradorDocumentoService numeradorDocumentoService;
    @Mock private OrdenCompraCalculator calculator;
    @Mock private OrdenCompraValidator validator;
    @Mock private OrdenCompraPdfService pdfService;
    @Mock private ConfiguracionRefRepository configuracionRefRepository;
    @Mock private EntidadContribuyenteRefRepository entidadContribuyenteRefRepository;
    @Mock private ArticuloRefRepository articuloRefRepository;
    @Mock private UnidadMedidaRefRepository unidadMedidaRefRepository;
    @Mock private ArticuloCategoriaRefRepository articuloCategoriaRefRepository;
    @Mock private ArticuloAlmacenRefRepository articuloAlmacenRefRepository;
    @Mock private AlmacenTacitoRefRepository almacenTacitoRefRepository;
    @Mock private ValeMovRefRepository valeMovRefRepository;
    @Mock private ArticuloPrecioPactadoRepository articuloPrecioPactadoRepository;
    @Mock private AprobadorConfiguradoRepository aprobadorConfiguradoRepository;
    @Mock private MonedaRefRepository monedaRefRepository;
    @Mock private CompradorRepository compradorRepository;
    @Mock private UsuarioRefRepository usuarioRefRepository;
    @Mock private JdbcTemplate jdbcTemplate;
    @Mock private JavaMailSender mailSender;
    @Mock private AlmacenClient almacenClient;

    @InjectMocks private OrdenCompraServiceImpl service;

    @BeforeEach
    void setUp() throws Exception {
        TenantContext.setUsuarioId(1L);
        lenient().when(articuloRefRepository.findById(anyLong())).thenReturn(Optional.empty());
        lenient().when(configuracionRefRepository.findFirstByParametro(anyString())).thenReturn(Optional.empty());
        lenient().when(articuloPrecioPactadoRepository.findPrecioVigente(any(), any(), any(), any())).thenReturn(Optional.empty());
        lenient().when(articuloAlmacenRefRepository.findByArticuloIdAndAlmacenId(any(), any())).thenReturn(Optional.empty());
        lenient().when(articuloCategoriaRefRepository.findById(anyLong())).thenReturn(Optional.empty());
        lenient().when(almacenTacitoRefRepository.findFirstByCodClaseAndSucursalId(any(), any())).thenReturn(Optional.empty());
        lenient().when(unidadMedidaRefRepository.findById(anyLong())).thenReturn(Optional.empty());
        lenient().when(monedaRefRepository.findById(anyLong())).thenReturn(Optional.empty());
        lenient().when(entidadContribuyenteRefRepository.findById(anyLong())).thenReturn(Optional.empty());
        lenient().when(compradorRepository.findById(anyLong())).thenReturn(Optional.empty());
        lenient().when(usuarioRefRepository.findById(anyLong())).thenReturn(Optional.empty());
        lenient().when(aprobadorConfiguradoRepository.findAll()).thenReturn(List.of());
        lenient().when(jdbcTemplate.queryForObject(
                eq("SELECT id FROM core.doc_tipo WHERE codigo = ? AND flag_estado = '1'"),
                eq(Long.class), eq("OC")))
                .thenReturn(1L);

        java.lang.reflect.Field mailField = OrdenCompraServiceImpl.class.getDeclaredField("mailSender");
        mailField.setAccessible(true);
        mailField.set(service, mailSender);
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
        OrdenCompra oc = ordenCompra(1L);
        Page<OrdenCompra> page = new PageImpl<>(List.of(oc));

        when(ordenCompraRepository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(page);

        Page<OrdenCompraResumenResponse> result = service.listar(
                null, null, null, null, null, null, null, Pageable.unpaged());

        assertThat(result.getContent()).hasSize(1);
        assertThat(result.getContent().get(0).getId()).isEqualTo(1L);
    }

    // ── pendientesAprobacion ──

    @Test
    @DisplayName("pendientesAprobacion() retorna página")
    @SuppressWarnings("unchecked")
    void pendientesAprobacion_retornaPagina() {
        OrdenCompra oc = ordenCompra(1L, "3");
        when(ordenCompraRepository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(oc)));

        Page<OrdenCompraResumenResponse> result = service.pendientesAprobacion(Pageable.unpaged());

        assertThat(result.getContent()).hasSize(1);
    }

    // ── obtener ──

    @Test
    @DisplayName("obtener() existente -> retorna detalle")
    void obtener_existente_retornaDetalle() {
        OrdenCompra oc = ordenCompra(1L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));

        OrdenCompraDetalleResponse result = service.obtener(1L);

        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getNroOrdenCompra()).isEqualTo("OC-001");
    }

    @Test
    @DisplayName("obtener() no existente -> lanza excepción")
    void obtener_noExistente_lanzaExcepcion() {
        when(ordenCompraRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtener(99L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    // ── crear ──

    @Test
    @DisplayName("crear() ok -> genera nro y guarda")
    void crear_ok_generaNroYGuarda() {
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(validator.isFondosControlActivo()).thenReturn(false);
        when(numeradorDocumentoService.siguienteNroDocumentoIndependiente(any(), any(), anyInt()))
                .thenReturn("OC-2026-000001");
        when(entidadBancoCntaRepository.findFirstByEntidadContribuyenteIdAndMonedaIdAndFlagEstadoOrderByIdDesc(any(), any(), any()))
                .thenReturn(Optional.empty());

        OrdenCompra savedOc = ordenCompra(1L);
        savedOc.setNroOrdenCompra("OC-2026-000001");
        when(ordenCompraRepository.save(any(OrdenCompra.class))).thenReturn(savedOc);

        OrdenCompraCabeceraRequest req = ordenCompraRequest();
        OrdenCompraDetalleResponse result = service.crear(req);

        assertThat(result).isNotNull();
        verify(validator).verificarCompradorActivo();
        verify(validator).validarCabecera(req);
        verify(validator).validarDetalle(req.getLineas());
        verify(validator).validarDetalleFino(eq(req.getLineas()), any(LocalDate.class));
        verify(calculator).calcularTotales(any(OrdenCompra.class));
        verify(numeradorDocumentoService).siguienteNroDocumentoIndependiente(eq("compras.orden_compra"), eq(1L), anyInt());
        verify(ordenCompraRepository).save(any(OrdenCompra.class));
    }

    @Test
    @DisplayName("crear() sin aprobación estado generada")
    void crear_estadoPendienteAprobacion() {
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(validator.isFondosControlActivo()).thenReturn(false);
        when(numeradorDocumentoService.siguienteNroDocumentoIndependiente(any(), any(), anyInt()))
                .thenReturn("OC-2026-000005");
        when(entidadBancoCntaRepository.findFirstByEntidadContribuyenteIdAndMonedaIdAndFlagEstadoOrderByIdDesc(any(), any(), any()))
                .thenReturn(Optional.empty());

        when(ordenCompraRepository.save(any(OrdenCompra.class))).thenAnswer(inv -> {
            OrdenCompra captured = inv.getArgument(0);
            captured.setId(5L);
            captured.setNroOrdenCompra("OC-2026-000005");
            return captured;
        });

        OrdenCompraDetalleResponse result = service.crear(ordenCompraRequest());

        assertThat(result).isNotNull();
        assertThat(result.getFlagEstado()).isEqualTo("3");
    }

    @Test
    @DisplayName("crear() con aprobación estado borrador")
    void crear_conAprobacion_estadoPendiente() {
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(validator.isFondosControlActivo()).thenReturn(false);
        when(numeradorDocumentoService.siguienteNroDocumentoIndependiente(any(), any(), anyInt()))
                .thenReturn("OC-2026-000006");
        when(entidadBancoCntaRepository.findFirstByEntidadContribuyenteIdAndMonedaIdAndFlagEstadoOrderByIdDesc(any(), any(), any()))
                .thenReturn(Optional.empty());

        when(ordenCompraRepository.save(any(OrdenCompra.class))).thenAnswer(inv -> {
            OrdenCompra captured = inv.getArgument(0);
            captured.setId(6L);
            captured.setNroOrdenCompra("OC-2026-000006");
            return captured;
        });

        OrdenCompraDetalleResponse result = service.crear(ordenCompraRequest());

        assertThat(result).isNotNull();
        assertThat(result.getFlagEstado()).isEqualTo("3");
    }

    @Test
    @DisplayName("crear() con fondos -> verifica y consume")
    void crear_conFondos_verificaYConsume() {
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(validator.isFondosControlActivo()).thenReturn(true);
        when(numeradorDocumentoService.siguienteNroDocumentoIndependiente(any(), any(), anyInt()))
                .thenReturn("OC-2026-000002");
        when(entidadBancoCntaRepository.findFirstByEntidadContribuyenteIdAndMonedaIdAndFlagEstadoOrderByIdDesc(any(), any(), any()))
                .thenReturn(Optional.empty());

        OrdenCompra savedOc = ordenCompra(2L);
        when(ordenCompraRepository.save(any(OrdenCompra.class))).thenReturn(savedOc);

        service.crear(ordenCompraRequest());

        verify(validator).verificarFondosDisponibles(any(OrdenCompra.class));
        verify(validator).consumirFondos(any(OrdenCompra.class));
    }

    @Test
    @DisplayName("crear() con importación -> guarda importación")
    void crear_conImportacion_guardaImportacion() {
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(validator.isFondosControlActivo()).thenReturn(false);
        when(numeradorDocumentoService.siguienteNroDocumentoIndependiente(any(), any(), anyInt()))
                .thenReturn("OC-2026-000003");
        when(entidadBancoCntaRepository.findFirstByEntidadContribuyenteIdAndMonedaIdAndFlagEstadoOrderByIdDesc(any(), any(), any()))
                .thenReturn(Optional.empty());

        OrdenCompra savedOc = ordenCompra(3L);
        when(ordenCompraRepository.save(any(OrdenCompra.class))).thenReturn(savedOc);

        OcImportacionRequest impReq = new OcImportacionRequest();
        impReq.setIncoterm("FOB");
        impReq.setPuertoEmbarque("Shanghai");

        OrdenCompraCabeceraRequest req = ordenCompraRequest();
        req.setFlagImportacion(true);
        req.setImportacion(impReq);

        when(ocImportacionRepository.findByOrdenCompraId(3L)).thenReturn(Optional.empty());

        service.crear(req);

        verify(ocImportacionRepository).save(any(OcImportacion.class));
    }

    @Test
    @DisplayName("crear() con banco proveedor -> asigna banco y cuenta")
    void crear_conBancoProveedor_asignaBancoYCuenta() {
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(validator.isFondosControlActivo()).thenReturn(false);
        when(numeradorDocumentoService.siguienteNroDocumentoIndependiente(any(), any(), anyInt()))
                .thenReturn("OC-2026-000004");

        EntidadBancoCnta banco = entidadBancoCnta(10L, "123456789");
        when(entidadBancoCntaRepository.findFirstByEntidadContribuyenteIdAndMonedaIdAndFlagEstadoOrderByIdDesc(eq(1L), eq(1L), eq("1")))
                .thenReturn(Optional.of(banco));

        when(ordenCompraRepository.save(any(OrdenCompra.class))).thenAnswer(inv -> {
            OrdenCompra captured = inv.getArgument(0);
            captured.setId(4L);
            return captured;
        });

        OrdenCompraDetalleResponse result = service.crear(ordenCompraRequest());

        assertThat(result.getBancoId()).isEqualTo(10L);
        assertThat(result.getNroCuenta()).isEqualTo("123456789");
    }

    // ── actualizar ──

    @Test
    @DisplayName("actualizar() borrador -> ok")
    void actualizar_borrador_ok() {
        OrdenCompra existing = ordenCompra(1L, "1");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(existing));
        when(validator.isFondosControlActivo()).thenReturn(false);
        when(entidadBancoCntaRepository.findFirstByEntidadContribuyenteIdAndMonedaIdAndFlagEstadoOrderByIdDesc(any(), any(), any()))
                .thenReturn(Optional.empty());
        when(ordenCompraRepository.save(any(OrdenCompra.class))).thenReturn(existing);

        OrdenCompraCabeceraRequest req = ordenCompraRequest();
        OrdenCompraDetalleResponse result = service.actualizar(1L, req);

        assertThat(result).isNotNull();
        verify(validator).validarCabecera(req);
        verify(validator).validarDetalleFino(eq(req.getLineas()), any(LocalDate.class));
        verify(calculator).calcularTotales(any(OrdenCompra.class));
    }

    @Test
    @DisplayName("actualizar() pendiente aprobación -> ok")
    void actualizar_pendienteAprobacion_ok() {
        OrdenCompra existing = ordenCompra(1L, "3");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(existing));
        when(validator.isFondosControlActivo()).thenReturn(false);
        when(entidadBancoCntaRepository.findFirstByEntidadContribuyenteIdAndMonedaIdAndFlagEstadoOrderByIdDesc(any(), any(), any()))
                .thenReturn(Optional.empty());
        when(ordenCompraRepository.save(any(OrdenCompra.class))).thenReturn(existing);

        OrdenCompraDetalleResponse result = service.actualizar(1L, ordenCompraRequest());

        assertThat(result).isNotNull();
    }

    @Test
    @DisplayName("actualizar() aprobada -> lanza COM-025")
    void actualizar_aprobada_lanzaCOM025() {
        OrdenCompra existing = ordenCompra(1L, "2");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(existing));

        assertThatThrownBy(() -> service.actualizar(1L, ordenCompraRequest()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("pendiente de aprobacion");
    }

    @Test
    @DisplayName("actualizar() con línea procesada -> preserva cant procesada")
    void actualizar_conLineaProcesada_preservaCantProcesada() {
        OrdenCompra existing = ordenCompraConDetalle(1L, "1");
        existing.getLineas().get(0).setCantProcesada(new BigDecimal("5"));
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(existing));
        when(validator.isFondosControlActivo()).thenReturn(false);
        when(entidadBancoCntaRepository.findFirstByEntidadContribuyenteIdAndMonedaIdAndFlagEstadoOrderByIdDesc(any(), any(), any()))
                .thenReturn(Optional.empty());
        when(ordenCompraRepository.save(any(OrdenCompra.class))).thenAnswer(inv -> inv.getArgument(0));

        OrdenCompraCabeceraRequest req = ordenCompraRequest();
        OrdenCompraLineaRequest lr = req.getLineas().get(0);
        lr.setId(100L);
        lr.setCantProyectada(new BigDecimal("20"));

        service.actualizar(1L, req);

        verify(ordenCompraRepository).save(argThat(oc -> {
            OrdenCompraDet linea = oc.getLineas().get(0);
            return linea.getCantProcesada().compareTo(new BigDecimal("5")) == 0
                    && linea.getCantProyectada().compareTo(new BigDecimal("10")) == 0;
        }));
    }

    // ── modificarIgv ──

    @Test
    @DisplayName("modificarIgv() pendiente aprobación -> ok")
    void modificarIgv_pendienteAprobacion_ok() {
        OrdenCompra oc = ordenCompraConDetalle(1L, "3");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findByIdWithLineas(1L)).thenReturn(Optional.of(oc));
        when(ordenCompraRepository.save(any(OrdenCompra.class))).thenReturn(oc);

        ModificarIgvRequest req = new ModificarIgvRequest();
        ModificarIgvRequest.LineaIgv cambio = new ModificarIgvRequest.LineaIgv();
        cambio.setLineaId(100L);
        cambio.setTipoImpuestoId(1L);
        req.setLineas(List.of(cambio));

        OrdenCompraDetalleResponse result = service.modificarIgv(1L, req);

        assertThat(result).isNotNull();
        verify(calculator).calcularTotales(any(OrdenCompra.class));
    }

    @Test
    @DisplayName("modificarIgv() estado incorrecto -> lanza COM-030")
    void modificarIgv_estadoIncorrecto_lanzaCOM030() {
        OrdenCompra oc = ordenCompra(1L, "2");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findByIdWithLineas(1L)).thenReturn(Optional.of(oc));

        ModificarIgvRequest req = new ModificarIgvRequest();
        req.setLineas(List.of());

        assertThatThrownBy(() -> service.modificarIgv(1L, req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("pendiente de aprobación o activa");
    }

    @Test
    @DisplayName("modificarIgv() línea no existe -> lanza COM-031")
    void modificarIgv_lineaNoExiste_lanzaCOM031() {
        OrdenCompra oc = ordenCompraConDetalle(1L, "1");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findByIdWithLineas(1L)).thenReturn(Optional.of(oc));

        ModificarIgvRequest req = new ModificarIgvRequest();
        ModificarIgvRequest.LineaIgv cambio = new ModificarIgvRequest.LineaIgv();
        cambio.setLineaId(999L);
        cambio.setTipoImpuestoId(1L);
        req.setLineas(List.of(cambio));

        assertThatThrownBy(() -> service.modificarIgv(1L, req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("no pertenece");
    }

    // ── enviarAprobacion ──

    @Test
    @DisplayName("enviarAprobacion() generada -> ok")
    void enviarAprobacion_generada_ok() {
        OrdenCompra oc = ordenCompra(1L, "1");
        oc.setFlagEstado("1");
        ConfiguracionRef cfg = new ConfiguracionRef();
        cfg.setParametro("COMPRA_APROBACION_OC");
        cfg.setValorTexto("1");
        when(configuracionRefRepository.findFirstByParametro("COMPRA_APROBACION_OC"))
                .thenReturn(Optional.of(cfg));
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        when(ordenCompraRepository.save(any(OrdenCompra.class))).thenReturn(oc);

        OrdenCompraDetalleResponse result = service.enviarAprobacion(1L);

        assertThat(result).isNotNull();
        verify(validator).verificarPrecios(oc);
        verify(aprobacionRepository).save(any(Aprobacion.class));
    }

    @Test
    @DisplayName("enviarAprobacion() borrador -> ok")
    void enviarAprobacion_borrador_ok() {
        OrdenCompra oc = ordenCompra(1L, "1");
        ConfiguracionRef cfg = new ConfiguracionRef();
        cfg.setParametro("COMPRA_APROBACION_OC");
        cfg.setValorTexto("1");
        when(configuracionRefRepository.findFirstByParametro("COMPRA_APROBACION_OC"))
                .thenReturn(Optional.of(cfg));
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        when(ordenCompraRepository.save(any(OrdenCompra.class))).thenReturn(oc);

        OrdenCompraDetalleResponse result = service.enviarAprobacion(1L);

        assertThat(result).isNotNull();
    }

    @Test
    @DisplayName("enviarAprobacion() estado incorrecto -> lanza COM-011")
    void enviarAprobacion_estadoIncorrecto_lanzaCOM011() {
        OrdenCompra oc = ordenCompra(1L, "2");
        ConfiguracionRef cfg = new ConfiguracionRef();
        cfg.setParametro("COMPRA_APROBACION_OC");
        cfg.setValorTexto("1");
        when(configuracionRefRepository.findFirstByParametro("COMPRA_APROBACION_OC"))
                .thenReturn(Optional.of(cfg));
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));

        assertThatThrownBy(() -> service.enviarAprobacion(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("activa o rechazada");
    }

    // ── aprobar ──

    @Test
    @DisplayName("aprobar() pendiente -> ok")
    void aprobar_pendiente_ok() {
        OrdenCompra oc = ordenCompra(1L, "3");
        oc.setTotal(new BigDecimal("1000"));
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        when(ordenCompraRepository.save(any(OrdenCompra.class))).thenReturn(oc);

        OrdenCompraDetalleResponse result = service.aprobar(1L, "OK");

        assertThat(result).isNotNull();
        verify(validator).validarAprobadorConfigurado(eq(1L), any(BigDecimal.class));
        verify(aprobacionRepository).save(any(Aprobacion.class));
    }

    @Test
    @DisplayName("aprobar() no es pendiente -> lanza COM-021")
    void aprobar_noEsPendiente_lanzaCOM021() {
        OrdenCompra oc = ordenCompra(1L, "1");
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));

        assertThatThrownBy(() -> service.aprobar(1L, "OK"))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("pendiente de aprobación");
    }

    // ── rechazar ──

    @Test
    @DisplayName("rechazar() pendiente ok estado rechazada")
    void rechazar_pendiente_ok_estadoRechazada() {
        OrdenCompra oc = ordenCompra(1L, "3");
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        when(ordenCompraRepository.save(any(OrdenCompra.class))).thenReturn(oc);

        OrdenCompraDetalleResponse result = service.rechazar(1L, "No cumple especificaciones");

        assertThat(result).isNotNull();
        assertThat(oc.getFlagEstado()).isEqualTo("0");
        verify(aprobacionRepository).save(any(Aprobacion.class));
    }

    @Test
    @DisplayName("rechazar() no es pendiente -> lanza COM-021")
    void rechazar_noEsPendiente_lanzaCOM021() {
        OrdenCompra oc = ordenCompra(1L, "1");
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));

        assertThatThrownBy(() -> service.rechazar(1L, "motivo"))
                .isInstanceOf(BusinessException.class);
    }
    // ── devolver ──

    @Test
    @DisplayName("devolver() pendiente aprobación -> ok")
    void devolver_pendienteAprobacion_ok() {
        OrdenCompra oc = ordenCompraConDetalle(1L, "3");
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        when(ordenCompraRepository.save(any(OrdenCompra.class))).thenReturn(oc);

        OrdenCompraDetalleResponse result = service.devolver(1L, "Falta almacén");

        assertThat(result).isNotNull();
        assertThat(oc.getFlagEstado()).isEqualTo("1");
        verify(aprobacionRepository).save(any());
    }

    @Test
    @DisplayName("devolver() no pendiente -> lanza excepción")
    void devolver_noPendiente_lanzaExcepcion() {
        OrdenCompra oc = ordenCompraConDetalle(1L, "1");
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));

        assertThatThrownBy(() -> service.devolver(1L, "motivo"))
                .isInstanceOf(BusinessException.class);
    }

    @Test
    @DisplayName("devolver() no existe -> lanza excepción")
    void devolver_noExiste_lanzaExcepcion() {
        when(ordenCompraRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.devolver(99L, "motivo"))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    // ── anular ──

    @Test
    @DisplayName("anular() generada sin ingresos -> ok")
    void anular_generada_sinIngresos_ok() {
        OrdenCompra oc = ordenCompraConDetalle(1L, "1");
        oc.setFlagEstado("1");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        when(validator.isFondosControlActivo()).thenReturn(false);
        when(ordenCompraRepository.save(any(OrdenCompra.class))).thenReturn(oc);

        OrdenCompraDetalleResponse result = service.anular(1L, "Por error");

        assertThat(result).isNotNull();
        assertThat(oc.getFlagEstado()).isEqualTo("0");
        assertThat(oc.getFlagEstado()).isEqualTo("0");
        verify(validator).verificarNoVieneDeAprovisionamiento(1L);
        verify(validator).verificarSinAnticipos(1L);
    }

    @Test
    @DisplayName("anular() con ingresos -> lanza COM-013")
    void anular_conIngresos_lanzaCOM013() {
        OrdenCompra oc = ordenCompraConDetalle(1L);
        oc.setFlagEstado("1");
        oc.getLineas().get(0).setCantProcesada(new BigDecimal("5"));
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));

        assertThatThrownBy(() -> service.anular(1L, "Motivo"))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("ingresos al almacén");
    }

    @Test
    @DisplayName("anular() anulada -> lanza COM-011")
    void anular_anulada_lanzaCOM011() {
        OrdenCompra oc = ordenCompra(1L);
        oc.setFlagEstado("0");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));

        assertThatThrownBy(() -> service.anular(1L, "Motivo"))
                .isInstanceOf(BusinessException.class);
    }

    @Test
    @DisplayName("anular() con fondos -> libera fondos")
    void anular_conFondos_liberaFondos() {
        OrdenCompra oc = ordenCompraConDetalle(1L);
        oc.setFlagEstado("1");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        when(validator.isFondosControlActivo()).thenReturn(true);
        when(ordenCompraRepository.save(any(OrdenCompra.class))).thenReturn(oc);

        service.anular(1L, "Motivo");

        verify(validator).liberarFondos(oc);
    }

    // ── cerrar ──

    @Test
    @DisplayName("cerrar() ok")
    void cerrar_ok() {
        OrdenCompra oc = ordenCompraConDetalle(1L);
        oc.setFlagEstado("1");
        oc.setFlagImportacion("0");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        when(ordenCompraRepository.save(any(OrdenCompra.class))).thenReturn(oc);

        OrdenCompraDetalleResponse result = service.cerrar(1L);

        assertThat(result).isNotNull();
        assertThat(oc.getFlagEstado()).isEqualTo("2");
        assertThat(oc.getFlagEstado()).isEqualTo("2");
    }

    @Test
    @DisplayName("cerrar() anulada -> lanza COM-015")
    void cerrar_anulada_lanzaCOM015() {
        OrdenCompra oc = ordenCompra(1L);
        oc.setFlagEstado("0");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));

        assertThatThrownBy(() -> service.cerrar(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("anulada");
    }

    @Test
    @DisplayName("cerrar() importación sin DUA -> lanza COM-016")
    void cerrar_importacionSinDua_lanzaCOM016() {
        OrdenCompra oc = ordenCompraConDetalle(1L);
        oc.setFlagEstado("1");
        oc.setFlagImportacion("1");
        oc.setFlagSolicitaDua("1");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        when(ocImportacionRepository.findByOrdenCompraId(1L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.cerrar(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("DUA");
    }

    @Test
    @DisplayName("cerrar() importación con DUA -> ok")
    void cerrar_importacionConDua_ok() {
        OrdenCompra oc = ordenCompraConDetalle(1L);
        oc.setFlagEstado("1");
        oc.setFlagImportacion("1");
        oc.setFlagSolicitaDua("1");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));

        OcImportacion imp = ocImportacion(1L);
        when(ocImportacionRepository.findByOrdenCompraId(1L)).thenReturn(Optional.of(imp));
        when(ordenCompraRepository.save(any(OrdenCompra.class))).thenReturn(oc);

        OrdenCompraDetalleResponse result = service.cerrar(1L);
        assertThat(result).isNotNull();
    }

    // ── historial ──

    @Test
    @DisplayName("historial() retorna lista de aprobaciónes")
    void historial_retornaListaDeAprobaciones() {
        OrdenCompra oc = ordenCompra(1L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));

        Aprobacion a = aprobacion(1L, "APROBADA");

        when(jdbcTemplate.queryForObject(
                eq("SELECT id FROM core.doc_tipo WHERE codigo = ? AND flag_estado = '1'"),
                eq(Long.class), eq("OC")))
                .thenReturn(1L);
        when(aprobacionRepository.findByDocTipoIdAndDocumentoIdOrderByFechaAsc(1L, 1L))
                .thenReturn(List.of(a));

        List<HistorialAprobacionResponse> result = service.historial(1L);

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getAccion()).isEqualTo("APROBADA");
    }

    @Test
    @DisplayName("historial() oc no existente -> lanza excepción")
    void historial_ocNoExistente_lanzaExcepcion() {
        when(ordenCompraRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.historial(99L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    // ── recepciones ──

    @Test
    @DisplayName("recepciones() excepción repo -> propaga excepción")
    void recepciones_excepcionRepo_propagaExcepcion() {
        OrdenCompra oc = ordenCompra(1L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        when(valeMovRefRepository.findByOrdenCompraIdOrderByFechaDesc(1L))
                .thenThrow(new RuntimeException("no table"));

        assertThatThrownBy(() -> service.recepciones(1L))
                .isInstanceOf(RuntimeException.class)
                .hasMessageContaining("no table");
    }

    // ── saldoPendiente ──

    @Test
    @DisplayName("saldoPendiente() con líneas -> calcula correctamente")
    void saldoPendiente_conLineas_calculaCorrectamente() {
        OrdenCompra oc = ordenCompraConDetalle(1L);
        oc.setTotal(new BigDecimal("1000"));
        oc.setNroOrdenCompra("OC-001");
        oc.getLineas().get(0).setId(10L);
        oc.getLineas().get(0).setCantProyectada(new BigDecimal("100"));
        oc.getLineas().get(0).setCantProcesada(new BigDecimal("40"));
        oc.getLineas().get(0).setValorUnitario(new BigDecimal("10"));
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));

        OrdenCompraSaldoPendienteResponse result = service.saldoPendiente(1L);

        assertThat(result.getOrdenCompraId()).isEqualTo(1L);
        assertThat(result.getLineas()).hasSize(1);
        assertThat(result.getLineas().get(0).getCantidadPendiente()).isEqualByComparingTo("60");
        assertThat(result.getPorcentajeAtendido()).isEqualByComparingTo("40.00");
        assertThat(result.getTotalRecibido()).isNotEqualByComparingTo("0");
        assertThat(result.getPendiente().compareTo(result.getTotalPedido())).isLessThan(0);
    }

    @Test
    @DisplayName("saldoPendiente() sin líneas activas porcentaje cero")
    void saldoPendiente_sinLineasActivas_porcentajeCero() {
        OrdenCompra oc = ordenCompra(1L);
        oc.setTotal(new BigDecimal("1000"));
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));

        OrdenCompraSaldoPendienteResponse result = service.saldoPendiente(1L);

        assertThat(result.getPorcentajeAtendido()).isEqualByComparingTo("0");
        assertThat(result.getTotalRecibido()).isEqualByComparingTo("0");
        assertThat(result.getPendiente()).isEqualByComparingTo("1000");
    }

    @Test
    @DisplayName("saldoPendiente() línea inactiva -> ignorada")
    void saldoPendiente_lineaInactiva_ignorada() {
        OrdenCompra oc = new OrdenCompra();
        oc.setId(1L);
        oc.setNroOrdenCompra("OC-001");
        oc.setTotal(new BigDecimal("1000"));
        OrdenCompraDet l = new OrdenCompraDet();
        l.setId(10L);
        l.setFlagEstado("0");
        l.setCantProyectada(new BigDecimal("100"));
        l.setCantProcesada(BigDecimal.ZERO);
        l.setValorUnitario(new BigDecimal("10"));
        l.setArticuloId(1L);
        oc.addLinea(l);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));

        OrdenCompraSaldoPendienteResponse result = service.saldoPendiente(1L);

        assertThat(result.getLineas()).isEmpty();
    }

    // ── enviarProveedor ──

    @Test
    @DisplayName("enviarProveedor() oc no aprobada -> lanza COM-020")
    void enviarProveedor_ocNoAprobada_lanzaCOM020() {
        OrdenCompra oc = ordenCompra(1L, "0");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));

        assertThatThrownBy(() -> service.enviarProveedor(1L, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("activa");
    }

    // ── datosArticulo ──

    @Test
    @DisplayName("datosArticulo() sin comprador activo -> lanza COM-002")
    void datosArticulo_sinCompradorActivo_lanzaCOM002() {
        when(validator.verificarCompradorActivo())
                .thenThrow(new BusinessException("El usuario actual no está registrado como comprador activo",
                        HttpStatus.UNPROCESSABLE_ENTITY, "COM-002"));

        assertThatThrownBy(() -> service.datosArticulo(1L, 1L, 1L, 1L, LocalDate.now()))
                .isInstanceOf(BusinessException.class)
                .extracting(ex -> ((BusinessException) ex).getErrorCode())
                .isEqualTo("COM-002");
    }

    @Test
    @DisplayName("datosArticulo() con precio y almacen -> retorna datos")
    void datosArticulo_conPrecioYAlmacen_retornaDatos() {
        when(validator.verificarCompradorActivo()).thenReturn(10L);

        when(articuloPrecioPactadoRepository.findPrecioVigente(any(), any(), any(), any()))
                .thenReturn(Optional.of(new BigDecimal("50.00")));

        ArticuloRef articulo = mock(ArticuloRef.class);
        when(articulo.getArticuloCategId()).thenReturn(1L);
        when(articulo.getUnidadMedidaId()).thenReturn(10L);
        when(articuloRefRepository.findById(1L)).thenReturn(Optional.of(articulo));

        ArticuloCategoriaRef catRef = mock(ArticuloCategoriaRef.class);
        when(catRef.getCatArt()).thenReturn("CL01");
        when(articuloCategoriaRefRepository.findById(1L)).thenReturn(Optional.of(catRef));

        AlmacenTacitoRef almTacito = mock(AlmacenTacitoRef.class);
        when(almTacito.getAlmacenId()).thenReturn(5L);
        when(almacenTacitoRefRepository.findFirstByCodClaseAndSucursalId("CL01", 1L))
                .thenReturn(Optional.of(almTacito));

        ArticuloAlmacenRef artAlm = mock(ArticuloAlmacenRef.class);
        when(artAlm.getCantidadDisponible()).thenReturn(new BigDecimal("200"));
        when(articuloAlmacenRefRepository.findByArticuloIdAndAlmacenId(1L, 5L))
                .thenReturn(Optional.of(artAlm));

        ConfiguracionRef tasaPerc = mock(ConfiguracionRef.class);
        when(tasaPerc.getValorTexto()).thenReturn("2");
        when(configuracionRefRepository.findFirstByParametro("TASA_PERCEPCION"))
                .thenReturn(Optional.of(tasaPerc));

        UnidadMedidaRef umRef = mock(UnidadMedidaRef.class);
        when(umRef.getNombre()).thenReturn("Kilogramo");
        when(unidadMedidaRefRepository.findById(10L)).thenReturn(Optional.of(umRef));

        DatosArticuloResponse result = service.datosArticulo(1L, 1L, 1L, 1L, LocalDate.now());

        assertThat(result.getPrecioPactado()).isEqualByComparingTo("50.00");
        assertThat(result.getAlmacenTacitoId()).isEqualTo(5L);
        assertThat(result.getSaldoActual()).isEqualByComparingTo("200");
        assertThat(result.getFlagPercepcion()).isTrue();
        assertThat(result.getPercepcionTasa()).isEqualByComparingTo("2");
        assertThat(result.getUnidadMedidaId()).isEqualTo(10L);
        assertThat(result.getUnidadMedidaDescripcion()).isEqualTo("Kilogramo");
    }

    @Test
    @DisplayName("datosArticulo() sin datos -> retorna valores null")
    void datosArticulo_sinDatos_retornaValoresNull() {
        when(validator.verificarCompradorActivo()).thenReturn(10L);

        DatosArticuloResponse result = service.datosArticulo(1L, 1L, 1L, 1L, LocalDate.now());

        assertThat(result.getPrecioPactado()).isNull();
        assertThat(result.getAlmacenTacitoId()).isNull();
    }

    // ── pendientesAprobacion con rangos ──

    @Test
    @DisplayName("pendientesAprobacion() con aprobador con rango -> filtra por monto")
    @SuppressWarnings("unchecked")
    void pendientesAprobacion_conAprobadorConRango_filtraPorMonto() {
        AprobadorConfigurado a = new AprobadorConfigurado();
        a.setDocTipoId(1L);
        a.setAprobadorId(1L);
        a.setFlagEstado("1");
        a.setMontoMinimo(new BigDecimal("100"));
        a.setMontoMaximo(new BigDecimal("5000"));
        when(aprobadorConfiguradoRepository.findAll()).thenReturn(List.of(a));

        OrdenCompra oc = ordenCompra(1L, "3");
        when(ordenCompraRepository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(oc)));

        Page<OrdenCompraResumenResponse> result = service.pendientesAprobacion(Pageable.unpaged());
        assertThat(result.getContent()).hasSize(1);
    }

    @Test
    @DisplayName("pendientesAprobacion() sin monto min -> no filtra min")
    @SuppressWarnings("unchecked")
    void pendientesAprobacion_sinMontoMin_noFiltraMin() {
        AprobadorConfigurado a = new AprobadorConfigurado();
        a.setDocTipoId(1L);
        a.setAprobadorId(1L);
        a.setFlagEstado("1");
        a.setMontoMinimo(null);
        a.setMontoMaximo(null);
        when(aprobadorConfiguradoRepository.findAll()).thenReturn(List.of(a));

        when(ordenCompraRepository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of()));

        Page<OrdenCompraResumenResponse> result = service.pendientesAprobacion(Pageable.unpaged());
        assertThat(result).isNotNull();
    }

    // ── enviarProveedor más variantes ──

    @Test
    @DisplayName("enviarProveedor() sin mail sender -> lanza COM-032")
    void enviarProveedor_sinMailSender_lanzaCOM032() {
        OrdenCompra oc = ordenCompra(1L, "1");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));

        OrdenCompraServiceImpl serviceNoMail = buildServiceSinMailSender();

        assertThatThrownBy(() -> serviceNoMail.enviarProveedor(1L, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("correo no está configurado");
    }

    @Test
    @DisplayName("enviarProveedor() sin email proveedor -> lanza COM-033")
    void enviarProveedor_sinEmailProveedor_lanzaCOM033() {
        OrdenCompra oc = ordenCompra(1L, "1");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        when(entidadContribuyenteRefRepository.findById(anyLong())).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.enviarProveedor(1L, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("email del proveedor");
    }

    @Test
    @DisplayName("enviarProveedor() con email en request envia correo")
    void enviarProveedor_conEmailEnRequest_enviaCorreo() throws Exception {
        OrdenCompra oc = ordenCompra(1L, "1");
        oc.setNroOrdenCompra("OC-2026-000001");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        when(pdfService.generarPdf(1L)).thenReturn(new byte[]{1, 2, 3});

        jakarta.mail.internet.MimeMessage mimeMessage = mock(jakarta.mail.internet.MimeMessage.class);
        when(mailSender.createMimeMessage()).thenReturn(mimeMessage);

        EnviarProveedorRequest req = new EnviarProveedorRequest();
        req.setEmailDestino("prov@test.com");
        req.setAsunto("OC Test");
        req.setMensaje("Adjunto OC");

        boolean result = service.enviarProveedor(1L, req);
        assertThat(result).isTrue();
        verify(mailSender).send(any(jakarta.mail.internet.MimeMessage.class));
    }

    @Test
    @DisplayName("enviarProveedor() error al enviar -> lanza COM-034")
    void enviarProveedor_errorAlEnviar_lanzaCOM034() throws Exception {
        OrdenCompra oc = ordenCompra(1L, "1");
        oc.setNroOrdenCompra("OC-001");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        when(pdfService.generarPdf(1L)).thenReturn(new byte[]{1});

        jakarta.mail.internet.MimeMessage mimeMessage = mock(jakarta.mail.internet.MimeMessage.class);
        when(mailSender.createMimeMessage()).thenReturn(mimeMessage);
        doAnswer(inv -> { throw new jakarta.mail.MessagingException("SMTP fail"); })
                .when(mailSender).send(any(jakarta.mail.internet.MimeMessage.class));

        EnviarProveedorRequest req = new EnviarProveedorRequest();
        req.setEmailDestino("prov@test.com");

        assertThatThrownBy(() -> service.enviarProveedor(1L, req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Error al enviar");
    }

    @Test
    @DisplayName("enviarAprobacion() sin aprobación requerida -> lanza COM-035")
    void enviarAprobacion_sinAprobacionRequerida_lanzaCOM035() {
        when(validator.verificarCompradorActivo()).thenReturn(10L);

        ConfiguracionRef conf = mock(ConfiguracionRef.class);
        when(conf.getValorTexto()).thenReturn("0");
        when(configuracionRefRepository.findFirstByParametro("COMPRA_APROBACION_OC"))
                .thenReturn(Optional.of(conf));

        assertThatThrownBy(() -> service.enviarAprobacion(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("COMPRA_APROBACION_OC");
    }

    // ── recepciones happy path ──

    @Test
    @DisplayName("recepciones() con vales -> retorna lista")
    void recepciones_conVales_retornaLista() {
        OrdenCompra oc = ordenCompra(1L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));

        ValeMovRef vale = mock(ValeMovRef.class);
        when(vale.getId()).thenReturn(10L);
        when(vale.getNroVale()).thenReturn("VM-001");
        when(vale.getFecha()).thenReturn(LocalDate.now());
        when(vale.getFlagEstado()).thenReturn("CONFIRMADO");
        when(vale.getAlmacenId()).thenReturn(5L);
        when(valeMovRefRepository.findByOrdenCompraIdOrderByFechaDesc(1L))
                .thenReturn(List.of(vale));

        List<RecepcionResumenResponse> result = service.recepciones(1L);

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getNroVale()).isEqualTo("VM-001");
    }

    // ── toResumen/toDetalle con datos de referencia ──

    @Test
    @DisplayName("listar() con proveedor y moneda -> resuelve nombres")
    @SuppressWarnings("unchecked")
    void listar_conProveedorYMoneda_resuelveNombres() {
        OrdenCompra oc = ordenCompra(1L);
        oc.setCompradorId(10L);
        Page<OrdenCompra> page = new PageImpl<>(List.of(oc));
        when(ordenCompraRepository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(page);

        EntidadContribuyenteRef prov = mock(EntidadContribuyenteRef.class);
        when(prov.getNombreCompleto()).thenReturn("Proveedor Test");
        when(prov.getNroDocumento()).thenReturn("20123456789");
        when(entidadContribuyenteRefRepository.findById(1L)).thenReturn(Optional.of(prov));

        MonedaRef moneda = mock(MonedaRef.class);
        when(moneda.getCodigo()).thenReturn("PEN");
        when(monedaRefRepository.findById(1L)).thenReturn(Optional.of(moneda));

        Comprador comprador = mock(Comprador.class);
        when(comprador.getNombre()).thenReturn("Juan Perez");
        when(compradorRepository.findById(10L)).thenReturn(Optional.of(comprador));

        Page<OrdenCompraResumenResponse> result = service.listar(
                null, null, null, null, null, null, null, Pageable.unpaged());

        assertThat(result.getContent().get(0).getProveedorRazonSocial()).isEqualTo("Proveedor Test");
        assertThat(result.getContent().get(0).getMonedaCodigo()).isEqualTo("PEN");
        assertThat(result.getContent().get(0).getCompradorNombre()).isEqualTo("Juan Perez");
    }

    @Test
    @DisplayName("obtener() con importación -> incluye importación en detalle")
    void obtener_conImportacion_incluyeImportacionEnDetalle() {
        OrdenCompra oc = ordenCompra(1L);
        oc.setFlagImportacion("1");
        oc.setCompradorId(10L);
        oc.setAprobadorId(20L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));

        OcImportacion imp = ocImportacion(1L);
        when(ocImportacionRepository.findByOrdenCompraId(1L)).thenReturn(Optional.of(imp));

        Comprador comprador = mock(Comprador.class);
        when(comprador.getNombre()).thenReturn("");
        when(comprador.getUsuarioId()).thenReturn(1L);
        when(compradorRepository.findById(anyLong())).thenReturn(Optional.of(comprador));

        UsuarioRef usuario = mock(UsuarioRef.class);
        when(usuario.getUsername()).thenReturn("admin");
        when(usuarioRefRepository.findById(anyLong())).thenReturn(Optional.of(usuario));

        OrdenCompraDetalleResponse result = service.obtener(1L);

        assertThat(result.getImportacion()).isNotNull();
        assertThat(result.getImportacion().getIncoterm()).isEqualTo("FOB");
        assertThat(result.getCompradorNombre()).isEqualTo("admin");
    }

    @Test
    @DisplayName("obtener() comprador no existe -> resuelve como usuario")
    void obtener_compradorNoExiste_resuelveComoUsuario() {
        OrdenCompra oc = ordenCompra(1L);
        oc.setCompradorId(99L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        when(compradorRepository.findById(99L)).thenReturn(Optional.empty());

        UsuarioRef usuario = mock(UsuarioRef.class);
        when(usuario.getUsername()).thenReturn("user99");
        when(usuarioRefRepository.findById(99L)).thenReturn(Optional.of(usuario));

        OrdenCompraDetalleResponse result = service.obtener(1L);
        assertThat(result.getCompradorNombre()).isEqualTo("user99");
    }

    // ── actualizar más variantes ──

    @Test
    @DisplayName("actualizar() rechazada -> ok")
    void actualizar_rechazada_ok() {
        OrdenCompra existing = ordenCompra(1L, "0");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(existing));
        when(validator.isFondosControlActivo()).thenReturn(false);
        when(entidadBancoCntaRepository.findFirstByEntidadContribuyenteIdAndMonedaIdAndFlagEstadoOrderByIdDesc(any(), any(), any()))
                .thenReturn(Optional.empty());
        when(ordenCompraRepository.save(any(OrdenCompra.class))).thenReturn(existing);

        OrdenCompraDetalleResponse result = service.actualizar(1L, ordenCompraRequest());
        assertThat(result).isNotNull();
    }

    @Test
    @DisplayName("actualizar() con fondos -> libera y consume nuevos")
    void actualizar_conFondos_liberaYConsumeNuevos() {
        OrdenCompra existing = ordenCompraConDetalle(1L, "1");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(existing));
        when(validator.isFondosControlActivo()).thenReturn(true);
        when(entidadBancoCntaRepository.findFirstByEntidadContribuyenteIdAndMonedaIdAndFlagEstadoOrderByIdDesc(any(), any(), any()))
                .thenReturn(Optional.empty());
        when(ordenCompraRepository.save(any(OrdenCompra.class))).thenReturn(existing);

        service.actualizar(1L, ordenCompraRequest());

        verify(validator).liberarFondos(argThat(oc -> !oc.getLineas().isEmpty()));
        verify(validator).verificarFondosDisponibles(any(OrdenCompra.class));
        verify(validator).consumirFondos(any(OrdenCompra.class));
    }

    @Test
    @DisplayName("actualizar() con importación existente -> actualiza entity")
    void actualizar_conImportacionExistente_actualizaEntity() {
        OrdenCompra existing = ordenCompra(1L, "1");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(existing));
        when(validator.isFondosControlActivo()).thenReturn(false);
        when(entidadBancoCntaRepository.findFirstByEntidadContribuyenteIdAndMonedaIdAndFlagEstadoOrderByIdDesc(any(), any(), any()))
                .thenReturn(Optional.empty());
        when(ordenCompraRepository.save(any(OrdenCompra.class))).thenReturn(existing);

        OcImportacion existingImp = ocImportacion(1L);
        existingImp.setId(5L);
        when(ocImportacionRepository.findByOrdenCompraId(1L)).thenReturn(Optional.of(existingImp));

        OrdenCompraCabeceraRequest req = ordenCompraRequest();
        req.setFlagImportacion(true);
        OcImportacionRequest impReq = new OcImportacionRequest();
        impReq.setIncoterm("CIF");
        req.setImportacion(impReq);

        service.actualizar(1L, req);

        verify(ocImportacionRepository).save(argThat(imp -> imp.getId().equals(5L)));
    }

    // ── toLineaResponse con artículo resuelto ──

    @Test
    @DisplayName("obtener() con artículo en línea -> resuelve código descripción unidad")
    void obtener_conArticuloEnLinea_resuelveCodigoDescripcionUnidad() {
        OrdenCompra oc = ordenCompraConDetalle(1L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));

        ArticuloRef art = mock(ArticuloRef.class);
        when(art.getCodigo()).thenReturn("ART001");
        when(art.getNombre()).thenReturn("Tornillo");
        when(art.getUnidadMedidaId()).thenReturn(5L);
        when(articuloRefRepository.findById(1L)).thenReturn(Optional.of(art));

        UnidadMedidaRef um = mock(UnidadMedidaRef.class);
        when(um.getLabel()).thenReturn("UND");
        when(unidadMedidaRefRepository.findById(5L)).thenReturn(Optional.of(um));

        OrdenCompraDetalleResponse result = service.obtener(1L);

        assertThat(result.getLineas().get(0).getArticuloCodigo()).isEqualTo("ART001");
        assertThat(result.getLineas().get(0).getArticuloDescripcion()).isEqualTo("Tornillo");
        assertThat(result.getLineas().get(0).getUnidadMedidaCodigo()).isEqualTo("UND");
    }

    // ── datosArticulo más variantes ──

    @Test
    @DisplayName("datosArticulo() sin almacen tacito saldo null")
    void datosArticulo_sinAlmacenTacito_saldoNull() {
        when(validator.verificarCompradorActivo()).thenReturn(10L);

        ArticuloRef articulo = mock(ArticuloRef.class);
        when(articulo.getArticuloCategId()).thenReturn(null);
        when(articulo.getUnidadMedidaId()).thenReturn(null);
        when(articuloRefRepository.findById(1L)).thenReturn(Optional.of(articulo));

        DatosArticuloResponse result = service.datosArticulo(1L, 1L, 1L, 1L, LocalDate.now());

        assertThat(result.getAlmacenTacitoId()).isNull();
        assertThat(result.getSaldoActual()).isNull();
    }

    @Test
    @DisplayName("datosArticulo() artículo id null -> retorna todo null")
    void datosArticulo_articuloIdNull_retornaTodoNull() {
        when(validator.verificarCompradorActivo()).thenReturn(10L);

        DatosArticuloResponse result = service.datosArticulo(null, 1L, 1L, null, LocalDate.now());

        assertThat(result.getAlmacenTacitoId()).isNull();
    }

    // ── anular con detIds vacios ──

    @Test
    @DisplayName("anular() sin detalle ids -> no elimina mov proy")
    void anular_sinDetalleIds_noEliminaMovProy() {
        OrdenCompra oc = new OrdenCompra();
        oc.setId(1L);
        oc.setFlagEstado("1");
        oc.setFlagEstado("1");
        oc.setFechaEmision(LocalDate.now());
        oc.setTotal(BigDecimal.ZERO);
        oc.setSubtotal(BigDecimal.ZERO);
        oc.setDescuentoTotal(BigDecimal.ZERO);
        oc.setIgvTotal(BigDecimal.ZERO);
        oc.setPercepcionTotal(BigDecimal.ZERO);
        oc.setProveedorId(1L);
        oc.setMonedaId(1L);
        oc.setNroOrdenCompra("OC-001");
        oc.setFlagImportacion("0");

        OrdenCompraDet l = new OrdenCompraDet();
        l.setId(null);
        l.setArticuloId(1L);
        l.setFlagEstado("1");
        l.setCantProyectada(new BigDecimal("10"));
        l.setCantProcesada(BigDecimal.ZERO);
        l.setValorUnitario(new BigDecimal("100"));
        oc.addLinea(l);

        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));
        when(validator.isFondosControlActivo()).thenReturn(false);
        when(ordenCompraRepository.save(any(OrdenCompra.class))).thenReturn(oc);

        service.anular(1L, "Motivo");
        verify(articuloMovProyRepository, never()).deleteByOrdenCompraDetIdIn(anyList());
    }

    // ── modificarIgv con tipoImpuesto ──

    @Test
    @DisplayName("modificarIgv() con tipo impuesto -> actualiza tipo")
    void modificarIgv_conTipoImpuesto_actualizaTipo() {
        OrdenCompra oc = ordenCompraConDetalle(1L, "1");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findByIdWithLineas(1L)).thenReturn(Optional.of(oc));
        when(ordenCompraRepository.save(any(OrdenCompra.class))).thenReturn(oc);

        ModificarIgvRequest req = new ModificarIgvRequest();
        ModificarIgvRequest.LineaIgv cambio = new ModificarIgvRequest.LineaIgv();
        cambio.setLineaId(100L);
        cambio.setTipoImpuestoId(2L);
        req.setLineas(List.of(cambio));

        service.modificarIgv(1L, req);

        assertThat(oc.getLineas().get(0).getTipoImpuestoId()).isEqualTo(2L);
    }

    // ── Helpers ──

    @Test
    @DisplayName("recepcionarEnAlmacen() ok -> retorna movimiento y saldo")
    void recepcionarEnAlmacen_ok_retornaMovimientoYSaldo() {
        OrdenCompra oc = ordenCompraConDetalle(1L, "1");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));

        MovimientoDetalleResponse recepcion = MovimientoDetalleResponse.builder()
                .id(77L)
                .ordenCompraId(1L)
                .nroVale("VAL-001")
                .flagEstado("1")
                .build();
        when(almacenClient.recepcionOrdenCompra(any(IntegracionRecepcionOcRequest.class)))
                .thenReturn(com.sigre.common.dto.ApiResponse.ok(recepcion));
        doReturn(List.of()).when(jdbcTemplate)
                .query(anyString(), any(org.springframework.jdbc.core.RowMapper.class), eq(1L));

        OrdenCompraRecepcionRequest req = new OrdenCompraRecepcionRequest();
        req.setArticuloMovTipoId(9L);
        req.setAlmacenId(5L);
        req.setFechaMov(LocalDate.now());
        req.setObservaciones("Recepción parcial");

        OrdenCompraRecepcionResponse result = service.recepcionarEnAlmacen(1L, req);

        assertThat(result.getOrdenCompraId()).isEqualTo(1L);
        assertThat(result.getRecepcion()).isNotNull();
        assertThat(result.getRecepcion().getId()).isEqualTo(77L);
        verify(almacenClient).recepcionOrdenCompra(argThat(r ->
                r.getOrdenCompraId().equals(1L)
                        && r.getArticuloMovTipoId().equals(9L)
                        && r.getAlmacenId().equals(5L)));
    }

    @Test
    @DisplayName("recepcionarEnAlmacen() estado inválido -> lanza conflicto")
    void recepcionarEnAlmacen_estadoInvalido_lanzaConflicto() {
        OrdenCompra oc = ordenCompraConDetalle(1L, "0");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));

        OrdenCompraRecepcionRequest req = new OrdenCompraRecepcionRequest();
        req.setArticuloMovTipoId(9L);
        req.setAlmacenId(5L);

        assertThatThrownBy(() -> service.recepcionarEnAlmacen(1L, req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("activa");

        verifyNoInteractions(almacenClient);
    }

    @Test
    @DisplayName("recepcionarEnAlmacen() error remoto -> lanza business exception")
    void recepcionarEnAlmacen_errorRemoto_lanzaBusinessException() {
        OrdenCompra oc = ordenCompraConDetalle(1L, "1");
        when(validator.verificarCompradorActivo()).thenReturn(10L);
        when(ordenCompraRepository.findById(1L)).thenReturn(Optional.of(oc));

        when(almacenClient.recepcionOrdenCompra(any(IntegracionRecepcionOcRequest.class)))
                .thenThrow(feign.FeignException.errorStatus(
                        "recepcionOrdenCompra",
                        feign.Response.builder()
                                .status(422)
                                .reason("Unprocessable Entity")
                                .request(feign.Request.create(
                                        feign.Request.HttpMethod.POST,
                                        "/api/almacen/integraciones/recepcion-orden-compra",
                                        java.util.Map.of(),
                                        new byte[0],
                                        java.nio.charset.StandardCharsets.UTF_8,
                                        null))
                                .headers(java.util.Map.of())
                                .body("{\"message\":\"No hay líneas pendientes\"}", java.nio.charset.StandardCharsets.UTF_8)
                                .build()));

        OrdenCompraRecepcionRequest req = new OrdenCompraRecepcionRequest();
        req.setArticuloMovTipoId(9L);
        req.setAlmacenId(5L);

        assertThatThrownBy(() -> service.recepcionarEnAlmacen(1L, req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("No hay líneas pendientes");
    }

    private OrdenCompraServiceImpl buildServiceSinMailSender() {
        try {
            var ctor = OrdenCompraServiceImpl.class.getDeclaredConstructors()[0];
            ctor.setAccessible(true);
            return (OrdenCompraServiceImpl) ctor.newInstance(
                    ordenCompraRepository, aprobacionRepository, ocImportacionRepository,
                    articuloMovProyRepository, entidadBancoCntaRepository,
                    articuloPrecioPactadoRepository, numeradorDocumentoService,
                    calculator, validator, pdfService, configuracionRefRepository,
                    entidadContribuyenteRefRepository, articuloRefRepository,
                    unidadMedidaRefRepository, articuloCategoriaRefRepository,
                    articuloAlmacenRefRepository, almacenTacitoRefRepository,
                    valeMovRefRepository, aprobadorConfiguradoRepository,
                    monedaRefRepository, compradorRepository, usuarioRefRepository,
                    jdbcTemplate, almacenClient);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}


