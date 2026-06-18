package pe.restaurant.rrhh.specification;

import jakarta.persistence.criteria.*;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.rrhh.entity.GanDescFijo;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("GanDescFijoSpecification - Pruebas Unitarias")
class GanDescFijoSpecificationTest {

    @Mock private CriteriaBuilder cb;
    @Mock private CriteriaQuery<?> query;
    @Mock private Root<GanDescFijo> root;

    @Test void withFilters_todosNull_cbAndVacio() {
        Specification<GanDescFijo> spec = GanDescFijoSpecification.withFilters(null, null, null);
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb).and(any(Predicate[].class));
    }

    @Test void withFilters_conTrabajadorId_cbEqual() {
        Specification<GanDescFijo> spec = GanDescFijoSpecification.withFilters(1L, null, null);
        when(cb.equal(root.get("trabajadorId"), 1L)).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb).equal(root.get("trabajadorId"), 1L);
        verify(cb).and(any(Predicate[].class));
    }

    @Test void withFilters_conConceptoId_cbEqual() {
        Specification<GanDescFijo> spec = GanDescFijoSpecification.withFilters(null, 2L, null);
        when(cb.equal(root.get("conceptoId"), 2L)).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb).equal(root.get("conceptoId"), 2L);
        verify(cb).and(any(Predicate[].class));
    }

    @Test void withFilters_conFlagEstado_cbEqual() {
        Specification<GanDescFijo> spec = GanDescFijoSpecification.withFilters(null, null, "1");
        when(cb.equal(root.get("flagEstado"), "1")).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb).equal(root.get("flagEstado"), "1");
        verify(cb).and(any(Predicate[].class));
    }

    @Test void withFilters_conTodos_todosPredicados() {
        Specification<GanDescFijo> spec = GanDescFijoSpecification.withFilters(1L, 2L, "1");
        when(cb.equal(root.get("trabajadorId"), 1L)).thenReturn(mock(Predicate.class));
        when(cb.equal(root.get("conceptoId"), 2L)).thenReturn(mock(Predicate.class));
        when(cb.equal(root.get("flagEstado"), "1")).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb).equal(root.get("trabajadorId"), 1L);
        verify(cb).equal(root.get("conceptoId"), 2L);
        verify(cb).equal(root.get("flagEstado"), "1");
        verify(cb).and(any(Predicate[].class));
    }
}
