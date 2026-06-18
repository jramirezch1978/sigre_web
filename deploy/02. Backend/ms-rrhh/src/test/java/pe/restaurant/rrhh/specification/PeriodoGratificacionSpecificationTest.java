package pe.restaurant.rrhh.specification;

import jakarta.persistence.criteria.*;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.rrhh.entity.PeriodoGratificacion;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("PeriodoGratificacionSpecification - Pruebas Unitarias")
class PeriodoGratificacionSpecificationTest {

    @Mock private CriteriaBuilder cb;
    @Mock private CriteriaQuery<?> query;
    @Mock private Root<PeriodoGratificacion> root;

    @Test void filtros_todosNull_cbAndConArregloVacio() {
        Specification<PeriodoGratificacion> spec = PeriodoGratificacionSpecification.filtros(null, null, null);
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        Predicate r = spec.toPredicate(root, query, cb);
        assertThat(r).isNotNull();
        verify(cb).and(any(Predicate[].class));
    }

    @Test void filtros_conCodigo_cbLikeInvocado() {
        Specification<PeriodoGratificacion> spec = PeriodoGratificacionSpecification.filtros("COD", null, null);
        when(cb.lower(any())).thenReturn(mock(Expression.class));
        when(cb.like(any(), anyString())).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        Predicate r = spec.toPredicate(root, query, cb);
        assertThat(r).isNotNull();
        verify(cb).lower(root.get("codigo"));
        verify(cb).like(any(), eq("%cod%"));
        verify(cb).and(any(Predicate[].class));
    }

    @Test void filtros_conNombre_cbLikeInvocado() {
        Specification<PeriodoGratificacion> spec = PeriodoGratificacionSpecification.filtros(null, "Grati", null);
        when(cb.lower(any())).thenReturn(mock(Expression.class));
        when(cb.like(any(), anyString())).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        Predicate r = spec.toPredicate(root, query, cb);
        assertThat(r).isNotNull();
        verify(cb).lower(root.get("nombre"));
        verify(cb).like(any(), eq("%grati%"));
        verify(cb).and(any(Predicate[].class));
    }

    @Test void filtros_conFlagEstado_cbEqualInvocado() {
        Specification<PeriodoGratificacion> spec = PeriodoGratificacionSpecification.filtros(null, null, "1");
        when(cb.equal(root.get("flagEstado"), "1")).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        Predicate r = spec.toPredicate(root, query, cb);
        assertThat(r).isNotNull();
        verify(cb).equal(root.get("flagEstado"), "1");
        verify(cb).and(any(Predicate[].class));
    }

    @Test void filtros_conTodosParametros_todosPredicados() {
        Specification<PeriodoGratificacion> spec = PeriodoGratificacionSpecification.filtros("COD", "Grati", "1");
        when(cb.lower(any())).thenReturn(mock(Expression.class));
        when(cb.like(any(), anyString())).thenReturn(mock(Predicate.class));
        when(cb.equal(root.get("flagEstado"), "1")).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        Predicate r = spec.toPredicate(root, query, cb);
        assertThat(r).isNotNull();
        verify(cb, times(2)).lower(any());
        verify(cb, times(2)).like(any(), anyString());
        verify(cb).equal(root.get("flagEstado"), "1");
        verify(cb).and(any(Predicate[].class));
    }

    @Test void filtros_conFlagEstadoVacio_noAgregaPredicado() {
        Specification<PeriodoGratificacion> spec = PeriodoGratificacionSpecification.filtros(null, null, "");
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        Predicate r = spec.toPredicate(root, query, cb);
        assertThat(r).isNotNull();
        verify(cb).and(any(Predicate[].class));
    }
}
