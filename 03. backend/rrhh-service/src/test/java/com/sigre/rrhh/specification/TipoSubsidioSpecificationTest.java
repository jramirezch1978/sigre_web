package com.sigre.rrhh.specification;

import jakarta.persistence.criteria.*;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.jpa.domain.Specification;
import com.sigre.rrhh.entity.TipoSubsidio;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("TipoSubsidioSpecification - Pruebas Unitarias")
class TipoSubsidioSpecificationTest {

    @Mock private CriteriaBuilder cb;
    @Mock private CriteriaQuery<?> query;
    @Mock private Root<TipoSubsidio> root;

    @Test void filtros_todosNull_cbAndVacio() {
        Specification<TipoSubsidio> spec = TipoSubsidioSpecification.filtros(null, null, null);
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb).and(any(Predicate[].class));
    }

    @Test void filtros_conCodigo_cbLike() {
        Specification<TipoSubsidio> spec = TipoSubsidioSpecification.filtros("COD", null, null);
        when(cb.lower(any())).thenReturn(mock(Expression.class));
        when(cb.like(any(), anyString())).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb).lower(root.get("codigo"));
        verify(cb).like(any(), eq("%cod%"));
    }

    @Test void filtros_conNombre_cbLike() {
        Specification<TipoSubsidio> spec = TipoSubsidioSpecification.filtros(null, "Subsidio", null);
        when(cb.lower(any())).thenReturn(mock(Expression.class));
        when(cb.like(any(), anyString())).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb).lower(root.get("nombre"));
        verify(cb).like(any(), eq("%subsidio%"));
    }

    @Test void filtros_conFlagEstado_cbEqual() {
        Specification<TipoSubsidio> spec = TipoSubsidioSpecification.filtros(null, null, "1");
        when(cb.equal(root.get("flagEstado"), "1")).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb).equal(root.get("flagEstado"), "1");
    }

    @Test void filtros_conTodos_todosPredicados() {
        Specification<TipoSubsidio> spec = TipoSubsidioSpecification.filtros("COD", "Subsidio", "1");
        when(cb.lower(any())).thenReturn(mock(Expression.class));
        when(cb.like(any(), anyString())).thenReturn(mock(Predicate.class));
        when(cb.equal(root.get("flagEstado"), "1")).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb, times(2)).lower(any());
        verify(cb, times(2)).like(any(), anyString());
        verify(cb).equal(root.get("flagEstado"), "1");
    }

    @Test void filtros_conFlagEstadoVacio_noAgrega() {
        Specification<TipoSubsidio> spec = TipoSubsidioSpecification.filtros(null, null, "");
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb).and(any(Predicate[].class));
    }
}
