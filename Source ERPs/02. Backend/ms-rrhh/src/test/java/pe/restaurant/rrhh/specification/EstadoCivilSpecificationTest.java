package pe.restaurant.rrhh.specification;

import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.rrhh.entity.EstadoCivil;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("EstadoCivilSpecification - Pruebas Unitarias")
class EstadoCivilSpecificationTest {

    @Mock private CriteriaBuilder cb;
    @Mock private CriteriaQuery<?> query;
    @Mock private Root<EstadoCivil> root;

    @Test
    @DisplayName("filtros() todos null -> cb.and() con arreglo vacío")
    void filtros_todosNull_cbAndConArregloVacio() {
        Specification<EstadoCivil> spec = EstadoCivilSpecification.filtros(null, null, null);
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));

        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).and(any(Predicate[].class));
    }

    @Test
    @DisplayName("filtros() con codigo -> cb.like() invocado")
    void filtros_conCodigo_cbLikeInvocado() {
        Specification<EstadoCivil> spec = EstadoCivilSpecification.filtros("COD", null, null);
        when(cb.lower(any())).thenReturn(mock(jakarta.persistence.criteria.Expression.class));
        when(cb.like(any(), anyString())).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));

        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).lower(root.get("codigo"));
        verify(cb).like(any(), eq("%cod%"));
        verify(cb).and(any(Predicate[].class));
    }

    @Test
    @DisplayName("filtros() con nombre -> cb.like() invocado")
    void filtros_conNombre_cbLikeInvocado() {
        Specification<EstadoCivil> spec = EstadoCivilSpecification.filtros(null, "Soltero", null);
        when(cb.lower(any())).thenReturn(mock(jakarta.persistence.criteria.Expression.class));
        when(cb.like(any(), anyString())).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));

        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).lower(root.get("nombre"));
        verify(cb).like(any(), eq("%soltero%"));
        verify(cb).and(any(Predicate[].class));
    }

    @Test
    @DisplayName("filtros() con flagEstado -> cb.equal() invocado")
    void filtros_conFlagEstado_cbEqualInvocado() {
        Specification<EstadoCivil> spec = EstadoCivilSpecification.filtros(null, null, "1");
        when(cb.equal(root.get("flagEstado"), "1")).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));

        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).equal(root.get("flagEstado"), "1");
        verify(cb).and(any(Predicate[].class));
    }

    @Test
    @DisplayName("filtros() con todos parámetros -> todos los predicados construidos")
    void filtros_conTodosParametros_todosLosPredicadosConstruidos() {
        Specification<EstadoCivil> spec = EstadoCivilSpecification.filtros("COD", "Soltero", "1");
        when(cb.lower(any())).thenReturn(mock(jakarta.persistence.criteria.Expression.class));
        when(cb.like(any(), anyString())).thenReturn(mock(Predicate.class));
        when(cb.equal(root.get("flagEstado"), "1")).thenReturn(mock(Predicate.class));
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));

        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb, times(2)).lower(any());
        verify(cb, times(2)).like(any(), anyString());
        verify(cb).equal(root.get("flagEstado"), "1");
        verify(cb).and(any(Predicate[].class));
    }

    @Test
    @DisplayName("filtros() con flagEstado vacío -> no agrega predicado")
    void filtros_conFlagEstadoVacio_noAgregaPredicado() {
        Specification<EstadoCivil> spec = EstadoCivilSpecification.filtros(null, null, "");
        when(cb.and(any(Predicate[].class))).thenReturn(mock(Predicate.class));

        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).and(any(Predicate[].class));
    }
}
