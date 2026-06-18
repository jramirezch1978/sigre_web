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
import pe.restaurant.ventas.entity.Comanda;

import java.time.Instant;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("ComandaSpecifications — Branch Coverage")
class ComandaSpecificationsBranchTest {

    @Mock private Root<Comanda> root;
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
    @DisplayName("filtered() con todos los parámetros nulos -> retorna conjunction")
    void filtered_todosNulos_retornaConjunction() {
        when(cb.conjunction()).thenReturn(mockP());

        var spec = ComandaSpecifications.filtered(null, null, null, null, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).conjunction();
    }

    @Test
    @DisplayName("filtered() con sucursalId -> agrega equal")
    void filtered_conSucursalId_agregaEqual() {
        var p = mockP();
        when(cb.equal(root.get("sucursalId"), 1L)).thenReturn(p);
        when(cb.and(any(Predicate[].class))).thenReturn(p);

        var spec = ComandaSpecifications.filtered(1L, null, null, null, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).equal(root.get("sucursalId"), 1L);
    }

    @Test
    @DisplayName("filtered() con puntoVentaId -> agrega equal")
    void filtered_conPuntoVentaId_agregaEqual() {
        var p = mockP();
        when(cb.equal(root.get("puntoVentaId"), 1L)).thenReturn(p);
        when(cb.and(any(Predicate[].class))).thenReturn(p);

        var spec = ComandaSpecifications.filtered(null, 1L, null, null, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).equal(root.get("puntoVentaId"), 1L);
    }

    @Test
    @DisplayName("filtered() con mesa -> agrega like lowercase")
    void filtered_conMesa_agregaLike() {
        var p = mockP();
        var lower = mockStr();
        Path mesaPath = org.mockito.Mockito.mock(Path.class);
        when(root.get("mesa")).thenReturn(mesaPath);
        when(cb.lower(mesaPath)).thenReturn(lower);
        when(cb.like(lower, "%mesa1%")).thenReturn(p);
        when(cb.and(any(Predicate[].class))).thenReturn(p);

        var spec = ComandaSpecifications.filtered(null, null, "MESA1", null, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).lower(mesaPath);
        verify(cb).like(lower, "%mesa1%");
    }

    @Test
    @DisplayName("filtered() con mesa vacía -> no agrega predicate")
    void filtered_conMesaVacia_soloConjunction() {
        when(cb.conjunction()).thenReturn(mockP());

        var spec = ComandaSpecifications.filtered(null, null, "", null, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).conjunction();
    }

    @Test
    @DisplayName("filtered() con mesa blank -> no agrega predicate")
    void filtered_conMesaBlank_soloConjunction() {
        when(cb.conjunction()).thenReturn(mockP());

        var spec = ComandaSpecifications.filtered(null, null, "   ", null, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).conjunction();
    }

    @Test
    @DisplayName("filtered() con flagEstado -> agrega equal")
    void filtered_conFlagEstado_agregaEqual() {
        var p = mockP();
        when(cb.equal(root.get("flagEstado"), "1")).thenReturn(p);
        when(cb.and(any(Predicate[].class))).thenReturn(p);

        var spec = ComandaSpecifications.filtered(null, null, null, "1", null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).equal(root.get("flagEstado"), "1");
    }

    @Test
    @DisplayName("filtered() con flagEstado vacío -> no agrega predicate")
    void filtered_conFlagEstadoVacio_soloConjunction() {
        when(cb.conjunction()).thenReturn(mockP());

        var spec = ComandaSpecifications.filtered(null, null, null, "", null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).conjunction();
    }

    @Test
    @DisplayName("filtered() con flagEstado blank -> no agrega predicate")
    void filtered_conFlagEstadoBlank_soloConjunction() {
        when(cb.conjunction()).thenReturn(mockP());

        var spec = ComandaSpecifications.filtered(null, null, null, "   ", null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).conjunction();
    }

    @Test
    @DisplayName("filtered() con fechaDesde -> agrega greaterThanOrEqualTo")
    void filtered_conFechaDesde_agregaGreaterThanOrEqualTo() {
        var p = mockP();
        var ahora = Instant.now();
        when(cb.greaterThanOrEqualTo(root.get("fechaHora"), ahora)).thenReturn(p);
        when(cb.and(any(Predicate[].class))).thenReturn(p);

        var spec = ComandaSpecifications.filtered(null, null, null, null, ahora, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).greaterThanOrEqualTo(root.get("fechaHora"), ahora);
    }

    @Test
    @DisplayName("filtered() con fechaHasta -> agrega lessThanOrEqualTo")
    void filtered_conFechaHasta_agregaLessThanOrEqualTo() {
        var p = mockP();
        var ahora = Instant.now();
        when(cb.lessThanOrEqualTo(root.get("fechaHora"), ahora)).thenReturn(p);
        when(cb.and(any(Predicate[].class))).thenReturn(p);

        var spec = ComandaSpecifications.filtered(null, null, null, null, null, ahora);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).lessThanOrEqualTo(root.get("fechaHora"), ahora);
    }

    @Test
    @DisplayName("filtered() con todos los parámetros -> agrega todos los predicates")
    void filtered_conTodosLosParametros_agregaTodos() {
        var p = mockP();
        var lower = mockStr();
        var ahora = Instant.now();
        Path mesaPath = org.mockito.Mockito.mock(Path.class);
        Path defaultPath = org.mockito.Mockito.mock(Path.class);
        when(root.get("mesa")).thenReturn(mesaPath);
        when(root.get("sucursalId")).thenReturn(defaultPath);
        when(root.get("puntoVentaId")).thenReturn(defaultPath);
        when(root.get("flagEstado")).thenReturn(defaultPath);
        when(root.get("fechaHora")).thenReturn(defaultPath);
        when(cb.equal(defaultPath, 1L)).thenReturn(p);
        when(cb.equal(defaultPath, 2L)).thenReturn(p);
        when(cb.lower(mesaPath)).thenReturn(lower);
        when(cb.like(lower, "%mesa1%")).thenReturn(p);
        when(cb.equal(defaultPath, "1")).thenReturn(p);
        when(cb.greaterThanOrEqualTo(defaultPath, ahora.minusSeconds(3600))).thenReturn(p);
        when(cb.lessThanOrEqualTo(defaultPath, ahora)).thenReturn(p);
        when(cb.and(any(Predicate[].class))).thenReturn(p);

        var spec = ComandaSpecifications.filtered(1L, 2L, "MESA1", "1",
                ahora.minusSeconds(3600), ahora);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
    }
}
