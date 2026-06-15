package com.sigre.produccion.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.jpa.domain.Specification;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.produccion.ProduccionTestFixtures;
import com.sigre.produccion.entity.OtTipo;
import com.sigre.produccion.repository.OtTipoRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import jakarta.persistence.criteria.*;
import org.mockito.ArgumentCaptor;

@ExtendWith(MockitoExtension.class)
@DisplayName("OtTipoServiceImpl — Pruebas Unitarias")
class OtTipoServiceImplTest {

    @Mock private OtTipoRepository repository;
    @InjectMocks private OtTipoServiceImpl service;

    private OtTipo entity;

    @BeforeEach
    void setUp() {
        entity = ProduccionTestFixtures.otTipo(1L, "1");
    }

    @Test
    void findById_cuandoExisteId_retornaEntidad() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        OtTipo result = service.findById(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getFlagEstado()).isEqualTo("1");
        verify(repository).findById(1L);
    }

    @Test
    void findById_cuandoIdNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.findById(999L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("999");
        verify(repository).findById(999L);
    }

    @Test
    void findAll_conFiltros_retornaPage() {
        var pageable = PageRequest.of(0, 10);
        when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(new PageImpl<>(List.of(entity)));

        Page<OtTipo> result = service.findAll("COD", "Nombre", "1", pageable);

        assertThat(result).hasSize(1);
    }

    @Test
    void findAll_sinFiltros_retornaPage() {
        var pageable = PageRequest.of(0, 10);
        when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(Page.empty());

        Page<OtTipo> result = service.findAll(null, null, null, pageable);

        assertThat(result).isEmpty();
    }

    @Test
    void create_cuandoCodigoUnico_guardaYRetorna() {
        when(repository.existsByCodigoIgnoreCase(entity.getCodigo())).thenReturn(false);
        when(repository.save(any(OtTipo.class))).thenReturn(entity);

        OtTipo result = service.create(entity);

        assertThat(result).isNotNull();
        assertThat(result.getCodigo()).isEqualTo(entity.getCodigo());
        verify(repository).save(any(OtTipo.class));
    }

    @Test
    void create_cuandoCodigoDuplicado_lanzaBusinessException() {
        when(repository.existsByCodigoIgnoreCase(entity.getCodigo())).thenReturn(true);

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe");
        verify(repository, never()).save(any());
    }

    @Test
    void update_conDatosValidos_actualizaYRetorna() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.existsByCodigoIgnoreCaseAndIdNot(entity.getCodigo(), 1L)).thenReturn(false);
        when(repository.save(any(OtTipo.class))).thenAnswer(i -> i.getArgument(0));

        entity.setNombre("Actualizado");
        OtTipo result = service.update(1L, entity);

        assertThat(result.getNombre()).isEqualTo("Actualizado");
        verify(repository).save(any(OtTipo.class));
    }

    @Test
    void update_cuandoCodigoDuplicado_lanzaBusinessException() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.existsByCodigoIgnoreCaseAndIdNot(entity.getCodigo(), 1L)).thenReturn(true);

        assertThatThrownBy(() -> service.update(1L, entity))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe");
        verify(repository, never()).save(any());
    }

    @Test
    void activate_cambiaFlagEstado() {
        entity.setFlagEstado("0");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any(OtTipo.class))).thenReturn(entity);

        OtTipo result = service.activate(1L);

        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void deactivate_cambiaFlagEstado() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any(OtTipo.class))).thenReturn(entity);

        OtTipo result = service.deactivate(1L);

        assertThat(result.getFlagEstado()).isEqualTo("0");
    }

    @Test
    void delete_cuandoTieneOTsAsociadas_lanzaBusinessException() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.existsOrdenTrabajoByOtTipoId(1L)).thenReturn(true);

        assertThatThrownBy(() -> service.delete(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("ordenes de trabajo");
    }

    @Test
    void delete_cuandoSinOTsAsociadas_desactiva() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.existsOrdenTrabajoByOtTipoId(1L)).thenReturn(false);
        when(repository.save(any(OtTipo.class))).thenReturn(entity);

        service.delete(1L);

        assertThat(entity.getFlagEstado()).isEqualTo("0");
        verify(repository).save(entity);
    }

    @Test
    void create_cuandoFlagEstadoNulo_asignaUno() {
        entity.setFlagEstado(null);
        when(repository.existsByCodigoIgnoreCase(entity.getCodigo())).thenReturn(false);
        when(repository.save(any(OtTipo.class))).thenReturn(entity);

        OtTipo result = service.create(entity);

        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void normalizar_cuandoCodigoNulo_noFalla() {
        entity.setCodigo(null);
        entity.setNombre(null);
        when(repository.existsByCodigoIgnoreCase(any())).thenReturn(false);
        when(repository.save(any(OtTipo.class))).thenReturn(entity);

        service.create(entity);

        verify(repository).save(any(OtTipo.class));
    }

    @Test
    void normalizar_cuandoNombreNulo_noFalla() {
        entity.setNombre(null);
        when(repository.existsByCodigoIgnoreCase(entity.getCodigo())).thenReturn(false);
        when(repository.save(any(OtTipo.class))).thenReturn(entity);

        service.create(entity);

        verify(repository).save(any(OtTipo.class));
    }

    @Test
    void findAll_conCodigoBlanco_noAgregaPredicate() {
        var pageable = PageRequest.of(0, 10);
        when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(Page.empty());

        Page<OtTipo> result = service.findAll("", null, null, pageable);

        assertThat(result).isEmpty();
    }

    @Test
    void findAll_conNombreBlanco_noAgregaPredicate() {
        var pageable = PageRequest.of(0, 10);
        when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(Page.empty());

        Page<OtTipo> result = service.findAll(null, "", null, pageable);

        assertThat(result).isEmpty();
    }

    @Test
    void findAll_conFlagEstadoBlanco_noAgregaPredicate() {
        var pageable = PageRequest.of(0, 10);
        when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(Page.empty());

        Page<OtTipo> result = service.findAll(null, null, "", pageable);

        assertThat(result).isEmpty();
    }

    // ─── Tests de Specification (ejecutan toPredicate) ───

    @Test
    @SuppressWarnings({"rawtypes", "unchecked"})
    void spec_conTodosLosFiltros_ejecutaToPredicate() {
        var pageable = PageRequest.of(0, 10);
        lenient().when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(Page.empty());

        service.findAll("COD", "Nombre", "1", pageable);

        ArgumentCaptor<Specification<OtTipo>> cap = ArgumentCaptor.forClass(Specification.class);
        verify(repository).findAll(cap.capture(), eq(pageable));

        Root root = mock(Root.class);
        CriteriaQuery query = mock(CriteriaQuery.class);
        CriteriaBuilder cb = mock(CriteriaBuilder.class);
        Path path = mock(Path.class);
        Expression upper = mock(Expression.class);
        Predicate predicate = mock(Predicate.class);

        when(root.get(anyString())).thenReturn(path);
        when(cb.upper(any(Expression.class))).thenReturn(upper);
        when(cb.like(any(Expression.class), anyString())).thenReturn(predicate);
        lenient().when(cb.equal(any(Expression.class), anyString())).thenReturn(predicate);
        when(cb.and(any(Predicate[].class))).thenReturn(predicate);

        Predicate result = cap.getValue().toPredicate(root, query, cb);

        assertThat(result).isNotNull();
    }

    @Test
    @SuppressWarnings({"rawtypes", "unchecked"})
    void spec_conFiltrosNull_ejecutaToPredicate() {
        var pageable = PageRequest.of(0, 10);
        lenient().when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(Page.empty());

        service.findAll(null, null, null, pageable);

        ArgumentCaptor<Specification<OtTipo>> cap = ArgumentCaptor.forClass(Specification.class);
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
    void spec_conFiltrosBlank_ejecutaToPredicate() {
        var pageable = PageRequest.of(0, 10);
        lenient().when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(Page.empty());

        service.findAll("", "", "", pageable);

        ArgumentCaptor<Specification<OtTipo>> cap = ArgumentCaptor.forClass(Specification.class);
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
    void spec_conSoloFlagEstado_ejecutaToPredicate() {
        var pageable = PageRequest.of(0, 10);
        lenient().when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(Page.empty());

        service.findAll(null, null, "1", pageable);

        ArgumentCaptor<Specification<OtTipo>> cap = ArgumentCaptor.forClass(Specification.class);
        verify(repository).findAll(cap.capture(), eq(pageable));

        Root root = mock(Root.class);
        CriteriaQuery query = mock(CriteriaQuery.class);
        CriteriaBuilder cb = mock(CriteriaBuilder.class);
        Path path = mock(Path.class);
        Predicate predicate = mock(Predicate.class);
        when(root.get(anyString())).thenReturn(path);
        lenient().when(cb.equal(any(Expression.class), anyString())).thenReturn(predicate);
        when(cb.and(any(Predicate[].class))).thenReturn(predicate);

        Predicate result = cap.getValue().toPredicate(root, query, cb);

        assertThat(result).isNotNull();
    }
}
