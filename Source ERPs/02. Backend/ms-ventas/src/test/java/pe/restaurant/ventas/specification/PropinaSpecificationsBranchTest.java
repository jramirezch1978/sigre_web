package pe.restaurant.ventas.specification;

import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.ventas.entity.Propina;

import java.time.LocalDate;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("PropinaSpecifications — Branch Coverage")
class PropinaSpecificationsBranchTest {

    @Mock private Root<Propina> root;
    @Mock private CriteriaQuery<?> query;
    @Mock private CriteriaBuilder cb;

    private Predicate mockP() {
        return org.mockito.Mockito.mock(Predicate.class);
    }

    @Test
    @DisplayName("filtered() todos nulos -> conjunction")
    void filtered_todosNulos_retornaConjunction() {
        when(cb.conjunction()).thenReturn(mockP());

        var spec = PropinaSpecifications.filtered(null, null, null, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).conjunction();
    }

    @Test
    @DisplayName("filtered() con fsFacturaSimplId -> equal")
    void filtered_conFsFacturaSimplId_agregaEqual() {
        var conj = mockP();
        var p = mockP();
        when(cb.conjunction()).thenReturn(conj);
        when(cb.equal(root.get("fsFacturaSimplId"), 1L)).thenReturn(p);
        when(cb.and(conj, p)).thenReturn(p);

        var spec = PropinaSpecifications.filtered(1L, null, null, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).equal(root.get("fsFacturaSimplId"), 1L);
    }

    @Test
    @DisplayName("filtered() con trabajadorId -> equal")
    void filtered_conTrabajadorId_agregaEqual() {
        var conj = mockP();
        var p = mockP();
        when(cb.conjunction()).thenReturn(conj);
        when(cb.equal(root.get("trabajadorId"), 1L)).thenReturn(p);
        when(cb.and(conj, p)).thenReturn(p);

        var spec = PropinaSpecifications.filtered(null, 1L, null, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).equal(root.get("trabajadorId"), 1L);
    }

    @Test
    @DisplayName("filtered() con fechaDesde -> greaterThanOrEqualTo")
    void filtered_conFechaDesde_agregaGreaterThanOrEqualTo() {
        var conj = mockP();
        var p = mockP();
        var fecha = LocalDate.of(2024, 1, 1);
        when(cb.conjunction()).thenReturn(conj);
        when(cb.greaterThanOrEqualTo(root.get("fecha"), fecha)).thenReturn(p);
        when(cb.and(conj, p)).thenReturn(p);

        var spec = PropinaSpecifications.filtered(null, null, fecha, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).greaterThanOrEqualTo(root.get("fecha"), fecha);
    }

    @Test
    @DisplayName("filtered() con fechaHasta -> lessThanOrEqualTo")
    void filtered_conFechaHasta_agregaLessThanOrEqualTo() {
        var conj = mockP();
        var p = mockP();
        var fecha = LocalDate.of(2024, 12, 31);
        when(cb.conjunction()).thenReturn(conj);
        when(cb.lessThanOrEqualTo(root.get("fecha"), fecha)).thenReturn(p);
        when(cb.and(conj, p)).thenReturn(p);

        var spec = PropinaSpecifications.filtered(null, null, null, fecha, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).lessThanOrEqualTo(root.get("fecha"), fecha);
    }

    @Test
    @DisplayName("filtered() con flagEstado -> equal")
    void filtered_conFlagEstado_agregaEqual() {
        var conj = mockP();
        var p = mockP();
        when(cb.conjunction()).thenReturn(conj);
        when(cb.equal(root.get("flagEstado"), "1")).thenReturn(p);
        when(cb.and(conj, p)).thenReturn(p);

        var spec = PropinaSpecifications.filtered(null, null, null, null, "1");
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).equal(root.get("flagEstado"), "1");
    }

    @Test
    @DisplayName("filtered() con flagEstado vacío -> no agrega")
    void filtered_conFlagEstadoVacio_soloConjunction() {
        when(cb.conjunction()).thenReturn(mockP());

        var spec = PropinaSpecifications.filtered(null, null, null, null, "");
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).conjunction();
    }

    @Test
    @DisplayName("filtered() con flagEstado blank -> no agrega")
    void filtered_conFlagEstadoBlank_soloConjunction() {
        when(cb.conjunction()).thenReturn(mockP());

        var spec = PropinaSpecifications.filtered(null, null, null, null, "   ");
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).conjunction();
    }

    @Test
    @DisplayName("filtered() con todos los parámetros -> todos los predicates")
    void filtered_conTodosLosParametros_agregaTodos() {
        var conj = mockP();
        var p = mockP();
        var desde = LocalDate.of(2024, 1, 1);
        var hasta = LocalDate.of(2024, 12, 31);
        when(cb.conjunction()).thenReturn(conj);
        when(cb.equal(root.get("fsFacturaSimplId"), 1L)).thenReturn(p);
        when(cb.equal(root.get("trabajadorId"), 2L)).thenReturn(p);
        when(cb.greaterThanOrEqualTo(root.get("fecha"), desde)).thenReturn(p);
        when(cb.lessThanOrEqualTo(root.get("fecha"), hasta)).thenReturn(p);
        when(cb.equal(root.get("flagEstado"), "1")).thenReturn(p);
        when(cb.and(any(Predicate.class), any(Predicate.class))).thenReturn(p);

        var spec = PropinaSpecifications.filtered(1L, 2L, desde, hasta, "1");
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
    }
}
