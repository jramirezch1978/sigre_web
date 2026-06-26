package pe.restaurant.rrhh.specification;

import jakarta.persistence.criteria.*;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.rrhh.entity.PermisoLicencia;

import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("PermisoLicenciaSpecification — Pruebas Unitarias")
class PermisoLicenciaSpecificationTest {

    @Mock private CriteriaBuilder cb;
    @Mock private CriteriaQuery<?> query;
    @Mock private Root<PermisoLicencia> root;

    @Test void filtros_todosNull_cbAndVacio() {
        Specification<PermisoLicencia> spec = PermisoLicenciaSpecification.filtros(null, null, null, null);
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb).and(any(Predicate[].class));
    }

    @Test void filtros_conTrabajadorId_cbEqual() {
        Specification<PermisoLicencia> spec = PermisoLicenciaSpecification.filtros(1L, null, null, null);
        when(cb.equal(root.get("trabajadorId"), 1L)).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb).equal(root.get("trabajadorId"), 1L);
    }

    @Test void filtros_conFechaDesde_cbGreaterThanOrEqualTo() {
        Specification<PermisoLicencia> spec = PermisoLicenciaSpecification.filtros(null, LocalDate.of(2026, 1, 1), null, null);
        when(cb.greaterThanOrEqualTo(root.get("fechaInicio"), LocalDate.of(2026, 1, 1))).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb).greaterThanOrEqualTo(root.get("fechaInicio"), LocalDate.of(2026, 1, 1));
    }

    @Test void filtros_conFechaHasta_cbLessThanOrEqualTo() {
        Specification<PermisoLicencia> spec = PermisoLicenciaSpecification.filtros(null, null, LocalDate.of(2026, 12, 31), null);
        when(cb.lessThanOrEqualTo(root.get("fechaFin"), LocalDate.of(2026, 12, 31))).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb).lessThanOrEqualTo(root.get("fechaFin"), LocalDate.of(2026, 12, 31));
    }

    @Test void filtros_conFlagEstado_cbIn() {
        Specification<PermisoLicencia> spec = PermisoLicenciaSpecification.filtros(null, null, null, "1");
        @SuppressWarnings("unchecked")
        Path<Object> flagPath = mock(Path.class);
        CriteriaBuilder.In<Object> inClause = mock(CriteriaBuilder.In.class);
        when(root.get("flagEstado")).thenReturn(flagPath);
        when(flagPath.in(List.of("1", "P", "S"))).thenReturn(inClause);
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(flagPath).in(List.of("1", "P", "S"));
    }

    @Test void filtros_conTodos_todosPredicados() {
        Specification<PermisoLicencia> spec = PermisoLicenciaSpecification.filtros(
                1L, LocalDate.of(2026, 1, 1), LocalDate.of(2026, 12, 31), "1");
        when(cb.equal(root.get("trabajadorId"), 1L)).thenReturn(mock(Predicate.class));
        when(cb.greaterThanOrEqualTo(root.get("fechaInicio"), LocalDate.of(2026, 1, 1))).thenReturn(mock(Predicate.class));
        when(cb.lessThanOrEqualTo(root.get("fechaFin"), LocalDate.of(2026, 12, 31))).thenReturn(mock(Predicate.class));
        @SuppressWarnings("unchecked")
        Path<Object> flagPath = mock(Path.class);
        CriteriaBuilder.In<Object> inClause = mock(CriteriaBuilder.In.class);
        when(root.get("flagEstado")).thenReturn(flagPath);
        when(flagPath.in(List.of("1", "P", "S"))).thenReturn(inClause);
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb).equal(root.get("trabajadorId"), 1L);
        verify(cb).greaterThanOrEqualTo(root.get("fechaInicio"), LocalDate.of(2026, 1, 1));
        verify(cb).lessThanOrEqualTo(root.get("fechaFin"), LocalDate.of(2026, 12, 31));
        verify(flagPath).in(List.of("1", "P", "S"));
        verify(cb).and(any(Predicate[].class));
    }

    @Test void filtros_conFlagEstadoVacio_noAgrega() {
        Specification<PermisoLicencia> spec = PermisoLicenciaSpecification.filtros(1L, null, null, "");
        when(cb.equal(root.get("trabajadorId"), 1L)).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));
        assertThat(spec.toPredicate(root, query, cb)).isNotNull();
        verify(cb).equal(root.get("trabajadorId"), 1L);
        verify(cb).and(any(Predicate[].class));
    }
}
