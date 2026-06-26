package pe.restaurant.rrhh.specification;

import jakarta.persistence.criteria.*;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.rrhh.entity.ConceptoPlanilla;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ConceptoPlanillaSpecification - Pruebas Unitarias")
class ConceptoPlanillaSpecificationTest {

    @Mock private CriteriaBuilder cb;
    @Mock private CriteriaQuery<?> query;
    @Mock private Root<ConceptoPlanilla> root;

    @Test void conCodigo_conValor_cbLike() {
        Specification<ConceptoPlanilla> spec = ConceptoPlanillaSpecification.conCodigo("COD");
        when(cb.lower(any())).thenReturn(mock(Expression.class));
        when(cb.like(any(), anyString())).thenReturn(mock(Predicate.class));
        Predicate result = spec.toPredicate(root, query, cb);
        assertThat(result).isNotNull();
        verify(cb).lower(root.get("codigo"));
        verify(cb).like(any(), eq("%cod%"));
    }

    @Test void conCodigo_null_toPredicateRetornaNull() {
        Specification<ConceptoPlanilla> spec = ConceptoPlanillaSpecification.conCodigo(null);
        assertThat(spec).isNotNull();
        Predicate result = spec.toPredicate(root, query, cb);
        assertThat(result).isNull();
    }

    @Test void conCodigo_vacio_toPredicateRetornaNull() {
        Specification<ConceptoPlanilla> spec = ConceptoPlanillaSpecification.conCodigo("");
        assertThat(spec).isNotNull();
        Predicate result = spec.toPredicate(root, query, cb);
        assertThat(result).isNull();
    }

    @Test void conNombre_conValor_cbLike() {
        Specification<ConceptoPlanilla> spec = ConceptoPlanillaSpecification.conNombre("Ingreso");
        when(cb.lower(any())).thenReturn(mock(Expression.class));
        when(cb.like(any(), anyString())).thenReturn(mock(Predicate.class));
        Predicate result = spec.toPredicate(root, query, cb);
        assertThat(result).isNotNull();
        verify(cb).lower(root.get("nombre"));
        verify(cb).like(any(), eq("%ingreso%"));
    }

    @Test void conNombre_null_toPredicateRetornaNull() {
        Specification<ConceptoPlanilla> spec = ConceptoPlanillaSpecification.conNombre(null);
        assertThat(spec).isNotNull();
        Predicate result = spec.toPredicate(root, query, cb);
        assertThat(result).isNull();
    }

    @Test void conNombre_vacio_toPredicateRetornaNull() {
        Specification<ConceptoPlanilla> spec = ConceptoPlanillaSpecification.conNombre("");
        assertThat(spec).isNotNull();
        Predicate result = spec.toPredicate(root, query, cb);
        assertThat(result).isNull();
    }

    @Test void conGrupoCalculo_conValor_cbEqual() {
        Specification<ConceptoPlanilla> spec = ConceptoPlanillaSpecification.conGrupoCalculo("10");
        Join<Object, Object> join = mock(Join.class);
        Path<Object> codigoPath = mock(Path.class);
        when(root.join("grupoConceptosPlanilla")).thenReturn(join);
        when(join.get("codigo")).thenReturn(codigoPath);
        when(cb.equal(codigoPath, "10")).thenReturn(mock(Predicate.class));
        Predicate result = spec.toPredicate(root, query, cb);
        assertThat(result).isNotNull();
        verify(cb).equal(codigoPath, "10");
    }

    @Test void conGrupoCalculo_null_toPredicateRetornaNull() {
        Specification<ConceptoPlanilla> spec = ConceptoPlanillaSpecification.conGrupoCalculo(null);
        assertThat(spec).isNotNull();
        Predicate result = spec.toPredicate(root, query, cb);
        assertThat(result).isNull();
    }

    @Test void conGrupoCalculo_vacio_toPredicateRetornaNull() {
        Specification<ConceptoPlanilla> spec = ConceptoPlanillaSpecification.conGrupoCalculo("");
        assertThat(spec).isNotNull();
        Predicate result = spec.toPredicate(root, query, cb);
        assertThat(result).isNull();
    }

    @Test void combinacionAnd_conCodigoYNombre_funciona() {
        Specification<ConceptoPlanilla> spec1 = ConceptoPlanillaSpecification.conCodigo("COD");
        Specification<ConceptoPlanilla> spec2 = ConceptoPlanillaSpecification.conNombre("Ingreso");
        Specification<ConceptoPlanilla> combined = spec1.and(spec2);
        assertThat(combined).isNotNull();
    }
}
