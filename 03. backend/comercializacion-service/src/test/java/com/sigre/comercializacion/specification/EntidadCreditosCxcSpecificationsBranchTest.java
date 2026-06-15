package com.sigre.comercializacion.specification;

import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import com.sigre.comercializacion.entity.EntidadCreditosCxc;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("EntidadCreditosCxcSpecifications — Branch Coverage")
class EntidadCreditosCxcSpecificationsBranchTest {

    @Mock private Root<EntidadCreditosCxc> root;
    @Mock private CriteriaQuery<?> query;
    @Mock private CriteriaBuilder cb;

    private Predicate mockP() {
        return org.mockito.Mockito.mock(Predicate.class);
    }

    @Test
    @DisplayName("filtered() todos nulos -> conjunction")
    void filtered_todosNulos_retornaConjunction() {
        when(cb.conjunction()).thenReturn(mockP());

        var spec = EntidadCreditosCxcSpecifications.filtered(null, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).conjunction();
    }

    @Test
    @DisplayName("filtered() con entidadContribuyenteId -> equal")
    void filtered_conEntidadContribuyenteId_agregaEqual() {
        var conj = mockP();
        var p = mockP();
        when(cb.conjunction()).thenReturn(conj);
        when(cb.equal(root.get("entidadContribuyenteId"), 1L)).thenReturn(p);
        when(cb.and(conj, p)).thenReturn(p);

        var spec = EntidadCreditosCxcSpecifications.filtered(1L, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).equal(root.get("entidadContribuyenteId"), 1L);
    }

    @Test
    @DisplayName("filtered() con monedaId -> equal")
    void filtered_conMonedaId_agregaEqual() {
        var conj = mockP();
        var p = mockP();
        when(cb.conjunction()).thenReturn(conj);
        when(cb.equal(root.get("monedaId"), 1L)).thenReturn(p);
        when(cb.and(conj, p)).thenReturn(p);

        var spec = EntidadCreditosCxcSpecifications.filtered(null, 1L, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).equal(root.get("monedaId"), 1L);
    }

    @Test
    @DisplayName("filtered() con flagEstado -> equal")
    void filtered_conFlagEstado_agregaEqual() {
        var conj = mockP();
        var p = mockP();
        when(cb.conjunction()).thenReturn(conj);
        when(cb.equal(root.get("flagEstado"), "1")).thenReturn(p);
        when(cb.and(conj, p)).thenReturn(p);

        var spec = EntidadCreditosCxcSpecifications.filtered(null, null, "1");
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).equal(root.get("flagEstado"), "1");
    }

    @Test
    @DisplayName("filtered() con flagEstado vacío -> no agrega")
    void filtered_conFlagEstadoVacio_soloConjunction() {
        when(cb.conjunction()).thenReturn(mockP());

        var spec = EntidadCreditosCxcSpecifications.filtered(null, null, "");
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).conjunction();
    }

    @Test
    @DisplayName("filtered() con flagEstado blank -> no agrega")
    void filtered_conFlagEstadoBlank_soloConjunction() {
        when(cb.conjunction()).thenReturn(mockP());

        var spec = EntidadCreditosCxcSpecifications.filtered(null, null, "   ");
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).conjunction();
    }

    @Test
    @DisplayName("filtered() con todos los parámetros -> todos los predicates")
    void filtered_conTodosLosParametros_agregaTodos() {
        var conj = mockP();
        var p = mockP();
        when(cb.conjunction()).thenReturn(conj);
        when(cb.equal(root.get("entidadContribuyenteId"), 1L)).thenReturn(p);
        when(cb.equal(root.get("monedaId"), 2L)).thenReturn(p);
        when(cb.equal(root.get("flagEstado"), "1")).thenReturn(p);
        when(cb.and(any(Predicate.class), any(Predicate.class))).thenReturn(p);

        var spec = EntidadCreditosCxcSpecifications.filtered(1L, 2L, "1");
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
    }

    @Test
    @DisplayName("filtered() con entidad y moneda sin flag -> dos predicates")
    void filtered_conEntidadYMoneda_agregaDosPredicates() {
        var conj = mockP();
        var p = mockP();
        when(cb.conjunction()).thenReturn(conj);
        when(cb.equal(root.get("entidadContribuyenteId"), 1L)).thenReturn(p);
        when(cb.equal(root.get("monedaId"), 2L)).thenReturn(p);
        when(cb.and(any(Predicate.class), any(Predicate.class))).thenReturn(p);

        var spec = EntidadCreditosCxcSpecifications.filtered(1L, 2L, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
    }
}
