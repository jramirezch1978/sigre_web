package com.sigre.produccion.service.impl;

import feign.FeignException;
import jakarta.persistence.EntityManager;
import jakarta.persistence.Query;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.common.exception.BusinessException;
import com.sigre.produccion.ProduccionTestFixtures;
import com.sigre.produccion.client.AuthUsuarioClient;
import com.sigre.produccion.entity.ControlCalidad;
import com.sigre.produccion.repository.ControlCalidadRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.test.util.ReflectionTestUtils;

import com.sigre.produccion.dto.response.ControlCalidadResponse;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

import jakarta.persistence.criteria.*;
import org.mockito.ArgumentCaptor;

@ExtendWith(MockitoExtension.class)
@DisplayName("ControlCalidadServiceImpl — Pruebas Unitarias")
class ControlCalidadServiceImplTest {

    @Mock private ControlCalidadRepository repository;
    @Mock private AuthUsuarioClient authUsuarioClient;
    @Mock private EntityManager entityManager;
    @Mock private Query query;
    private ControlCalidadServiceImpl service;

    private ControlCalidad entity;

    @BeforeEach
    void setUp() {
        service = new ControlCalidadServiceImpl(repository, authUsuarioClient);
        ReflectionTestUtils.setField(service, "entityManager", entityManager);
        entity = ProduccionTestFixtures.controlCalidad(1L);
        var usuarioResponse = mock(com.sigre.common.dto.ApiResponse.class);
        lenient().when(usuarioResponse.isSuccess()).thenReturn(true);
        lenient().when(usuarioResponse.getData()).thenReturn(mock(Object.class));
        lenient().when(authUsuarioClient.obtenerPorId(anyLong())).thenReturn(usuarioResponse);
        lenient().when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        lenient().when(query.setParameter(anyString(), any())).thenReturn(query);
        lenient().when(query.getSingleResult()).thenReturn(1);
    }

    @Test
    @DisplayName("findById() con ID existente -> retorna entidad")
    void findById_cuandoExisteId_retornaEntidad() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        ControlCalidad result = service.findById(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("findById() con ID inexistente -> lanza BusinessException")
    void findById_cuandoIdNoExiste_lanzaBusinessException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.findById(999L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Control de calidad");
    }

    @Test
    @DisplayName("create() con datos validos -> guarda y retorna")
    void create_conDatosValidos_guardaYRetorna() {
        when(repository.save(any(ControlCalidad.class))).thenReturn(entity);

        ControlCalidad result = service.create(entity);

        assertThat(result).isNotNull();
        assertThat(result.getResultado()).isEqualTo("APROBADO");
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("create() con resultado invalido -> lanza BusinessException")
    void create_cuandoResultadoInvalido_lanzaBusinessException() {
        entity.setResultado("INVALIDO");

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(BusinessException.class);
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("create() sin fecha -> lanza BusinessException")
    void create_cuandoFechaNula_lanzaBusinessException() {
        entity.setFecha(null);

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(BusinessException.class);
    }

    @Test
    @DisplayName("create() sin resultado -> lanza BusinessException")
    void create_cuandoResultadoNulo_lanzaBusinessException() {
        entity.setResultado(null);

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(BusinessException.class);
    }

    @Test
    @DisplayName("update() con datos validos -> actualiza y retorna")
    void update_conDatosValidos_actualizaYRetorna() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any(ControlCalidad.class))).thenReturn(entity);

        entity.setResultado("RECHAZADO");
        ControlCalidad result = service.update(1L, entity);

        assertThat(result.getResultado()).isEqualTo("RECHAZADO");
    }

    @Test
    void findAll_conFiltros_retornaPage() {
        var pageable = org.springframework.data.domain.PageRequest.of(0, 10);
        when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class), eq(pageable)))
                .thenReturn(new org.springframework.data.domain.PageImpl<>(List.of(entity)));

        var result = service.findAll(1L, "APROBADO", null, null, 1L, pageable);

        assertThat(result).hasSize(1);
    }

    @Test
    void findAll_sinFiltros_retornaPage() {
        var pageable = org.springframework.data.domain.PageRequest.of(0, 10);
        when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class), eq(pageable)))
                .thenReturn(org.springframework.data.domain.Page.empty());

        var result = service.findAll(null, null, null, null, null, pageable);

        assertThat(result).isEmpty();
    }

    @Test
    void delete_elimina() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        doNothing().when(repository).delete(entity);

        service.delete(1L);

        verify(repository).delete(entity);
    }

    @Test
    void enrich_cuandoNull_noHaceNada() {
        service.enrich(null);
        verifyNoInteractions(entityManager);
    }

    @Test
    void enrich_cuandoListaVacia_noHaceNada() {
        service.enrich(java.util.List.of());
        verifyNoInteractions(entityManager);
    }

    @Test
    void enrich_sinIds_noConsulta() {
        var resp = com.sigre.produccion.dto.response.ControlCalidadResponse.builder().id(1L).build();
        service.enrich(java.util.List.of(resp));
        verifyNoInteractions(entityManager);
    }

    @Test
    void enrich_conOrdenTrabajoId_enriquece() {
        var resp = com.sigre.produccion.dto.response.ControlCalidadResponse.builder()
                .id(1L).ordenTrabajoId(10L).build();
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        @SuppressWarnings("rawtypes")
        java.util.List rows = java.util.List.of((Object) new Object[]{10L, "OT-001"});
        lenient().when(query.getResultList()).thenReturn(rows);

        service.enrich(java.util.List.of(resp));

        assertThat(resp.getOrdenTrabajoCodigo()).isEqualTo("OT-001");
    }

    @Test
    void create_cuandoOTInexistente_lanzaBusinessException() {
        entity.setOrdenTrabajoId(999L);
        reset(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(0);

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("orden de trabajo");
    }

    @Test
    void create_cuandoInspectorInexistente_lanzaBusinessException() {
        entity.setInspectorId(999L);
        var failResp = mock(com.sigre.common.dto.ApiResponse.class);
        lenient().when(failResp.isSuccess()).thenReturn(false);
        when(authUsuarioClient.obtenerPorId(999L)).thenReturn(failResp);

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("inspector");
    }

    @Test
    void create_cuandoInspectorFeignFalla_lanzaBusinessException() {
        entity.setInspectorId(1L);
        when(authUsuarioClient.obtenerPorId(1L)).thenThrow(mock(FeignException.class));

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("inspector");
    }

    @Test
    void create_cuandoRespuestaInspectorDataNull_lanzaBusinessException() {
        entity.setInspectorId(999L);
        var failResp = mock(com.sigre.common.dto.ApiResponse.class);
        when(failResp.isSuccess()).thenReturn(true);
        when(failResp.getData()).thenReturn(null);
        when(authUsuarioClient.obtenerPorId(999L)).thenReturn(failResp);

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("inspector");
    }

    @Test
    void create_cuandoResultadoBlanco_lanzaBusinessException() {
        entity.setResultado("");
        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("obligatorios");
    }

    @Test
    void update_conOTnula_noValidaFK() {
        entity.setOrdenTrabajoId(null);
        entity.setInspectorId(null);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any(ControlCalidad.class))).thenReturn(entity);

        ControlCalidad result = service.update(1L, entity);

        assertThat(result).isNotNull();
    }

    @Test
    void enrich_conAmbosIds_enriquece() {
        var resp = ControlCalidadResponse.builder()
                .id(1L).ordenTrabajoId(10L).inspectorId(20L).build();
        var otRows = List.of((Object) new Object[]{10L, "OT-001"});
        var usrRows = List.of((Object) new Object[]{20L, "Juan Perez"});
        when(entityManager.createNativeQuery(contains("orden_trabajo")))
                .thenReturn(query);
        when(entityManager.createNativeQuery(contains("auth.usuario")))
                .thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getResultList())
                .thenReturn(otRows)
                .thenReturn(usrRows);

        service.enrich(List.of(resp));

        assertThat(resp.getOrdenTrabajoCodigo()).isEqualTo("OT-001");
        assertThat(resp.getInspectorNombre()).isEqualTo("Juan Perez");
    }

    @Test
    void enrich_conExcepcionEnConsultaOT_noLanzaError() {
        var resp = ControlCalidadResponse.builder()
                .id(1L).ordenTrabajoId(10L).build();
        when(entityManager.createNativeQuery(anyString()))
                .thenThrow(new RuntimeException("Error BD"));

        service.enrich(List.of(resp));

        assertThat(resp.getOrdenTrabajoCodigo()).isNull();
    }

    @Test
    void findAll_conFechaDesde_retornaPage() {
        var pageable = org.springframework.data.domain.PageRequest.of(0, 10);
        when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class), eq(pageable)))
                .thenReturn(new org.springframework.data.domain.PageImpl<>(List.of(entity)));

        var result = service.findAll(null, null, LocalDate.of(2026, 1, 1), null, null, pageable);

        assertThat(result).hasSize(1);
    }

    @Test
    void findAll_conFechaHasta_retornaPage() {
        var pageable = org.springframework.data.domain.PageRequest.of(0, 10);
        when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class), eq(pageable)))
                .thenReturn(new org.springframework.data.domain.PageImpl<>(List.of(entity)));

        var result = service.findAll(null, null, null, LocalDate.of(2026, 12, 31), null, pageable);

        assertThat(result).hasSize(1);
    }

    @Test
    void findAll_conResultadoBlanco_noAgregaPredicate() {
        var pageable = org.springframework.data.domain.PageRequest.of(0, 10);
        when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class), eq(pageable)))
                .thenReturn(org.springframework.data.domain.Page.empty());

        var result = service.findAll(null, "", null, null, null, pageable);

        assertThat(result).isEmpty();
    }

    // ─── Tests de Specification (ejecutan toPredicate) ───

    @Test
    @SuppressWarnings({"rawtypes", "unchecked"})
    void spec_conTodosLosFiltros_ejecutaToPredicate() {
        var pageable = org.springframework.data.domain.PageRequest.of(0, 10);
        lenient().when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class), eq(pageable)))
                .thenReturn(org.springframework.data.domain.Page.empty());

        service.findAll(1L, "APROBADO", LocalDate.of(2026, 1, 1), LocalDate.of(2026, 12, 31), 5L, pageable);

        ArgumentCaptor<org.springframework.data.jpa.domain.Specification<ControlCalidad>> cap =
                ArgumentCaptor.forClass(org.springframework.data.jpa.domain.Specification.class);
        verify(repository).findAll(cap.capture(), eq(pageable));

        Root root = mock(Root.class);
        CriteriaQuery query = mock(CriteriaQuery.class);
        CriteriaBuilder cb = mock(CriteriaBuilder.class);
        Path path = mock(Path.class);
        Predicate predicate = mock(Predicate.class);
        when(root.get(anyString())).thenReturn(path);
        lenient().when(cb.equal(any(Expression.class), any())).thenReturn(predicate);
        when(cb.greaterThanOrEqualTo(any(Expression.class), any(LocalDate.class))).thenReturn(predicate);
        when(cb.lessThanOrEqualTo(any(Expression.class), any(LocalDate.class))).thenReturn(predicate);
        when(cb.and(any(Predicate[].class))).thenReturn(predicate);

        Predicate result = cap.getValue().toPredicate(root, query, cb);

        assertThat(result).isNotNull();
    }

    @Test
    @SuppressWarnings({"rawtypes", "unchecked"})
    void spec_sinFiltros_ejecutaToPredicate() {
        var pageable = org.springframework.data.domain.PageRequest.of(0, 10);
        lenient().when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class), eq(pageable)))
                .thenReturn(org.springframework.data.domain.Page.empty());

        service.findAll(null, null, null, null, null, pageable);

        ArgumentCaptor<org.springframework.data.jpa.domain.Specification<ControlCalidad>> cap =
                ArgumentCaptor.forClass(org.springframework.data.jpa.domain.Specification.class);
        verify(repository).findAll(cap.capture(), eq(pageable));

        Root root = mock(Root.class);
        CriteriaQuery query = mock(CriteriaQuery.class);
        CriteriaBuilder cb = mock(CriteriaBuilder.class);
        Predicate predicate = mock(Predicate.class);
        when(cb.and(any(Predicate[].class))).thenReturn(predicate);

        Predicate result = cap.getValue().toPredicate(root, query, cb);

        assertThat(result).isNotNull();
    }

    @Test
    @SuppressWarnings({"rawtypes", "unchecked"})
    void spec_conResultadoBlanco_ejecutaToPredicate() {
        var pageable = org.springframework.data.domain.PageRequest.of(0, 10);
        lenient().when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class), eq(pageable)))
                .thenReturn(org.springframework.data.domain.Page.empty());

        service.findAll(1L, "", null, null, 5L, pageable);

        ArgumentCaptor<org.springframework.data.jpa.domain.Specification<ControlCalidad>> cap =
                ArgumentCaptor.forClass(org.springframework.data.jpa.domain.Specification.class);
        verify(repository).findAll(cap.capture(), eq(pageable));

        Root root = mock(Root.class);
        CriteriaQuery query = mock(CriteriaQuery.class);
        CriteriaBuilder cb = mock(CriteriaBuilder.class);
        Path path = mock(Path.class);
        Predicate predicate = mock(Predicate.class);
        when(root.get(anyString())).thenReturn(path);
        lenient().when(cb.equal(any(Expression.class), any())).thenReturn(predicate);
        when(cb.and(any(Predicate[].class))).thenReturn(predicate);

        Predicate result = cap.getValue().toPredicate(root, query, cb);

        assertThat(result).isNotNull();
    }

    @Test
    @SuppressWarnings({"rawtypes", "unchecked"})
    void spec_conSoloFechaDesde_ejecutaToPredicate() {
        var pageable = org.springframework.data.domain.PageRequest.of(0, 10);
        lenient().when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class), eq(pageable)))
                .thenReturn(org.springframework.data.domain.Page.empty());

        service.findAll(null, null, LocalDate.of(2026, 6, 1), null, null, pageable);

        ArgumentCaptor<org.springframework.data.jpa.domain.Specification<ControlCalidad>> cap =
                ArgumentCaptor.forClass(org.springframework.data.jpa.domain.Specification.class);
        verify(repository).findAll(cap.capture(), eq(pageable));

        Root root = mock(Root.class);
        CriteriaQuery query = mock(CriteriaQuery.class);
        CriteriaBuilder cb = mock(CriteriaBuilder.class);
        Path path = mock(Path.class);
        Predicate predicate = mock(Predicate.class);
        when(root.get(anyString())).thenReturn(path);
        when(cb.greaterThanOrEqualTo(any(Expression.class), any(LocalDate.class))).thenReturn(predicate);
        when(cb.and(any(Predicate[].class))).thenReturn(predicate);

        Predicate result = cap.getValue().toPredicate(root, query, cb);

        assertThat(result).isNotNull();
    }

    @Test
    @SuppressWarnings({"rawtypes", "unchecked"})
    void spec_conSoloInspectorId_ejecutaToPredicate() {
        var pageable = org.springframework.data.domain.PageRequest.of(0, 10);
        lenient().when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class), eq(pageable)))
                .thenReturn(org.springframework.data.domain.Page.empty());

        service.findAll(null, null, null, null, 5L, pageable);

        ArgumentCaptor<org.springframework.data.jpa.domain.Specification<ControlCalidad>> cap =
                ArgumentCaptor.forClass(org.springframework.data.jpa.domain.Specification.class);
        verify(repository).findAll(cap.capture(), eq(pageable));

        Root root = mock(Root.class);
        CriteriaQuery query = mock(CriteriaQuery.class);
        CriteriaBuilder cb = mock(CriteriaBuilder.class);
        Path path = mock(Path.class);
        Predicate predicate = mock(Predicate.class);
        when(root.get(anyString())).thenReturn(path);
        lenient().when(cb.equal(any(Expression.class), any())).thenReturn(predicate);
        when(cb.and(any(Predicate[].class))).thenReturn(predicate);

        Predicate result = cap.getValue().toPredicate(root, query, cb);

        assertThat(result).isNotNull();
    }
}
