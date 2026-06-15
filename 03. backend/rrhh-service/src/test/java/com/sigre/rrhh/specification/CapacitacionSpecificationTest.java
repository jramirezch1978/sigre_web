package com.sigre.rrhh.specification;

import jakarta.persistence.criteria.*;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.jpa.domain.Specification;
import com.sigre.rrhh.entity.Capacitacion;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CapacitacionSpecification - Pruebas Unitarias")
class CapacitacionSpecificationTest {

    @Mock private CriteriaBuilder cb;
    @Mock private CriteriaQuery<?> query;
    @Mock private Root<Capacitacion> root;

    @Test void filtros_todosNull_cbAndVacio() {
        Specification<Capacitacion> spec = CapacitacionSpecification.filtros(null, null);
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb).and(any(Predicate[].class));
    }

    @Test void filtros_conNombre_cbLike() {
        Specification<Capacitacion> spec = CapacitacionSpecification.filtros("Curso", null);
        when(cb.lower(any())).thenReturn(mock(Expression.class));
        when(cb.like(any(), anyString())).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb).lower(root.get("nombre"));
        verify(cb).like(any(), eq("%curso%"));
        verify(cb).and(any(Predicate[].class));
    }

    @Test void filtros_conFlagEstado_cbEqual() {
        Specification<Capacitacion> spec = CapacitacionSpecification.filtros(null, "1");
        when(cb.equal(root.get("flagEstado"), "1")).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb).equal(root.get("flagEstado"), "1");
        verify(cb).and(any(Predicate[].class));
    }

    @Test void filtros_conNombreYFlagEstado_ambosPredicados() {
        Specification<Capacitacion> spec = CapacitacionSpecification.filtros("Curso", "1");
        when(cb.lower(any())).thenReturn(mock(Expression.class));
        when(cb.like(any(), anyString())).thenReturn(mock(Predicate.class));
        when(cb.equal(root.get("flagEstado"), "1")).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb).lower(root.get("nombre"));
        verify(cb).like(any(), eq("%curso%"));
        verify(cb).equal(root.get("flagEstado"), "1");
        verify(cb).and(any(Predicate[].class));
    }

    @Test void filtros_conNombreVacio_noFiltraNombre() {
        Specification<Capacitacion> spec = CapacitacionSpecification.filtros("", null);
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb).and(any(Predicate[].class));
    }

    @Test void filtros_conFlagEstadoVacio_noFiltraEstado() {
        Specification<Capacitacion> spec = CapacitacionSpecification.filtros("Curso", "");
        when(cb.lower(any())).thenReturn(mock(Expression.class));
        when(cb.like(any(), anyString())).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb).lower(root.get("nombre"));
        verify(cb).like(any(), eq("%curso%"));
        verify(cb).and(any(Predicate[].class));
    }
}
