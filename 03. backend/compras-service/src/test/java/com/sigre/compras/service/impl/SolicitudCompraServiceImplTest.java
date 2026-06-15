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
import com.sigre.compras.dto.*;
import com.sigre.compras.entity.SolicitudCompra;
import com.sigre.compras.mapper.SolicitudCompraMapper;
import com.sigre.compras.repository.ArticuloRefRepository;
import com.sigre.compras.repository.CotizacionRepository;
import com.sigre.compras.repository.OrdenCompraRepository;
import com.sigre.compras.repository.SolicitudCompraRepository;
import com.sigre.compras.repository.UsuarioRefRepository;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.common.service.NumeradorDocumentoService;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static com.sigre.compras.ComprasTestFixtures.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("SolicitudCompraServiceImpl — Pruebas Unitarias")
class SolicitudCompraServiceImplTest {

    @Mock private SolicitudCompraRepository solicitudCompraRepository;
    @Mock private ArticuloRefRepository articuloRefRepository;
    @Mock private CotizacionRepository cotizacionRepository;
    @Mock private OrdenCompraRepository ordenCompraRepository;
    @Mock private UsuarioRefRepository usuarioRefRepository;
    @Mock private SolicitudCompraMapper mapper;
    @Mock private NumeradorDocumentoService numeradorDocumentoService;

    @InjectMocks private SolicitudCompraServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
        lenient().when(articuloRefRepository.existsById(anyLong())).thenReturn(true);
        lenient().when(articuloRefRepository.findById(anyLong())).thenReturn(Optional.empty());
        lenient().when(usuarioRefRepository.existsById(anyLong())).thenReturn(true);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    // ── listar ──

    @Test
    @DisplayName("listar() sin filtros -> retorna página")
    @SuppressWarnings("unchecked")
    void listar_sinFiltros_retornaPagina() {
        SolicitudCompra sc = solicitudCompra(1L, "1");
        Page<SolicitudCompra> page = new PageImpl<>(List.of(sc));

        when(solicitudCompraRepository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(page);
        when(mapper.toResponse(any(SolicitudCompra.class)))
                .thenReturn(SolicitudCompraResponse.builder().id(1L).numero("SC-001").build());

        Page<SolicitudCompraResponse> result = service.listar(null, null, null, null, null, Pageable.unpaged());

        assertThat(result.getContent()).hasSize(1);
        assertThat(result.getContent().get(0).getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("listar() con todos los filtros -> retorna página")
    @SuppressWarnings("unchecked")
    void listar_conTodosLosFiltros_retornaPagina() {
        Page<SolicitudCompra> page = new PageImpl<>(List.of());
        when(solicitudCompraRepository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(page);

        Page<SolicitudCompraResponse> result = service.listar(
                1L, "1", "ALTA", null, null, Pageable.unpaged());

        assertThat(result.getContent()).isEmpty();
    }

    @Test
    @DisplayName("listar() solo sucursal -> filtra")
    @SuppressWarnings("unchecked")
    void listar_soloSucursal_filtra() {
        Page<SolicitudCompra> page = new PageImpl<>(List.of());
        when(solicitudCompraRepository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(page);

        service.listar(5L, null, null, null, null, Pageable.unpaged());

        verify(solicitudCompraRepository).findAll(any(Specification.class), any(Pageable.class));
    }

    @Test
    @DisplayName("listar() solo estado -> filtra")
    @SuppressWarnings("unchecked")
    void listar_soloEstado_filtra() {
        Page<SolicitudCompra> page = new PageImpl<>(List.of());
        when(solicitudCompraRepository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(page);

        service.listar(null, "BORRADOR", null, null, null, Pageable.unpaged());

        verify(solicitudCompraRepository).findAll(any(Specification.class), any(Pageable.class));
    }

    @Test
    @DisplayName("listar() estado blank -> ignora filtro")
    @SuppressWarnings("unchecked")
    void listar_estadoBlank_ignoraFiltro() {
        Page<SolicitudCompra> page = new PageImpl<>(List.of());
        when(solicitudCompraRepository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(page);

        service.listar(null, "  ", null, null, null, Pageable.unpaged());

        verify(solicitudCompraRepository).findAll(any(Specification.class), any(Pageable.class));
    }

    @Test
    @DisplayName("listar() prioridad blank -> ignora filtro")
    @SuppressWarnings("unchecked")
    void listar_prioridadBlank_ignoraFiltro() {
        Page<SolicitudCompra> page = new PageImpl<>(List.of());
        when(solicitudCompraRepository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(page);

        service.listar(null, null, "  ", null, null, Pageable.unpaged());

        verify(solicitudCompraRepository).findAll(any(Specification.class), any(Pageable.class));
    }

    // ── obtener ──

    @Test
    @DisplayName("obtener() existente -> retorna detalle")
    void obtener_existente_retornaDetalle() {
        SolicitudCompra sc = solicitudCompra(1L, "1");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(sc));

        SolicitudCompraDetalleResponse result = service.obtener(1L);

        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getNumero()).isEqualTo("SC-001");
    }

    @Test
    @DisplayName("obtener() no existente -> lanza excepción")
    void obtener_noExistente_lanzaExcepcion() {
        when(solicitudCompraRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtener(99L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    // ── crear ──

    @Test
    @DisplayName("crear() ok -> genera nro y guarda")
    void crear_ok_generaNroYGuarda() {
        when(numeradorDocumentoService.siguienteNroDocumento(anyString(), any(), anyInt()))
                .thenReturn("SC-001");

        SolicitudCompra saved = solicitudCompra(1L, "1");
        when(solicitudCompraRepository.save(any(SolicitudCompra.class))).thenReturn(saved);

        SolicitudCompraRequest req = solicitudCompraRequest();
        SolicitudCompraDetalleResponse result = service.crear(req);

        assertThat(result).isNotNull();
        assertThat(result.getNumero()).isEqualTo("SC-001");
        verify(numeradorDocumentoService).siguienteNroDocumento(eq("compras.solicitud_compra"), any(), anyInt());
        verify(solicitudCompraRepository).save(any(SolicitudCompra.class));
    }

    @Test
    @DisplayName("crear() estado inicial borrador")
    void crear_estadoInicialBorrador() {
        when(numeradorDocumentoService.siguienteNroDocumento(anyString(), any(), anyInt()))
                .thenReturn("SC-002");
        when(solicitudCompraRepository.save(any(SolicitudCompra.class))).thenAnswer(inv -> {
            SolicitudCompra captured = inv.getArgument(0);
            captured.setId(2L);
            return captured;
        });

        SolicitudCompraDetalleResponse result = service.crear(solicitudCompraRequest());

        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("crear() sin sucursal id -> usa tenant context")
    void crear_sinSucursalId_usaTenantContext() {
        TenantContext.setSucursalId(7L);
        when(numeradorDocumentoService.siguienteNroDocumento(anyString(), eq(7L), anyInt()))
                .thenReturn("SC-003");
        when(solicitudCompraRepository.save(any(SolicitudCompra.class))).thenAnswer(inv -> {
            SolicitudCompra c = inv.getArgument(0);
            c.setId(3L);
            return c;
        });

        SolicitudCompraRequest req = solicitudCompraRequest();
        req.setSucursalId(null);
        SolicitudCompraDetalleResponse result = service.crear(req);

        assertThat(result.getSucursalId()).isEqualTo(7L);
    }

    @Test
    @DisplayName("crear() sin solicitante id -> usa tenant context")
    void crear_sinSolicitanteId_usaTenantContext() {
        when(numeradorDocumentoService.siguienteNroDocumento(anyString(), any(), anyInt()))
                .thenReturn("SC-004");
        when(solicitudCompraRepository.save(any(SolicitudCompra.class))).thenAnswer(inv -> {
            SolicitudCompra c = inv.getArgument(0);
            c.setId(4L);
            return c;
        });

        SolicitudCompraRequest req = solicitudCompraRequest();
        req.setSolicitanteId(null);
        SolicitudCompraDetalleResponse result = service.crear(req);

        assertThat(result.getSolicitanteId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("crear() sin prioridad default media")
    void crear_sinPrioridad_defaultMedia() {
        when(numeradorDocumentoService.siguienteNroDocumento(anyString(), any(), anyInt()))
                .thenReturn("SC-005");
        when(solicitudCompraRepository.save(any(SolicitudCompra.class))).thenAnswer(inv -> {
            SolicitudCompra c = inv.getArgument(0);
            c.setId(5L);
            return c;
        });

        SolicitudCompraRequest req = solicitudCompraRequest();
        req.setPrioridad(null);
        SolicitudCompraDetalleResponse result = service.crear(req);

        assertThat(result.getPrioridad()).isEqualTo("MEDIA");
    }

    @Test
    @DisplayName("crear() líneas null -> lanza excepción")
    void crear_lineasNull_lanzaExcepcion() {
        SolicitudCompraRequest req = solicitudCompraRequest();
        req.setLineas(null);

        assertThatThrownBy(() -> service.crear(req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("línea de detalle");
    }

    @Test
    @DisplayName("crear() líneas vacias -> lanza excepción")
    void crear_lineasVacias_lanzaExcepcion() {
        SolicitudCompraRequest req = solicitudCompraRequest();
        req.setLineas(List.of());

        assertThatThrownBy(() -> service.crear(req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("línea de detalle");
    }

    @Test
    @DisplayName("crear() artículo no existe en core -> lanza excepción")
    void crear_articuloNoExisteEnCore_lanzaExcepcion() {
        when(articuloRefRepository.existsById(100L)).thenReturn(false);

        SolicitudCompraRequest req = solicitudCompraRequest();
        assertThatThrownBy(() -> service.crear(req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("No existe registro");
    }

    @Test
    @DisplayName("crear() solicitante no existe en security -> lanza excepción")
    void crear_solicitanteNoExisteEnSecurity_lanzaExcepcion() {
        when(usuarioRefRepository.existsById(999L)).thenReturn(false);

        SolicitudCompraRequest req = solicitudCompraRequest();
        req.setSolicitanteId(999L);
        assertThatThrownBy(() -> service.crear(req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("No existe registro");
    }

    @Test
    @DisplayName("crear() con multiples líneas todas se guardan")
    void crear_conMultiplesLineas_todasSeGuardan() {
        when(numeradorDocumentoService.siguienteNroDocumento(anyString(), any(), anyInt()))
                .thenReturn("SC-006");
        when(solicitudCompraRepository.save(any(SolicitudCompra.class))).thenAnswer(inv -> {
            SolicitudCompra c = inv.getArgument(0);
            c.setId(6L);
            return c;
        });

        SolicitudCompraRequest req = solicitudCompraRequest();
        SolicitudCompraDetRequest d2 = new SolicitudCompraDetRequest();
        d2.setArticuloId(200L);
        d2.setCantidad(new BigDecimal("5"));
        req.setLineas(List.of(req.getLineas().get(0), d2));

        SolicitudCompraDetalleResponse result = service.crear(req);

        assertThat(result).isNotNull();
        verify(solicitudCompraRepository).save(argThat(entity ->
                entity.getLineas().size() == 2));
    }

    // ── actualizar ──

    @Test
    @DisplayName("actualizar() borrador -> ok")
    void actualizar_borrador_ok() {
        SolicitudCompra existing = solicitudCompra(1L, "1");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(existing));
        when(solicitudCompraRepository.save(any(SolicitudCompra.class))).thenReturn(existing);

        SolicitudCompraDetalleResponse result = service.actualizar(1L, solicitudCompraRequest());

        assertThat(result).isNotNull();
        verify(solicitudCompraRepository).save(any(SolicitudCompra.class));
    }

    @Test
    @DisplayName("actualizar() rechazada ok -> vuelve a borrador")
    void actualizar_rechazada_ok_vuelveABorrador() {
        SolicitudCompra existing = solicitudCompra(1L, "0");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(existing));
        when(solicitudCompraRepository.save(any(SolicitudCompra.class))).thenAnswer(inv -> inv.getArgument(0));

        SolicitudCompraDetalleResponse result = service.actualizar(1L, solicitudCompraRequest());

        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("actualizar() enviada -> lanza excepción")
    void actualizar_enviada_lanzaExcepcion() {
        SolicitudCompra existing = solicitudCompra(1L, "2");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(existing));

        assertThatThrownBy(() -> service.actualizar(1L, solicitudCompraRequest()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("activa o rechazada");
    }

    @Test
    @DisplayName("actualizar() aprobada -> lanza excepción")
    void actualizar_aprobada_lanzaExcepcion() {
        SolicitudCompra existing = solicitudCompra(1L, "2");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(existing));

        assertThatThrownBy(() -> service.actualizar(1L, solicitudCompraRequest()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("activa o rechazada");
    }

    @Test
    @DisplayName("actualizar() no existe -> lanza excepción")
    void actualizar_noExiste_lanzaExcepcion() {
        when(solicitudCompraRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.actualizar(99L, solicitudCompraRequest()))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("actualizar() anulada -> lanza excepción")
    void actualizar_anulada_lanzaExcepcion() {
        SolicitudCompra existing = solicitudCompra(1L, "2");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(existing));

        assertThatThrownBy(() -> service.actualizar(1L, solicitudCompraRequest()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("activa o rechazada");
    }

    @Test
    @DisplayName("actualizar() sin sucursal id en request -> conserva existente")
    void actualizar_sinSucursalIdEnRequest_conservaExistente() {
        SolicitudCompra existing = solicitudCompra(1L, "1");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(existing));
        when(solicitudCompraRepository.save(any(SolicitudCompra.class))).thenAnswer(inv -> inv.getArgument(0));

        SolicitudCompraRequest req = solicitudCompraRequest();
        req.setSucursalId(null);
        SolicitudCompraDetalleResponse result = service.actualizar(1L, req);

        assertThat(result.getSucursalId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("actualizar() sin solicitante id en request -> conserva existente")
    void actualizar_sinSolicitanteIdEnRequest_conservaExistente() {
        SolicitudCompra existing = solicitudCompra(1L, "1");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(existing));
        when(solicitudCompraRepository.save(any(SolicitudCompra.class))).thenAnswer(inv -> inv.getArgument(0));

        SolicitudCompraRequest req = solicitudCompraRequest();
        req.setSolicitanteId(null);
        SolicitudCompraDetalleResponse result = service.actualizar(1L, req);

        assertThat(result.getSolicitanteId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("actualizar() sin prioridad en request -> conserva existente")
    void actualizar_sinPrioridadEnRequest_conservaExistente() {
        SolicitudCompra existing = solicitudCompra(1L, "1");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(existing));
        when(solicitudCompraRepository.save(any(SolicitudCompra.class))).thenAnswer(inv -> inv.getArgument(0));

        SolicitudCompraRequest req = solicitudCompraRequest();
        req.setPrioridad(null);
        SolicitudCompraDetalleResponse result = service.actualizar(1L, req);

        assertThat(result.getPrioridad()).isEqualTo("MEDIA");
    }

    @Test
    @DisplayName("actualizar() reemplaza líneas")
    void actualizar_reemplazaLineas() {
        SolicitudCompra existing = solicitudCompra(1L, "1");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(existing));
        when(solicitudCompraRepository.save(any(SolicitudCompra.class))).thenAnswer(inv -> inv.getArgument(0));

        SolicitudCompraRequest req = solicitudCompraRequest();
        SolicitudCompraDetRequest d2 = new SolicitudCompraDetRequest();
        d2.setArticuloId(200L);
        d2.setCantidad(new BigDecimal("5"));
        req.setLineas(List.of(req.getLineas().get(0), d2));

        service.actualizar(1L, req);

        verify(solicitudCompraRepository).save(argThat(entity ->
                entity.getLineas().size() == 2));
    }

    // ── enviar ──

    @Test
    @DisplayName("enviar() borrador -> ok")
    void enviar_borrador_ok() {
        SolicitudCompra sc = solicitudCompra(1L, "1");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(sc));
        when(solicitudCompraRepository.save(any(SolicitudCompra.class))).thenAnswer(inv -> inv.getArgument(0));

        SolicitudCompraDetalleResponse result = service.enviar(1L);

        assertThat(result).isNotNull();
        assertThat(sc.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("enviar() no es borrador -> lanza excepción")
    void enviar_noEsBorrador_lanzaExcepcion() {
        SolicitudCompra sc = solicitudCompra(1L, "0");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(sc));

        assertThatThrownBy(() -> service.enviar(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("activa");
    }

    @Test
    @DisplayName("enviar() sin líneas -> lanza excepción")
    void enviar_sinLineas_lanzaExcepcion() {
        SolicitudCompra sc = solicitudCompra(1L, "1");
        sc.getLineas().clear();
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(sc));

        assertThatThrownBy(() -> service.enviar(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("línea de detalle");
    }

    @Test
    @DisplayName("enviar() no existe -> lanza excepción")
    void enviar_noExiste_lanzaExcepcion() {
        when(solicitudCompraRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.enviar(99L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("enviar() asigna updated by")
    void enviar_asignaUpdatedBy() {
        SolicitudCompra sc = solicitudCompra(1L, "1");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(sc));
        when(solicitudCompraRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        service.enviar(1L);

        verify(solicitudCompraRepository).save(argThat(e -> {
            assertThat(e.getUpdatedBy()).isEqualTo(1L);
            return true;
        }));
    }

    // ── aprobar ──

    @Test
    @DisplayName("aprobar() enviada -> ok")
    void aprobar_enviada_ok() {
        SolicitudCompra sc = solicitudCompra(1L, "1");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(sc));
        when(solicitudCompraRepository.save(any(SolicitudCompra.class))).thenAnswer(inv -> inv.getArgument(0));

        SolicitudCompraDetalleResponse result = service.aprobar(1L, "Conforme");

        assertThat(result).isNotNull();
        assertThat(sc.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("aprobar() no es enviada -> lanza excepción")
    void aprobar_noEsEnviada_lanzaExcepcion() {
        SolicitudCompra sc = solicitudCompra(1L, "0");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(sc));

        assertThatThrownBy(() -> service.aprobar(1L, "OK"))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("activa");
    }

    @Test
    @DisplayName("aprobar() no existe -> lanza excepción")
    void aprobar_noExiste_lanzaExcepcion() {
        when(solicitudCompraRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.aprobar(99L, "OK"))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("aprobar() sin observacion -> ok")
    void aprobar_sinObservacion_ok() {
        SolicitudCompra sc = solicitudCompra(1L, "1");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(sc));
        when(solicitudCompraRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        SolicitudCompraDetalleResponse result = service.aprobar(1L, null);

        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    // ── rechazar ──

    @Test
    @DisplayName("rechazar() enviada con motivo -> ok")
    void rechazar_enviada_conMotivo_ok() {
        SolicitudCompra sc = solicitudCompra(1L, "1");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(sc));
        when(solicitudCompraRepository.save(any(SolicitudCompra.class))).thenAnswer(inv -> inv.getArgument(0));

        SolicitudCompraDetalleResponse result = service.rechazar(1L, "No cumple especificaciones");

        assertThat(result).isNotNull();
        assertThat(sc.getFlagEstado()).isEqualTo("0");
    }

    @Test
    @DisplayName("rechazar() sin motivo -> lanza excepción")
    void rechazar_sinMotivo_lanzaExcepcion() {
        SolicitudCompra sc = solicitudCompra(1L, "1");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(sc));

        assertThatThrownBy(() -> service.rechazar(1L, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("motivo");
    }

    @Test
    @DisplayName("rechazar() motivo vacio -> lanza excepción")
    void rechazar_motivoVacio_lanzaExcepcion() {
        SolicitudCompra sc = solicitudCompra(1L, "1");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(sc));

        assertThatThrownBy(() -> service.rechazar(1L, "   "))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("motivo");
    }

    @Test
    @DisplayName("rechazar() no es enviada -> lanza excepción")
    void rechazar_noEsEnviada_lanzaExcepcion() {
        SolicitudCompra sc = solicitudCompra(1L, "0");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(sc));

        assertThatThrownBy(() -> service.rechazar(1L, "motivo"))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("activa");
    }

    @Test
    @DisplayName("rechazar() no existe -> lanza excepción")
    void rechazar_noExiste_lanzaExcepcion() {
        when(solicitudCompraRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.rechazar(99L, "motivo"))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    // ── anular ──

    @Test
    @DisplayName("anular() borrador -> ok")
    void anular_borrador_ok() {
        SolicitudCompra sc = solicitudCompra(1L, "1");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(sc));
        when(solicitudCompraRepository.save(any(SolicitudCompra.class))).thenAnswer(inv -> inv.getArgument(0));

        SolicitudCompraDetalleResponse result = service.anular(1L, "Ya no se necesita");

        assertThat(result).isNotNull();
        assertThat(sc.getFlagEstado()).isEqualTo("0");
    }

    @Test
    @DisplayName("anular() enviada -> ok")
    void anular_enviada_ok() {
        SolicitudCompra sc = solicitudCompra(1L, "1");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(sc));
        when(solicitudCompraRepository.save(any(SolicitudCompra.class))).thenAnswer(inv -> inv.getArgument(0));

        SolicitudCompraDetalleResponse result = service.anular(1L, "Error en solicitud");

        assertThat(result).isNotNull();
        assertThat(sc.getFlagEstado()).isEqualTo("0");
    }

    @Test
    @DisplayName("anular() anulada -> lanza excepción")
    void anular_anulada_lanzaExcepcion() {
        SolicitudCompra sc = solicitudCompra(1L, "0");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(sc));

        assertThatThrownBy(() -> service.anular(1L, "motivo"))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("anulada");
    }

    @Test
    @DisplayName("anular() convertida -> lanza excepción")
    void anular_convertida_lanzaExcepcion() {
        SolicitudCompra sc = solicitudCompra(1L, "2");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(sc));

        assertThatThrownBy(() -> service.anular(1L, "motivo"))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("cerrada");
    }

    @Test
    @DisplayName("anular() sin motivo -> lanza excepción")
    void anular_sinMotivo_lanzaExcepcion() {
        SolicitudCompra sc = solicitudCompra(1L, "1");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(sc));

        assertThatThrownBy(() -> service.anular(1L, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("motivo");
    }

    @Test
    @DisplayName("anular() motivo vacio -> lanza excepción")
    void anular_motivoVacio_lanzaExcepcion() {
        SolicitudCompra sc = solicitudCompra(1L, "1");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(sc));

        assertThatThrownBy(() -> service.anular(1L, "  "))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("motivo");
    }

    @Test
    @DisplayName("anular() no existe -> lanza excepción")
    void anular_noExiste_lanzaExcepcion() {
        when(solicitudCompraRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.anular(99L, "motivo"))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("anular() aprobada -> ok")
    void anular_aprobada_ok() {
        SolicitudCompra sc = solicitudCompra(1L, "1");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(sc));
        when(solicitudCompraRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        SolicitudCompraDetalleResponse result = service.anular(1L, "Cancelar proceso");

        assertThat(result.getFlagEstado()).isEqualTo("0");
    }

    @Test
    @DisplayName("toDetalle() artículo ref no encontrado -> retorna nulls")
    void toDetalle_articuloRefNoEncontrado_retornaNulls() {
        when(numeradorDocumentoService.siguienteNroDocumento(anyString(), any(), anyInt()))
                .thenReturn("SC-007");
        when(solicitudCompraRepository.save(any(SolicitudCompra.class))).thenAnswer(inv -> {
            SolicitudCompra c = inv.getArgument(0);
            c.setId(7L);
            return c;
        });

        SolicitudCompraDetalleResponse result = service.crear(solicitudCompraRequest());

        assertThat(result.getLineas()).isNotEmpty();
        assertThat(result.getLineas().get(0).getArticuloCodigo()).isNull();
        assertThat(result.getLineas().get(0).getArticuloDescripcion()).isNull();
    }

    @Test
    @DisplayName("toDetalle() artículo ref encontrado -> retorna código")
    void toDetalle_articuloRefEncontrado_retornaCodigo() {
        com.sigre.compras.entity.ArticuloRef artRef = mock(com.sigre.compras.entity.ArticuloRef.class);
        when(artRef.getCodigo()).thenReturn("ART-100");
        when(artRef.getNombre()).thenReturn("Arroz");
        when(articuloRefRepository.findById(100L)).thenReturn(Optional.of(artRef));

        when(numeradorDocumentoService.siguienteNroDocumento(anyString(), any(), anyInt()))
                .thenReturn("SC-008");
        when(solicitudCompraRepository.save(any(SolicitudCompra.class))).thenAnswer(inv -> {
            SolicitudCompra c = inv.getArgument(0);
            c.setId(8L);
            return c;
        });

        SolicitudCompraDetalleResponse result = service.crear(solicitudCompraRequest());

        assertThat(result.getLineas()).isNotEmpty();
        assertThat(result.getLineas().get(0).getArticuloCodigo()).isEqualTo("ART-100");
        assertThat(result.getLineas().get(0).getArticuloDescripcion()).isEqualTo("Arroz");
    }

    @Test
    @DisplayName("validarExistenciaEnCore() id null -> no lanza")
    void validarExistenciaEnCore_idNull_noLanza() {
        when(numeradorDocumentoService.siguienteNroDocumento(anyString(), any(), anyInt()))
                .thenReturn("SC-009");
        when(solicitudCompraRepository.save(any())).thenAnswer(inv -> {
            SolicitudCompra c = inv.getArgument(0);
            c.setId(9L);
            return c;
        });

        SolicitudCompraRequest req = solicitudCompraRequest();
        req.setSolicitanteId(null);
        assertThatCode(() -> service.crear(req)).doesNotThrowAnyException();
    }

    // ── Tests convertir ──

    @Test
    @DisplayName("convertir() a cotización -> crea documentos y cambia estado")
    void convertir_aCotizacion_creaDocumentosYCambiaEstado() {
        SolicitudCompra sc = solicitudCompra(1L, "1");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(sc));

        com.sigre.compras.entity.Cotizacion savedCot = new com.sigre.compras.entity.Cotizacion();
        savedCot.setId(50L);
        when(cotizacionRepository.save(any())).thenReturn(savedCot);
        when(solicitudCompraRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        ConvertirSolicitudRequest request = ConvertirSolicitudRequest.builder()
                .destino("COTIZACION")
                .proveedorIds(List.of(10L, 20L))
                .monedaId(1L)
                .build();

        ConvertirSolicitudResponse result = service.convertir(1L, request);

        assertThat(result.getSolicitudId()).isEqualTo(1L);
        assertThat(result.getDestino()).isEqualTo("COTIZACION");
        assertThat(result.getDocumentosGenerados()).hasSize(2);
        assertThat(sc.getFlagEstado()).isEqualTo("2");
    }

    @Test
    @DisplayName("convertir() a orden compra -> crea documentos y cambia estado")
    void convertir_aOrdenCompra_creaDocumentosYCambiaEstado() {
        SolicitudCompra sc = solicitudCompra(1L, "1");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(sc));

        com.sigre.compras.entity.OrdenCompra savedOc = new com.sigre.compras.entity.OrdenCompra();
        savedOc.setId(60L);
        when(ordenCompraRepository.save(any())).thenReturn(savedOc);
        when(solicitudCompraRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        when(numeradorDocumentoService.siguienteNroDocumentoIndependiente(anyString(), any(), anyInt()))
                .thenReturn("OC-001");

        ConvertirSolicitudRequest request = ConvertirSolicitudRequest.builder()
                .destino("ORDEN_COMPRA")
                .proveedorIds(List.of(10L))
                .monedaId(1L)
                .build();

        ConvertirSolicitudResponse result = service.convertir(1L, request);

        assertThat(result.getDestino()).isEqualTo("ORDEN_COMPRA");
        assertThat(result.getDocumentosGenerados()).hasSize(1);
    }

    @Test
    @DisplayName("convertir() destino inválido -> lanza excepción")
    void convertir_destinoInvalido_lanzaExcepcion() {
        SolicitudCompra sc = solicitudCompra(1L, "1");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(sc));

        ConvertirSolicitudRequest request = ConvertirSolicitudRequest.builder()
                .destino("INVALIDO")
                .proveedorIds(List.of(10L))
                .monedaId(1L)
                .build();

        assertThatThrownBy(() -> service.convertir(1L, request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Destino no válido");
    }

    @Test
    @DisplayName("convertir() solicitud inactiva -> lanza excepción")
    void convertir_solicitudInactiva_lanzaExcepcion() {
        SolicitudCompra sc = solicitudCompra(1L, "0");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(sc));

        ConvertirSolicitudRequest request = ConvertirSolicitudRequest.builder()
                .destino("COTIZACION")
                .proveedorIds(List.of(10L))
                .monedaId(1L)
                .build();

        assertThatThrownBy(() -> service.convertir(1L, request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("solicitud activa");
    }

    @Test
    @DisplayName("convertir() no existe -> lanza excepción")
    void convertir_noExiste_lanzaExcepcion() {
        when(solicitudCompraRepository.findById(99L)).thenReturn(Optional.empty());

        ConvertirSolicitudRequest request = ConvertirSolicitudRequest.builder()
                .destino("COTIZACION")
                .proveedorIds(List.of(10L))
                .build();

        assertThatThrownBy(() -> service.convertir(99L, request))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    // ── Tests trazabilidad ──

    @Test
    @DisplayName("trazabilidad() con ordenes relacionadas -> retorna lista")
    void trazabilidad_conOrdenesRelacionadas_retornaLista() {
        SolicitudCompra sc = solicitudCompra(1L, "1");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(sc));

        com.sigre.compras.entity.OrdenCompra oc = new com.sigre.compras.entity.OrdenCompra();
        oc.setId(5L);
        oc.setNroOrdenCompra("OC-005");
        oc.setFechaEmision(java.time.LocalDate.now());
        oc.setFlagEstado("1");
        when(ordenCompraRepository.findBySolicitudCompraIdViaDetalle(1L)).thenReturn(List.of(oc));

        List<TrazabilidadDocumentoResponse> result = service.trazabilidad(1L);

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getTipoDocumento()).isEqualTo("ORDEN_COMPRA");
        assertThat(result.get(0).getDocumentoId()).isEqualTo(5L);
        assertThat(result.get(0).getNumero()).isEqualTo("OC-005");
    }

    @Test
    @DisplayName("trazabilidad() sin ordenes relacionadas -> retorna lista vacia")
    void trazabilidad_sinOrdenesRelacionadas_retornaListaVacia() {
        SolicitudCompra sc = solicitudCompra(1L, "1");
        when(solicitudCompraRepository.findById(1L)).thenReturn(Optional.of(sc));
        when(ordenCompraRepository.findBySolicitudCompraIdViaDetalle(1L)).thenReturn(List.of());

        List<TrazabilidadDocumentoResponse> result = service.trazabilidad(1L);

        assertThat(result).isEmpty();
    }

    @Test
    @DisplayName("trazabilidad() solicitud no existe -> lanza excepción")
    void trazabilidad_solicitudNoExiste_lanzaExcepcion() {
        when(solicitudCompraRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.trazabilidad(99L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

}
