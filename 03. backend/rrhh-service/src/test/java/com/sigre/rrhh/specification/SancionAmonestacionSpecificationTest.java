package com.sigre.rrhh.specification;

import jakarta.persistence.criteria.*;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.jpa.domain.Specification;
import com.sigre.rrhh.entity.SancionAmonestacion;

import java.time.LocalDate;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("SancionAmonestacionSpecification - Pruebas Unitarias")
class SancionAmonestacionSpecificationTest {

    @Mock private CriteriaBuilder cb;
    @Mock private CriteriaQuery<?> query;
    @Mock private Root<SancionAmonestacion> root;

    @Test void filtros_todosNull_cbAndVacio() {
        Specification<SancionAmonestacion> spec = SancionAmonestacionSpecification.filtros(null, null, null, null, null);
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb).and(any(Predicate[].class));
    }

    @Test void filtros_conTrabajadorId_cbEqual() {
        Specification<SancionAmonestacion> spec = SancionAmonestacionSpecification.filtros(1L, null, null, null, null);
        when(cb.equal(root.get("trabajadorId"), 1L)).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb).equal(root.get("trabajadorId"), 1L);
    }

    @Test void filtros_conTipoSancionId_cbEqual() {
        Specification<SancionAmonestacion> spec = SancionAmonestacionSpecification.filtros(null, 2L, null, null, null);
        when(cb.equal(root.get("tipoSancionId"), 2L)).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb).equal(root.get("tipoSancionId"), 2L);
    }

    @Test void filtros_conFechaDesde_cbGreaterThanOrEqualTo() {
        Specification<SancionAmonestacion> spec = SancionAmonestacionSpecification.filtros(null, null, LocalDate.of(2026, 1, 1), null, null);
        when(cb.greaterThanOrEqualTo(root.get("fecha"), LocalDate.of(2026, 1, 1))).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb).greaterThanOrEqualTo(root.get("fecha"), LocalDate.of(2026, 1, 1));
    }

    @Test void filtros_conFechaHasta_cbLessThanOrEqualTo() {
        Specification<SancionAmonestacion> spec = SancionAmonestacionSpecification.filtros(null, null, null, LocalDate.of(2026, 12, 31), null);
        when(cb.lessThanOrEqualTo(root.get("fecha"), LocalDate.of(2026, 12, 31))).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb).lessThanOrEqualTo(root.get("fecha"), LocalDate.of(2026, 12, 31));
    }

    @Test void filtros_conFlagEstado_cbEqual() {
        Specification<SancionAmonestacion> spec = SancionAmonestacionSpecification.filtros(null, null, null, null, "1");
        when(cb.equal(root.get("flagEstado"), "1")).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb).equal(root.get("flagEstado"), "1");
    }

    @Test void filtros_conTodos_todosPredicados() {
        Specification<SancionAmonestacion> spec = SancionAmonestacionSpecification.filtros(
                1L, 2L, LocalDate.of(2026, 1, 1), LocalDate.of(2026, 12, 31), "1");
        when(cb.equal(root.get("trabajadorId"), 1L)).thenReturn(mock(Predicate.class));
        when(cb.equal(root.get("tipoSancionId"), 2L)).thenReturn(mock(Predicate.class));
        when(cb.greaterThanOrEqualTo(root.get("fecha"), LocalDate.of(2026, 1, 1))).thenReturn(mock(Predicate.class));
        when(cb.lessThanOrEqualTo(root.get("fecha"), LocalDate.of(2026, 12, 31))).thenReturn(mock(Predicate.class));
        when(cb.equal(root.get("flagEstado"), "1")).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb).equal(root.get("trabajadorId"), 1L);
        verify(cb).equal(root.get("tipoSancionId"), 2L);
        verify(cb).greaterThanOrEqualTo(root.get("fecha"), LocalDate.of(2026, 1, 1));
        verify(cb).lessThanOrEqualTo(root.get("fecha"), LocalDate.of(2026, 12, 31));
        verify(cb).equal(root.get("flagEstado"), "1");
        verify(cb).and(any(Predicate[].class));
    }

    @Test void filtros_conFlagEstadoVacio_noAgrega() {
        Specification<SancionAmonestacion> spec = SancionAmonestacionSpecification.filtros(1L, null, null, null, "");
        when(cb.equal(root.get("trabajadorId"), 1L)).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb).equal(root.get("trabajadorId"), 1L);
        verify(cb).and(any(Predicate[].class));
    }
}
