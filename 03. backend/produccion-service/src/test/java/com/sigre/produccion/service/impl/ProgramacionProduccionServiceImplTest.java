package com.sigre.produccion.service.impl;

import jakarta.persistence.EntityManager;
import jakarta.persistence.Query;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.test.util.ReflectionTestUtils;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.produccion.ProduccionTestFixtures;
import com.sigre.produccion.client.CoreSucursalClient;
import com.sigre.produccion.client.dto.SucursalResponse;
import com.sigre.produccion.entity.ProgramacionProduccion;
import com.sigre.produccion.repository.ProgramacionProduccionRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

import jakarta.persistence.criteria.*;
import org.mockito.ArgumentCaptor;

@ExtendWith(MockitoExtension.class)
@DisplayName("ProgramacionProduccionServiceImpl — Pruebas Unitarias")
class ProgramacionProduccionServiceImplTest {

    @Mock private ProgramacionProduccionRepository repository;
    @Mock private CoreSucursalClient coreSucursalClient;
    @Mock private EntityManager entityManager;
    @Mock private Query query;

    private ProgramacionProduccionServiceImpl service;
    private ProgramacionProduccion entity;

    @BeforeEach
    void setUp() {
        service = new ProgramacionProduccionServiceImpl(repository, coreSucursalClient);
        ReflectionTestUtils.setField(service, "entityManager", entityManager);
        entity = ProduccionTestFixtures.programacionProduccion(1L, "1");

        var okResp = mock(com.sigre.common.dto.ApiResponse.class);
        lenient().when(okResp.isSuccess()).thenReturn(true);
        lenient().when(okResp.getData()).thenReturn(new SucursalResponse(1L, "Sucursal Test", "1"));
        lenient().when(coreSucursalClient.obtenerPorId(anyLong())).thenReturn(okResp);

        lenient().when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        lenient().when(query.setParameter(anyString(), any())).thenReturn(query);
        lenient().when(query.getSingleResult()).thenReturn(1);
    }

    @Test
    @DisplayName("findAll() sin filtros -> retorna pagina")
    @SuppressWarnings("unchecked")
    void findAll_sinFiltros_retornaPagina() {
        Pageable pageable = PageRequest.of(0, 20);
        when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(new PageImpl<>(List.of(entity)));

        Page<ProgramacionProduccion> result = service.findAll(null, null, null, null, null, null, pageable);

        assertThat(result.getContent()).hasSize(1);
    }

    @Test
    @DisplayName("findById() con ID existente -> retorna entidad")
    void findById_cuandoExisteId_retornaEntidad() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        ProgramacionProduccion result = service.findById(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("findById() con ID inexistente -> lanza ResourceNotFoundException")
    void findById_cuandoIdNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.findById(999L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("create() con datos validos -> guarda y retorna")
    void create_conDatosValidos_guardaYRetorna() {
        when(repository.save(any(ProgramacionProduccion.class))).thenAnswer(i -> i.getArgument(0));

        ProgramacionProduccion result = service.create(entity);

        assertThat(result).isNotNull();
        verify(repository).save(any(ProgramacionProduccion.class));
    }

    @Test
    @DisplayName("create() con frecuencia invalida -> lanza BusinessException")
    void create_cuandoFrecuenciaInvalida_lanzaBusinessException() {
        entity.setFrecuencia("INVALIDA");

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Frecuencia");
    }

    @Test
    @DisplayName("create() sin receta valida -> lanza BusinessException")
    void create_cuandoRecetaInvalida_lanzaBusinessException() {
        when(query.getSingleResult()).thenReturn(0);

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("receta");
    }

    @Test
    @DisplayName("update() con datos validos -> actualiza y retorna")
    void update_conDatosValidos_actualizaYRetorna() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any(ProgramacionProduccion.class))).thenAnswer(i -> i.getArgument(0));

        entity.setFrecuencia("SEMANAL");
        ProgramacionProduccion result = service.update(1L, entity);

        assertThat(result.getFrecuencia()).isEqualTo("SEMANAL");
    }

    @Test
    @DisplayName("update() con receta invalida -> lanza BusinessException")
    void update_cuandoRecetaInvalida_lanzaBusinessException() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(query.getSingleResult()).thenReturn(0);

        assertThatThrownBy(() -> service.update(1L, entity))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("receta");
    }

    @Test
    @DisplayName("activate() -> cambia flagEstado a 1")
    void activate_cambiaFlagEstado() {
        ProgramacionProduccion inactive = ProduccionTestFixtures.programacionProduccion(1L, "0");
        when(repository.findById(1L)).thenReturn(Optional.of(inactive));
        when(repository.save(any(ProgramacionProduccion.class))).thenAnswer(i -> i.getArgument(0));

        ProgramacionProduccion result = service.activate(1L);

        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("deactivate() -> cambia flagEstado a 0")
    void deactivate_cambiaFlagEstado() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any(ProgramacionProduccion.class))).thenAnswer(i -> i.getArgument(0));

        ProgramacionProduccion result = service.deactivate(1L);

        assertThat(result.getFlagEstado()).isEqualTo("0");
    }

    // ==================== enrichResponses ====================

    @Test
    void enrichResponses_cuandoNull_noHaceNada() {
        service.enrichResponses(null);
        verifyNoInteractions(entityManager);
    }

    @Test
    void enrichResponses_cuandoListaVacia_noHaceNada() {
        service.enrichResponses(List.of());
        verifyNoInteractions(entityManager);
    }

    @Test
    void enrichResponses_conDatosValidos_enriquece() {
        var resp = com.sigre.produccion.dto.response.ProgramacionProduccionResponse.builder()
                .id(1L).recetaId(10L).build();
        when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        @SuppressWarnings("rawtypes")
        List rows = List.of((Object) new Object[]{10L, "REC-001", "Receta 1"});
        lenient().when(query.getResultList()).thenReturn(rows);

        service.enrichResponses(List.of(resp));
    }

    // ==================== create edge cases ====================

    @Test
    void create_conOrdenTrabajoIdYValido_validaYGuarda() {
        entity.setOrdenTrabajoId(1L);
        when(repository.save(any(ProgramacionProduccion.class))).thenAnswer(i -> i.getArgument(0));

        var result = service.create(entity);

        assertThat(result).isNotNull();
    }

    @Test
    void create_conSucursalIdYValida_validaYGuarda() {
        entity.setSucursalId(1L);
        when(repository.save(any(ProgramacionProduccion.class))).thenAnswer(i -> i.getArgument(0));

        var result = service.create(entity);

        assertThat(result).isNotNull();
    }

    @Test
    void create_sinFlagEstado_asignaActivo() {
        entity.setFlagEstado(null);
        when(repository.save(any(ProgramacionProduccion.class))).thenAnswer(i -> i.getArgument(0));

        var result = service.create(entity);

        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void create_conFlagEstadoBlank_asignaActivo() {
        entity.setFlagEstado("");
        when(repository.save(any(ProgramacionProduccion.class))).thenAnswer(i -> i.getArgument(0));

        var result = service.create(entity);

        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void create_cuandoFechaFinAntesFechaInicio_lanzaBusinessException() {
        entity.setFechaInicio(java.time.LocalDate.of(2025, 6, 15));
        entity.setFechaFin(java.time.LocalDate.of(2025, 6, 10));

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("fecha fin");
    }

    @Test
    void update_cuandoFechaFinAntesFechaInicio_lanzaBusinessException() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        entity.setFechaInicio(java.time.LocalDate.of(2025, 6, 15));
        entity.setFechaFin(java.time.LocalDate.of(2025, 6, 10));

        assertThatThrownBy(() -> service.update(1L, entity))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("fecha fin");
    }

    // ==================== validarOT / validarSucursal failure ====================

    @Test
    void create_cuandoOTInvalida_lanzaBusinessException() {
        entity.setOrdenTrabajoId(999L);
        reset(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(1, 0);

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("orden de trabajo");
    }

    @Test
    void create_cuandoSucursalInexistente_lanzaBusinessException() {
        entity.setSucursalId(999L);
        var failResp = mock(com.sigre.common.dto.ApiResponse.class);
        when(failResp.isSuccess()).thenReturn(false);
        when(coreSucursalClient.obtenerPorId(999L)).thenReturn(failResp);

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("sucursal");
    }

    @Test
    void create_cuandoSucursalInactiva_lanzaBusinessException() {
        entity.setSucursalId(1L);
        var inactiveResp = mock(com.sigre.common.dto.ApiResponse.class);
        when(inactiveResp.isSuccess()).thenReturn(true);
        when(inactiveResp.getData()).thenReturn(new SucursalResponse(1L, "", "0"));
        when(coreSucursalClient.obtenerPorId(1L)).thenReturn(inactiveResp);

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("sucursal");
    }

    @Test
    void create_cuandoSucursalFeignFalla_lanzaBusinessException() {
        entity.setSucursalId(1L);
        when(coreSucursalClient.obtenerPorId(1L)).thenThrow(mock(feign.FeignException.class));

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("sucursal");
    }

    @Test
    void create_conFrecuenciaBlank_pasaValidacion() {
        entity.setFrecuencia("  ");
        when(repository.save(any(ProgramacionProduccion.class))).thenAnswer(i -> i.getArgument(0));

        var result = service.create(entity);

        assertThat(result).isNotNull();
    }

    // ==================== update failure ====================

    @Test
    void update_cuandoSucursalInvalida_lanzaBusinessException() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        entity.setSucursalId(999L);
        var failResp = mock(com.sigre.common.dto.ApiResponse.class);
        when(failResp.isSuccess()).thenReturn(false);
        when(coreSucursalClient.obtenerPorId(999L)).thenReturn(failResp);

        assertThatThrownBy(() -> service.update(1L, entity))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("sucursal");
    }

    @Test
    void delete_desactivaEntidad() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any(ProgramacionProduccion.class))).thenReturn(entity);

        service.delete(1L);

        assertThat(entity.getFlagEstado()).isEqualTo("0");
        verify(repository).save(entity);
    }

    @Test
    void update_conOTid_validaOT() {
        entity.setOrdenTrabajoId(1L);
        entity.setSucursalId(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any(ProgramacionProduccion.class))).thenAnswer(i -> i.getArgument(0));

        ProgramacionProduccion result = service.update(1L, entity);

        assertThat(result).isNotNull();
        assertThat(result.getFrecuencia()).isEqualTo(entity.getFrecuencia());
    }

    // ─── Tests de Specification (ejecutan toPredicate) ───

    @Test
    @SuppressWarnings({"rawtypes", "unchecked"})
    void spec_conTodosLosFiltros_ejecutaToPredicate() {
        var pageable = PageRequest.of(0, 10);
        lenient().when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(Page.empty());

        service.findAll(1L, 1L, "DIARIA",
                LocalDate.of(2026, 1, 1), LocalDate.of(2026, 12, 31), "1", pageable);

        ArgumentCaptor<Specification<ProgramacionProduccion>> cap =
                ArgumentCaptor.forClass(Specification.class);
        verify(repository).findAll(cap.capture(), eq(pageable));

        Root root = mock(Root.class);
        CriteriaQuery query = mock(CriteriaQuery.class);
        CriteriaBuilder cb = mock(CriteriaBuilder.class);
        Path path = mock(Path.class);
        Expression upper = mock(Expression.class);
        Predicate predicate = mock(Predicate.class);
        when(root.get(anyString())).thenReturn(path);
        when(cb.upper(any())).thenReturn(upper);
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
        var pageable = PageRequest.of(0, 10);
        lenient().when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(Page.empty());

        service.findAll(null, null, null, null, null, null, pageable);

        ArgumentCaptor<Specification<ProgramacionProduccion>> cap =
                ArgumentCaptor.forClass(Specification.class);
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
    void spec_conFrecuenciaBlank_ejecutaToPredicate() {
        var pageable = PageRequest.of(0, 10);
        lenient().when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(Page.empty());

        service.findAll(1L, 1L, "", null, null, "1", pageable);

        ArgumentCaptor<Specification<ProgramacionProduccion>> cap =
                ArgumentCaptor.forClass(Specification.class);
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
