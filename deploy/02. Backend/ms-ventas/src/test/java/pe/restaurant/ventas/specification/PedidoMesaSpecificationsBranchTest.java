package pe.restaurant.ventas.specification;

import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Path;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.ventas.entity.PedidoMesa;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("PedidoMesaSpecifications — Branch Coverage")
class PedidoMesaSpecificationsBranchTest {

    @Mock private Root<PedidoMesa> root;
    @Mock private CriteriaQuery<?> query;
    @Mock private CriteriaBuilder cb;

    private Predicate mockPredicate() {
        return org.mockito.Mockito.mock(Predicate.class);
    }

    @Test
    @DisplayName("filtered() con todos nulos -> conjunction")
    void filtered_todosNulos_retornaConjunction() {
        when(cb.conjunction()).thenReturn(mockPredicate());

        var spec = PedidoMesaSpecifications.filtered(null, null, null, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).conjunction();
    }

    @Test
    @DisplayName("filtered() con sucursalId -> equal")
    void filtered_conSucursalId_agregaEqual() {
        var p = mockPredicate();
        when(cb.equal(root.get("sucursalId"), 1L)).thenReturn(p);
        when(cb.and(any(Predicate[].class))).thenReturn(p);

        var spec = PedidoMesaSpecifications.filtered(1L, null, null, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).equal(root.get("sucursalId"), 1L);
    }

    @Test
    @DisplayName("filtered() con mesaId -> equal en mesa.id")
    void filtered_conMesaId_agregaEqual() {
        var p = mockPredicate();
        Path mesaPath = org.mockito.Mockito.mock(Path.class);
        Path mesaIdPath = org.mockito.Mockito.mock(Path.class);
        when(root.get("mesa")).thenReturn(mesaPath);
        when(mesaPath.get("id")).thenReturn(mesaIdPath);
        when(cb.equal(mesaIdPath, 1L)).thenReturn(p);
        when(cb.and(any(Predicate[].class))).thenReturn(p);

        var spec = PedidoMesaSpecifications.filtered(null, 1L, null, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).equal(mesaIdPath, 1L);
    }

    @Test
    @DisplayName("filtered() con meseroId -> equal")
    void filtered_conMeseroId_agregaEqual() {
        var p = mockPredicate();
        when(cb.equal(root.get("meseroId"), 1L)).thenReturn(p);
        when(cb.and(any(Predicate[].class))).thenReturn(p);

        var spec = PedidoMesaSpecifications.filtered(null, null, 1L, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).equal(root.get("meseroId"), 1L);
    }

    @Test
    @DisplayName("filtered() con turnoId -> equal")
    void filtered_conTurnoId_agregaEqual() {
        var p = mockPredicate();
        when(cb.equal(root.get("turnoId"), 1L)).thenReturn(p);
        when(cb.and(any(Predicate[].class))).thenReturn(p);

        var spec = PedidoMesaSpecifications.filtered(null, null, null, 1L, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).equal(root.get("turnoId"), 1L);
    }

    @Test
    @DisplayName("filtered() con flagEstado -> equal")
    void filtered_conFlagEstado_agregaEqual() {
        var p = mockPredicate();
        when(cb.equal(root.get("flagEstado"), "1")).thenReturn(p);
        when(cb.and(any(Predicate[].class))).thenReturn(p);

        var spec = PedidoMesaSpecifications.filtered(null, null, null, null, "1");
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).equal(root.get("flagEstado"), "1");
    }

    @Test
    @DisplayName("filtered() con flagEstado vacío -> conjunction")
    void filtered_conFlagEstadoVacio_soloConjunction() {
        when(cb.conjunction()).thenReturn(mockPredicate());

        var spec = PedidoMesaSpecifications.filtered(null, null, null, null, "");
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).conjunction();
    }

    @Test
    @DisplayName("filtered() con flagEstado blank -> conjunction")
    void filtered_conFlagEstadoBlank_soloConjunction() {
        when(cb.conjunction()).thenReturn(mockPredicate());

        var spec = PedidoMesaSpecifications.filtered(null, null, null, null, "   ");
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).conjunction();
    }

    @Test
    @DisplayName("filtered() con múltiples IDs -> múltiples equals")
    void filtered_conMultiplesIds_agregaMultiplesPredicates() {
        var p = mockPredicate();
        Path mesaPath = org.mockito.Mockito.mock(Path.class);
        Path mesaIdPath = org.mockito.Mockito.mock(Path.class);
        Path defaultPath = org.mockito.Mockito.mock(Path.class);
        when(root.get("mesa")).thenReturn(mesaPath);
        when(mesaPath.get("id")).thenReturn(mesaIdPath);
        when(root.get("sucursalId")).thenReturn(defaultPath);
        when(root.get("meseroId")).thenReturn(defaultPath);
        when(cb.equal(defaultPath, 1L)).thenReturn(p);
        when(cb.equal(mesaIdPath, 2L)).thenReturn(p);
        when(cb.equal(defaultPath, 3L)).thenReturn(p);
        when(cb.and(any(Predicate[].class))).thenReturn(p);

        var spec = PedidoMesaSpecifications.filtered(1L, 2L, 3L, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
    }

    @Test
    @DisplayName("filtered() con todos los parámetros -> todos los predicates")
    void filtered_conTodosLosParametros_agregaTodos() {
        var p = mockPredicate();
        Path mesaPath = org.mockito.Mockito.mock(Path.class);
        Path mesaIdPath = org.mockito.Mockito.mock(Path.class);
        Path defaultPath = org.mockito.Mockito.mock(Path.class);
        when(root.get("mesa")).thenReturn(mesaPath);
        when(mesaPath.get("id")).thenReturn(mesaIdPath);
        when(root.get("sucursalId")).thenReturn(defaultPath);
        when(root.get("meseroId")).thenReturn(defaultPath);
        when(root.get("turnoId")).thenReturn(defaultPath);
        when(root.get("flagEstado")).thenReturn(defaultPath);
        when(cb.equal(defaultPath, 1L)).thenReturn(p);
        when(cb.equal(mesaIdPath, 2L)).thenReturn(p);
        when(cb.equal(defaultPath, 3L)).thenReturn(p);
        when(cb.equal(defaultPath, 4L)).thenReturn(p);
        when(cb.equal(defaultPath, "1")).thenReturn(p);
        when(cb.and(any(Predicate[].class))).thenReturn(p);

        var spec = PedidoMesaSpecifications.filtered(1L, 2L, 3L, 4L, "1");
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
    }
}
