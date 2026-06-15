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
import com.sigre.compras.dto.ContratoMarcoRequest;
import com.sigre.compras.dto.ContratoMarcoResponse;
import com.sigre.compras.entity.ContratoMarco;
import com.sigre.compras.mapper.ContratoMarcoMapper;
import com.sigre.compras.repository.ContratoMarcoRepository;
import com.sigre.compras.repository.EntidadContribuyenteRefRepository;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.common.service.NumeradorDocumentoService;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static com.sigre.compras.ComprasTestFixtures.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ContratoMarcoServiceImpl — Pruebas Unitarias")
class ContratoMarcoServiceImplTest {

    @Mock private ContratoMarcoRepository contratoMarcoRepository;
    @Mock private ContratoMarcoMapper contratoMarcoMapper;
    @Mock private EntidadContribuyenteRefRepository entidadContribuyenteRefRepository;
    @Mock private NumeradorDocumentoService numeradorDocumentoService;
    @Mock private com.sigre.compras.repository.OrdenCompraRepository ordenCompraRepository;

    @InjectMocks private ContratoMarcoServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
        TenantContext.setSucursalId(1L);
        lenient().when(entidadContribuyenteRefRepository.findById(anyLong())).thenReturn(Optional.empty());
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
        ContratoMarco cm = contratoMarco(1L, "1");
        Page<ContratoMarco> page = new PageImpl<>(List.of(cm));
        when(contratoMarcoRepository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(page);

        Page<ContratoMarcoResponse> result = service.listar(null, null, null, Pageable.unpaged());

        assertThat(result.getContent()).hasSize(1);
        assertThat(result.getContent().get(0).getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("listar() con proveedor id -> filtra")
    @SuppressWarnings("unchecked")
    void listar_conProveedorId_filtra() {
        Page<ContratoMarco> page = new PageImpl<>(List.of());
        when(contratoMarcoRepository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(page);

        service.listar(10L, null, null, Pageable.unpaged());

        verify(contratoMarcoRepository).findAll(any(Specification.class), any(Pageable.class));
    }

    @Test
    @DisplayName("listar() con estado -> filtra")
    @SuppressWarnings("unchecked")
    void listar_conEstado_filtra() {
        Page<ContratoMarco> page = new PageImpl<>(List.of());
        when(contratoMarcoRepository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(page);

        service.listar(null, "VIGENTE", null, Pageable.unpaged());

        verify(contratoMarcoRepository).findAll(any(Specification.class), any(Pageable.class));
    }

    @Test
    @DisplayName("listar() estado blank -> ignora filtro")
    @SuppressWarnings("unchecked")
    void listar_estadoBlank_ignoraFiltro() {
        Page<ContratoMarco> page = new PageImpl<>(List.of());
        when(contratoMarcoRepository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(page);

        service.listar(null, "  ", null, Pageable.unpaged());

        verify(contratoMarcoRepository).findAll(any(Specification.class), any(Pageable.class));
    }

    // ── obtener ──

    @Test
    @DisplayName("obtener() existente -> retorna response")
    void obtener_existente_retornaResponse() {
        ContratoMarco cm = contratoMarco(1L, "1");
        when(contratoMarcoRepository.findById(1L)).thenReturn(Optional.of(cm));

        ContratoMarcoResponse result = service.obtener(1L);

        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getNumero()).isEqualTo("CM-001");
    }

    @Test
    @DisplayName("obtener() no existente -> lanza excepción")
    void obtener_noExistente_lanzaExcepcion() {
        when(contratoMarcoRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtener(99L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    // ── crear ──

    @Test
    @DisplayName("crear() ok establece vigente y genera número")
    void crear_ok_estableceVigenteYGeneraNumero() {
        mockProveedorActivo(10L);
        when(contratoMarcoMapper.toEntity(any())).thenReturn(new ContratoMarco());
        when(numeradorDocumentoService.siguienteNroDocumento(anyString(), any(), anyInt()))
                .thenReturn("CM-001");

        ContratoMarco saved = contratoMarco(1L, "1");
        when(contratoMarcoRepository.save(any(ContratoMarco.class))).thenReturn(saved);

        ContratoMarcoRequest request = contratoMarcoRequest();
        ContratoMarcoResponse result = service.crear(request);

        assertThat(result).isNotNull();
        assertThat(result.getFlagEstado()).isEqualTo("1");
        assertThat(result.getNumero()).isEqualTo("CM-001");
        verify(numeradorDocumentoService).siguienteNroDocumento(eq("compras.contrato_marco"), eq(1L), anyInt());
        verify(contratoMarcoRepository).save(any(ContratoMarco.class));
    }

    @Test
    @DisplayName("crear() proveedor no existe -> lanza excepción")
    void crear_proveedorNoExiste_lanzaExcepcion() {
        assertThatThrownBy(() -> service.crear(contratoMarcoRequest()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Proveedor");
    }

    @Test
    @DisplayName("crear() proveedor count null -> lanza excepción")
    void crear_proveedorCountNull_lanzaExcepcion() {
        assertThatThrownBy(() -> service.crear(contratoMarcoRequest()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Proveedor");
    }

    // ── actualizar ──

    @Test
    @DisplayName("actualizar() vigente -> ok")
    void actualizar_vigente_ok() {
        ContratoMarco cm = contratoMarco(1L, "1");
        when(contratoMarcoRepository.findById(1L)).thenReturn(Optional.of(cm));
        mockProveedorActivo(10L);
        when(contratoMarcoRepository.save(any(ContratoMarco.class))).thenReturn(cm);

        ContratoMarcoResponse result = service.actualizar(1L, contratoMarcoRequest());

        assertThat(result).isNotNull();
        verify(contratoMarcoMapper).updateEntity(any(ContratoMarcoRequest.class), eq(cm));
        verify(contratoMarcoRepository).save(cm);
    }

    @Test
    @DisplayName("actualizar() no vigente -> lanza excepción")
    void actualizar_noVigente_lanzaExcepcion() {
        ContratoMarco cm = contratoMarco(1L, "0");
        when(contratoMarcoRepository.findById(1L)).thenReturn(Optional.of(cm));

        assertThatThrownBy(() -> service.actualizar(1L, contratoMarcoRequest()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("activo");
    }

    @Test
    @DisplayName("actualizar() no existe -> lanza excepción")
    void actualizar_noExiste_lanzaExcepcion() {
        when(contratoMarcoRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.actualizar(99L, contratoMarcoRequest()))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("actualizar() proveedor no existe -> lanza excepción")
    void actualizar_proveedorNoExiste_lanzaExcepcion() {
        ContratoMarco cm = contratoMarco(1L, "1");
        when(contratoMarcoRepository.findById(1L)).thenReturn(Optional.of(cm));

        assertThatThrownBy(() -> service.actualizar(1L, contratoMarcoRequest()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Proveedor");
    }

    // ── suspender ──

    @Test
    @DisplayName("suspender() vigente -> ok")
    void suspender_vigente_ok() {
        ContratoMarco cm = contratoMarco(1L, "1");
        when(contratoMarcoRepository.findById(1L)).thenReturn(Optional.of(cm));
        when(contratoMarcoRepository.save(any(ContratoMarco.class))).thenReturn(cm);

        ContratoMarcoResponse result = service.suspender(1L, null);

        assertThat(result).isNotNull();
        assertThat(cm.getFlagEstado()).isEqualTo("0");
    }

    @Test
    @DisplayName("suspender() no vigente -> lanza excepción")
    void suspender_noVigente_lanzaExcepcion() {
        ContratoMarco cm = contratoMarco(1L, "2");
        when(contratoMarcoRepository.findById(1L)).thenReturn(Optional.of(cm));

        assertThatThrownBy(() -> service.suspender(1L, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("activo");
    }

    @Test
    @DisplayName("suspender() no existe -> lanza excepción")
    void suspender_noExiste_lanzaExcepcion() {
        when(contratoMarcoRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.suspender(99L, null))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    // ── reabrir ──

    @Test
    @DisplayName("reabrir() suspendido -> ok")
    void reabrir_suspendido_ok() {
        ContratoMarco cm = contratoMarco(1L, "0");
        when(contratoMarcoRepository.findById(1L)).thenReturn(Optional.of(cm));
        when(contratoMarcoRepository.save(any(ContratoMarco.class))).thenReturn(cm);

        ContratoMarcoResponse result = service.reabrir(1L, null);

        assertThat(result).isNotNull();
        assertThat(cm.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("reabrir() no suspendido -> lanza excepción")
    void reabrir_noSuspendido_lanzaExcepcion() {
        ContratoMarco cm = contratoMarco(1L, "1");
        when(contratoMarcoRepository.findById(1L)).thenReturn(Optional.of(cm));

        assertThatThrownBy(() -> service.reabrir(1L, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("suspendido");
    }

    @Test
    @DisplayName("reabrir() no existe -> lanza excepción")
    void reabrir_noExiste_lanzaExcepcion() {
        when(contratoMarcoRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.reabrir(99L, null))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    // ── cerrar ──

    @Test
    @DisplayName("cerrar() vigente -> ok")
    void cerrar_vigente_ok() {
        ContratoMarco cm = contratoMarco(1L, "1");
        when(contratoMarcoRepository.findById(1L)).thenReturn(Optional.of(cm));
        when(contratoMarcoRepository.save(any(ContratoMarco.class))).thenReturn(cm);

        ContratoMarcoResponse result = service.cerrar(1L, null);

        assertThat(result).isNotNull();
        assertThat(cm.getFlagEstado()).isEqualTo("2");
    }

    @Test
    @DisplayName("cerrar() suspendido -> lanza excepción")
    void cerrar_suspendido_lanzaExcepcion() {
        ContratoMarco cm = contratoMarco(1L, "0");
        when(contratoMarcoRepository.findById(1L)).thenReturn(Optional.of(cm));

        assertThatThrownBy(() -> service.cerrar(1L, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("anulado");
    }

    @Test
    @DisplayName("cerrar() anulado -> lanza excepción")
    void cerrar_anulado_lanzaExcepcion() {
        ContratoMarco cm = contratoMarco(1L, "0");
        when(contratoMarcoRepository.findById(1L)).thenReturn(Optional.of(cm));

        assertThatThrownBy(() -> service.cerrar(1L, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("anulado");
    }

    @Test
    @DisplayName("cerrar() cerrado -> lanza excepción")
    void cerrar_cerrado_lanzaExcepcion() {
        ContratoMarco cm = contratoMarco(1L, "2");
        when(contratoMarcoRepository.findById(1L)).thenReturn(Optional.of(cm));

        assertThatThrownBy(() -> service.cerrar(1L, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("cerrado");
    }

    @Test
    @DisplayName("cerrar() no existe -> lanza excepción")
    void cerrar_noExiste_lanzaExcepcion() {
        when(contratoMarcoRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.cerrar(99L, null))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    // ── anular ──

    @Test
    @DisplayName("anular() vigente -> ok")
    void anular_vigente_ok() {
        ContratoMarco cm = contratoMarco(1L, "1");
        when(contratoMarcoRepository.findById(1L)).thenReturn(Optional.of(cm));
        when(contratoMarcoRepository.save(any(ContratoMarco.class))).thenReturn(cm);

        ContratoMarcoResponse result = service.anular(1L, null);

        assertThat(result).isNotNull();
        assertThat(cm.getFlagEstado()).isEqualTo("0");
    }

    @Test
    @DisplayName("anular() ya anulado -> lanza excepción")
    void anular_yaAnulado_lanzaExcepcion() {
        ContratoMarco cm = contratoMarco(1L, "0");
        when(contratoMarcoRepository.findById(1L)).thenReturn(Optional.of(cm));

        assertThatThrownBy(() -> service.anular(1L, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("anulado");
    }

    @Test
    @DisplayName("anular() no existe -> lanza excepción")
    void anular_noExiste_lanzaExcepcion() {
        when(contratoMarcoRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.anular(99L, null))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("anular() suspendido -> lanza excepción")
    void anular_suspendido_lanzaExcepcion() {
        ContratoMarco cm = contratoMarco(1L, "0");
        when(contratoMarcoRepository.findById(1L)).thenReturn(Optional.of(cm));

        assertThatThrownBy(() -> service.anular(1L, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("anulado");
    }

    @Test
    @DisplayName("anular() cerrado -> ok")
    void anular_cerrado_ok() {
        ContratoMarco cm = contratoMarco(1L, "2");
        when(contratoMarcoRepository.findById(1L)).thenReturn(Optional.of(cm));
        when(contratoMarcoRepository.save(any())).thenReturn(cm);

        service.anular(1L, null);

        assertThat(cm.getFlagEstado()).isEqualTo("0");
    }

    // ── ocGeneradas ──

    @Test
    @DisplayName("ocGeneradas() con resultados -> retorna lista")
    @SuppressWarnings("unchecked")
    void ocGeneradas_conResultados_retornaLista() {
        ContratoMarco cm = contratoMarco(1L, "1");
        when(contratoMarcoRepository.findById(1L)).thenReturn(Optional.of(cm));

        com.sigre.compras.entity.OrdenCompra oc = new com.sigre.compras.entity.OrdenCompra();
        oc.setId(100L);
        oc.setNroOrdenCompra("OC-001");
        oc.setFechaEmision(LocalDate.now());
        oc.setTotal(new java.math.BigDecimal("5000"));
        oc.setFlagEstado("1");

        when(ordenCompraRepository.findAll(any(Specification.class)))
                .thenReturn(List.of(oc));

        var result = service.ocGeneradas(1L);

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getNroOrdenCompra()).isEqualTo("OC-001");
    }

    @Test
    @DisplayName("ocGeneradas() sin resultados -> retorna lista vacia")
    @SuppressWarnings("unchecked")
    void ocGeneradas_sinResultados_retornaListaVacia() {
        ContratoMarco cm = contratoMarco(1L, "1");
        when(contratoMarcoRepository.findById(1L)).thenReturn(Optional.of(cm));
        when(ordenCompraRepository.findAll(any(Specification.class)))
                .thenReturn(List.of());

        var result = service.ocGeneradas(1L);

        assertThat(result).isEmpty();
    }

    @Test
    @DisplayName("ocGeneradas() no existe -> lanza excepción")
    void ocGeneradas_noExiste_lanzaExcepcion() {
        when(contratoMarcoRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.ocGeneradas(99L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("toResponse() con proveedor -> retorna datos")
    void toResponse_conProveedor_retornaDatos() {
        com.sigre.compras.entity.EntidadContribuyenteRef prov = mock(com.sigre.compras.entity.EntidadContribuyenteRef.class);
        when(prov.getNombreCompleto()).thenReturn("Proveedor S.A.");
        when(prov.getNroDocumento()).thenReturn("20123456789");
        when(entidadContribuyenteRefRepository.findById(10L)).thenReturn(Optional.of(prov));

        ContratoMarco cm = contratoMarco(1L, "1");
        when(contratoMarcoRepository.findById(1L)).thenReturn(Optional.of(cm));

        ContratoMarcoResponse result = service.obtener(1L);

        assertThat(result.getProveedorRazonSocial()).isEqualTo("Proveedor S.A.");
        assertThat(result.getProveedorRuc()).isEqualTo("20123456789");
    }

    @Test
    @DisplayName("toResponse() sin proveedor id -> retorna nulls")
    void toResponse_sinProveedorId_retornaNulls() {
        ContratoMarco cm = contratoMarco(1L, "1");
        cm.setProveedorId(null);
        when(contratoMarcoRepository.findById(1L)).thenReturn(Optional.of(cm));

        ContratoMarcoResponse result = service.obtener(1L);

        assertThat(result.getProveedorRazonSocial()).isNull();
        assertThat(result.getProveedorRuc()).isNull();
    }

    // ── Helpers ──

    private void mockProveedorActivo(Long proveedorId) {
        com.sigre.compras.entity.EntidadContribuyenteRef prov = mock(com.sigre.compras.entity.EntidadContribuyenteRef.class);
        when(prov.getFlagEstado()).thenReturn("1");
        when(entidadContribuyenteRefRepository.findById(proveedorId)).thenReturn(Optional.of(prov));
    }
}
