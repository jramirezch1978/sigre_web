package pe.restaurant.ventas.specification;

import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Expression;
import jakarta.persistence.criteria.Path;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.ventas.entity.FsFacturaSimpl;

import java.time.LocalDate;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("FsFacturaSimplSpecifications — Branch Coverage")
class FsFacturaSimplSpecificationsBranchTest {

    @Mock private Root<FsFacturaSimpl> root;
    @Mock private CriteriaQuery<?> query;
    @Mock private CriteriaBuilder cb;

    private Predicate mockP() {
        return org.mockito.Mockito.mock(Predicate.class);
    }

    @SuppressWarnings("unchecked")
    private Expression<String> mockStr() {
        return org.mockito.Mockito.mock(Expression.class);
    }

    @Test
    @DisplayName("filtered() todos nulos -> conjunction")
    void filtered_todosNulos_retornaConjunction() {
        when(cb.conjunction()).thenReturn(mockP());

        var spec = FsFacturaSimplSpecifications.filtered(
                null, null, null, null, null, null, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).conjunction();
    }

    @Test
    @DisplayName("filtered() con sucursalId -> equal")
    void filtered_conSucursalId_agregaEqual() {
        var p = mockP();
        when(cb.equal(root.get("sucursalId"), 1L)).thenReturn(p);
        when(cb.and(any(Predicate[].class))).thenReturn(p);

        var spec = FsFacturaSimplSpecifications.filtered(
                1L, null, null, null, null, null, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).equal(root.get("sucursalId"), 1L);
    }

    @Test
    @DisplayName("filtered() con clienteId -> equal")
    void filtered_conClienteId_agregaEqual() {
        var p = mockP();
        when(cb.equal(root.get("clienteId"), 1L)).thenReturn(p);
        when(cb.and(any(Predicate[].class))).thenReturn(p);

        var spec = FsFacturaSimplSpecifications.filtered(
                null, 1L, null, null, null, null, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).equal(root.get("clienteId"), 1L);
    }

    @Test
    @DisplayName("filtered() con docTipoId -> equal")
    void filtered_conDocTipoId_agregaEqual() {
        var p = mockP();
        when(cb.equal(root.get("docTipoId"), 1L)).thenReturn(p);
        when(cb.and(any(Predicate[].class))).thenReturn(p);

        var spec = FsFacturaSimplSpecifications.filtered(
                null, null, 1L, null, null, null, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).equal(root.get("docTipoId"), 1L);
    }

    @Test
    @DisplayName("filtered() con serie -> like lowercase")
    void filtered_conSerie_agregaLike() {
        var p = mockP();
        var lower = mockStr();
        Path seriePath = org.mockito.Mockito.mock(Path.class);
        when(root.get("serie")).thenReturn(seriePath);
        when(cb.lower(seriePath)).thenReturn(lower);
        when(cb.like(lower, "%f001%")).thenReturn(p);
        when(cb.and(any(Predicate[].class))).thenReturn(p);

        var spec = FsFacturaSimplSpecifications.filtered(
                null, null, null, "F001", null, null, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).lower(root.get("serie"));
        verify(cb).like(lower, "%f001%");
    }

    @Test
    @DisplayName("filtered() con serie vacía -> no agrega")
    void filtered_conSerieVacia_soloConjunction() {
        when(cb.conjunction()).thenReturn(mockP());

        var spec = FsFacturaSimplSpecifications.filtered(
                null, null, null, "", null, null, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).conjunction();
    }

    @Test
    @DisplayName("filtered() con serie blank -> no agrega")
    void filtered_conSerieBlank_soloConjunction() {
        when(cb.conjunction()).thenReturn(mockP());

        var spec = FsFacturaSimplSpecifications.filtered(
                null, null, null, "   ", null, null, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).conjunction();
    }

    @Test
    @DisplayName("filtered() con numero -> like lowercase")
    void filtered_conNumero_agregaLike() {
        var p = mockP();
        var lower = mockStr();
        Path numPath = org.mockito.Mockito.mock(Path.class);
        when(root.get("numero")).thenReturn(numPath);
        when(cb.lower(numPath)).thenReturn(lower);
        when(cb.like(lower, "%12345%")).thenReturn(p);
        when(cb.and(any(Predicate[].class))).thenReturn(p);

        var spec = FsFacturaSimplSpecifications.filtered(
                null, null, null, null, "12345", null, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).lower(root.get("numero"));
        verify(cb).like(lower, "%12345%");
    }

    @Test
    @DisplayName("filtered() con numero vacío -> no agrega")
    void filtered_conNumeroVacio_soloConjunction() {
        when(cb.conjunction()).thenReturn(mockP());

        var spec = FsFacturaSimplSpecifications.filtered(
                null, null, null, null, "", null, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).conjunction();
    }

    @Test
    @DisplayName("filtered() con numero blank -> no agrega")
    void filtered_conNumeroBlank_soloConjunction() {
        when(cb.conjunction()).thenReturn(mockP());

        var spec = FsFacturaSimplSpecifications.filtered(
                null, null, null, null, "   ", null, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).conjunction();
    }

    @Test
    @DisplayName("filtered() con flagEstado -> equal")
    void filtered_conFlagEstado_agregaEqual() {
        var p = mockP();
        when(cb.equal(root.get("flagEstado"), "1")).thenReturn(p);
        when(cb.and(any(Predicate[].class))).thenReturn(p);

        var spec = FsFacturaSimplSpecifications.filtered(
                null, null, null, null, null, "1", null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).equal(root.get("flagEstado"), "1");
    }

    @Test
    @DisplayName("filtered() con flagEstado vacío -> no agrega")
    void filtered_conFlagEstadoVacio_soloConjunction() {
        when(cb.conjunction()).thenReturn(mockP());

        var spec = FsFacturaSimplSpecifications.filtered(
                null, null, null, null, null, "", null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).conjunction();
    }

    @Test
    @DisplayName("filtered() con flagEstado blank -> no agrega")
    void filtered_conFlagEstadoBlank_soloConjunction() {
        when(cb.conjunction()).thenReturn(mockP());

        var spec = FsFacturaSimplSpecifications.filtered(
                null, null, null, null, null, "   ", null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).conjunction();
    }

    @Test
    @DisplayName("filtered() con fechaDesde -> greaterThanOrEqualTo")
    void filtered_conFechaDesde_agregaGreaterThanOrEqualTo() {
        var p = mockP();
        var fecha = LocalDate.of(2024, 1, 1);
        when(cb.greaterThanOrEqualTo(root.get("fechaEmision"), fecha)).thenReturn(p);
        when(cb.and(any(Predicate[].class))).thenReturn(p);

        var spec = FsFacturaSimplSpecifications.filtered(
                null, null, null, null, null, null, fecha, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).greaterThanOrEqualTo(root.get("fechaEmision"), fecha);
    }

    @Test
    @DisplayName("filtered() con fechaHasta -> lessThanOrEqualTo")
    void filtered_conFechaHasta_agregaLessThanOrEqualTo() {
        var p = mockP();
        var fecha = LocalDate.of(2024, 12, 31);
        when(cb.lessThanOrEqualTo(root.get("fechaEmision"), fecha)).thenReturn(p);
        when(cb.and(any(Predicate[].class))).thenReturn(p);

        var spec = FsFacturaSimplSpecifications.filtered(
                null, null, null, null, null, null, null, fecha);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).lessThanOrEqualTo(root.get("fechaEmision"), fecha);
    }

    @Test
    @DisplayName("filtered() con todos los parámetros -> todos los predicates")
    void filtered_conTodosLosParametros_agregaTodos() {
        var p = mockP();
        var lowerSerie = mockStr();
        var lowerNum = mockStr();
        var desde = LocalDate.of(2024, 1, 1);
        var hasta = LocalDate.of(2024, 12, 31);
        Path seriePath = org.mockito.Mockito.mock(Path.class);
        Path numPath = org.mockito.Mockito.mock(Path.class);
        Path defaultPath = org.mockito.Mockito.mock(Path.class);
        when(root.get("serie")).thenReturn(seriePath);
        when(root.get("numero")).thenReturn(numPath);
        when(root.get("sucursalId")).thenReturn(defaultPath);
        when(root.get("clienteId")).thenReturn(defaultPath);
        when(root.get("docTipoId")).thenReturn(defaultPath);
        when(root.get("flagEstado")).thenReturn(defaultPath);
        when(root.get("fechaEmision")).thenReturn(defaultPath);
        when(cb.equal(defaultPath, 1L)).thenReturn(p);
        when(cb.equal(defaultPath, 2L)).thenReturn(p);
        when(cb.equal(defaultPath, 3L)).thenReturn(p);
        when(cb.lower(seriePath)).thenReturn(lowerSerie);
        when(cb.like(lowerSerie, "%f001%")).thenReturn(p);
        when(cb.lower(numPath)).thenReturn(lowerNum);
        when(cb.like(lowerNum, "%12345%")).thenReturn(p);
        when(cb.equal(defaultPath, "1")).thenReturn(p);
        when(cb.greaterThanOrEqualTo(defaultPath, desde)).thenReturn(p);
        when(cb.lessThanOrEqualTo(defaultPath, hasta)).thenReturn(p);
        when(cb.and(any(Predicate[].class))).thenReturn(p);

        var spec = FsFacturaSimplSpecifications.filtered(
                1L, 2L, 3L, "F001", "12345", "1", desde, hasta);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
    }
}
