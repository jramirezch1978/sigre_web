package pe.restaurant.rrhh.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.rrhh.RrhhTestFixtures;
import pe.restaurant.rrhh.dto.request.NovedadRrhhCreateRequest;
import pe.restaurant.rrhh.dto.request.NovedadRrhhDetRequest;
import pe.restaurant.rrhh.dto.request.NovedadRrhhUpdateRequest;
import pe.restaurant.rrhh.dto.response.NovedadRrhhDetResponse;
import pe.restaurant.rrhh.dto.response.NovedadRrhhResponse;
import pe.restaurant.rrhh.entity.NovedadRrhh;
import pe.restaurant.rrhh.entity.NovedadRrhhDet;
import pe.restaurant.rrhh.mapper.NovedadRrhhDetMapper;
import pe.restaurant.rrhh.mapper.NovedadRrhhMapper;
import pe.restaurant.rrhh.repository.NovedadRrhhDetRepository;
import pe.restaurant.rrhh.repository.NovedadRrhhRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("NovedadRrhhServiceImpl — Pruebas Unitarias")
class NovedadRrhhServiceImplTest {

    @Mock private NovedadRrhhRepository repository;
    @Mock private NovedadRrhhDetRepository detRepository;
    @Mock private NovedadRrhhMapper mapper;
    @Mock private NovedadRrhhDetMapper detMapper;

    @InjectMocks
    private NovedadRrhhServiceImpl service;

    @Captor
    private ArgumentCaptor<NovedadRrhh> entityCaptor;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
    }

    // ═══════════════════════════════════════════════════
    // listar()
    // ═══════════════════════════════════════════════════

    @Test
    @DisplayName("listar() sin filtros -> retorna página")
    void listar_sinFiltros_retornaPagina() {
        Pageable pageable = Pageable.ofSize(10);
        List<NovedadRrhh> entities = List.of(RrhhTestFixtures.novedadRrhh(1L));
        Page<NovedadRrhh> page = new PageImpl<>(entities);

        when(repository.findAll(any(Specification.class), any(Pageable.class))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(RrhhTestFixtures.novedadRrhhResponse(1L));

        Page<NovedadRrhhResponse> result = service.listar(null, null, null, null, null, pageable);

        assertThat(result.getContent()).hasSize(1);
        verify(repository).findAll(any(Specification.class), any(Pageable.class));
    }

    @Test
    @DisplayName("listar() con filtros -> invoca especificación")
    void listar_conFiltros_invocaEspecificacion() {
        Pageable pageable = Pageable.ofSize(10);
        when(repository.findAll(any(Specification.class), any(Pageable.class)))
            .thenReturn(new PageImpl<>(List.of()));

        service.listar(1L, 2L, LocalDate.of(2026, 1, 1), LocalDate.of(2026, 1, 31), "1", pageable);

        verify(repository).findAll(any(Specification.class), any(Pageable.class));
    }

    // ═══════════════════════════════════════════════════
    // obtenerPorId()
    // ═══════════════════════════════════════════════════

    @Test
    @DisplayName("obtenerPorId() con ID existente -> retorna DTO")
    void obtenerPorId_idExistente_retornaDTO() {
        NovedadRrhh entity = RrhhTestFixtures.novedadRrhh(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(mapper.toResponse(entity)).thenReturn(RrhhTestFixtures.novedadRrhhResponse(1L));

        NovedadRrhhResponse result = service.obtenerPorId(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(repository).findById(1L);
    }

    @Test
    @DisplayName("obtenerPorId() con ID inexistente -> lanza ResourceNotFoundException")
    void obtenerPorId_idInexistente_lanzaResourceNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtenerPorId(999L))
            .isInstanceOf(ResourceNotFoundException.class);
        verify(repository).findById(999L);
    }

    // ═══════════════════════════════════════════════════
    // crear()
    // ═══════════════════════════════════════════════════

    @Test
    @DisplayName("crear() -> convierte request, setea auditoría, guarda y retorna DTO")
    void crear_convierteYGuarda() {
        NovedadRrhhCreateRequest request = RrhhTestFixtures.novedadRrhhCreateRequest();
        NovedadRrhh entity = RrhhTestFixtures.novedadRrhh(null);
        NovedadRrhh saved = RrhhTestFixtures.novedadRrhh(1L);

        when(mapper.toEntity(request)).thenReturn(entity);
        when(repository.save(entity)).thenReturn(saved);
        when(mapper.toResponse(saved)).thenReturn(RrhhTestFixtures.novedadRrhhResponse(1L));

        NovedadRrhhResponse result = service.crear(request);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(mapper).toEntity(request);
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("crear() -> setea createdBy y fecCreacion")
    void crear_seteaAuditoria() {
        NovedadRrhhCreateRequest request = RrhhTestFixtures.novedadRrhhCreateRequest();
        NovedadRrhh entity = new NovedadRrhh();
        NovedadRrhh saved = RrhhTestFixtures.novedadRrhh(1L);

        when(mapper.toEntity(request)).thenReturn(entity);
        when(repository.save(entity)).thenReturn(saved);
        when(mapper.toResponse(saved)).thenReturn(RrhhTestFixtures.novedadRrhhResponse(1L));

        service.crear(request);

        verify(repository).save(entityCaptor.capture());
        NovedadRrhh captured = entityCaptor.getValue();
        assertThat(captured.getCreatedBy()).isEqualTo(1L);
        assertThat(captured.getFecCreacion()).isNotNull();
    }

    // ═══════════════════════════════════════════════════
    // actualizar()
    // ═══════════════════════════════════════════════════

    @Test
    @DisplayName("actualizar() -> actualiza y retorna DTO")
    void actualizar_actualizaYRetornaDTO() {
        NovedadRrhhUpdateRequest request = RrhhTestFixtures.novedadRrhhUpdateRequest();
        NovedadRrhh existing = RrhhTestFixtures.novedadRrhh(1L);
        NovedadRrhh updated = RrhhTestFixtures.novedadRrhh(1L);

        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.save(existing)).thenReturn(updated);
        when(mapper.toResponse(updated)).thenReturn(RrhhTestFixtures.novedadRrhhResponse(1L));

        NovedadRrhhResponse result = service.actualizar(1L, request);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(mapper).updateEntity(existing, request);
        verify(repository).save(existing);
    }

    @Test
    @DisplayName("actualizar() -> setea updatedBy y fecModificacion")
    void actualizar_seteaAuditoria() {
        NovedadRrhhUpdateRequest request = RrhhTestFixtures.novedadRrhhUpdateRequest();
        NovedadRrhh existing = RrhhTestFixtures.novedadRrhh(1L);

        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.save(existing)).thenReturn(existing);
        when(mapper.toResponse(existing)).thenReturn(RrhhTestFixtures.novedadRrhhResponse(1L));

        service.actualizar(1L, request);

        verify(repository).save(entityCaptor.capture());
        NovedadRrhh captured = entityCaptor.getValue();
        assertThat(captured.getUpdatedBy()).isEqualTo(1L);
        assertThat(captured.getFecModificacion()).isNotNull();
    }

    @Test
    @DisplayName("actualizar() con ID inexistente -> lanza ResourceNotFoundException")
    void actualizar_idInexistente_lanzaResourceNotFoundException() {
        NovedadRrhhUpdateRequest request = RrhhTestFixtures.novedadRrhhUpdateRequest();
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.actualizar(999L, request))
            .isInstanceOf(ResourceNotFoundException.class);
        verify(repository, never()).save(any());
    }

    // ═══════════════════════════════════════════════════
    // desactivar()
    // ═══════════════════════════════════════════════════

    @Test
    @DisplayName("desactivar() -> pone flagEstado=0 y guarda")
    void desactivar_cambiaEstado() {
        NovedadRrhh existing = RrhhTestFixtures.novedadRrhh(1L, "1");
        when(repository.findById(1L)).thenReturn(Optional.of(existing));

        service.desactivar(1L);

        assertThat(existing.getFlagEstado()).isEqualTo("0");
        verify(repository).save(existing);
    }

    @Test
    @DisplayName("desactivar() con ID inexistente -> lanza ResourceNotFoundException")
    void desactivar_idInexistente_lanzaResourceNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.desactivar(999L))
            .isInstanceOf(ResourceNotFoundException.class);
        verify(repository, never()).save(any());
    }

    // ═══════════════════════════════════════════════════
    // listarDetalles()
    // ═══════════════════════════════════════════════════

    @Test
    @DisplayName("listarDetalles() -> retorna lista de DTOs")
    void listarDetalles_retornaLista() {
        List<NovedadRrhhDet> dets = List.of(RrhhTestFixtures.novedadRrhhDet(1L));
        when(detRepository.findByNovedadRrhhId(1L)).thenReturn(dets);
        when(detMapper.toResponse(any())).thenReturn(RrhhTestFixtures.novedadRrhhDetResponse(1L));

        List<NovedadRrhhDetResponse> result = service.listarDetalles(1L);

        assertThat(result).hasSize(1);
        verify(detRepository).findByNovedadRrhhId(1L);
    }

    // ═══════════════════════════════════════════════════
    // crearDetalle()
    // ═══════════════════════════════════════════════════

    @Test
    @DisplayName("crearDetalle() -> valida existencia de novedad, crea detalle y retorna DTO")
    void crearDetalle_validaYCrea() {
        NovedadRrhhDetRequest request = new NovedadRrhhDetRequest();
        request.setFechaProceso(LocalDate.of(2026, 3, 1));
        request.setMontoPlanilla(new java.math.BigDecimal("500.0000"));
        NovedadRrhhDet det = RrhhTestFixtures.novedadRrhhDet(null);
        NovedadRrhhDet saved = RrhhTestFixtures.novedadRrhhDet(1L);

        when(repository.findById(1L)).thenReturn(Optional.of(RrhhTestFixtures.novedadRrhh(1L)));
        when(detMapper.toEntity(request)).thenReturn(det);
        when(detRepository.save(det)).thenReturn(saved);
        when(detMapper.toResponse(saved)).thenReturn(RrhhTestFixtures.novedadRrhhDetResponse(1L));

        NovedadRrhhDetResponse result = service.crearDetalle(1L, request);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(det.getNovedadRrhhId()).isEqualTo(1L);
        verify(detRepository).save(det);
    }

    @Test
    @DisplayName("crearDetalle() con novedad inexistente -> lanza ResourceNotFoundException")
    void crearDetalle_novedadInexistente_lanzaError() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.crearDetalle(999L, new NovedadRrhhDetRequest()))
            .isInstanceOf(ResourceNotFoundException.class);
        verify(detRepository, never()).save(any());
    }

    // ═══════════════════════════════════════════════════
    // eliminarDetalle()
    // ═══════════════════════════════════════════════════

    @Test
    @DisplayName("eliminarDetalle() -> elimina detalle existente")
    void eliminarDetalle_elimina() {
        NovedadRrhhDet det = RrhhTestFixtures.novedadRrhhDet(1L);
        when(detRepository.findById(1L)).thenReturn(Optional.of(det));

        service.eliminarDetalle(1L, 1L);

        verify(detRepository).delete(det);
    }

    @Test
    @DisplayName("eliminarDetalle() con ID inexistente -> lanza ResourceNotFoundException")
    void eliminarDetalle_idInexistente_lanzaError() {
        when(detRepository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.eliminarDetalle(1L, 999L))
            .isInstanceOf(pe.restaurant.common.exception.ResourceNotFoundException.class);
        verify(detRepository, never()).delete(any());
    }

    @Test
    @DisplayName("eliminarDetalle() con detalle de otra novedad -> lanza BusinessException")
    void eliminarDetalle_detalleDeOtraNovedad_lanzaError() {
        NovedadRrhhDet det = RrhhTestFixtures.novedadRrhhDet(1L);
        det.setNovedadRrhhId(99L);
        when(detRepository.findById(1L)).thenReturn(Optional.of(det));

        assertThatThrownBy(() -> service.eliminarDetalle(1L, 1L))
            .isInstanceOf(pe.restaurant.common.exception.BusinessException.class)
            .hasMessageContaining("no pertenece a la novedad");
        verify(detRepository, never()).delete(any());
    }
}
