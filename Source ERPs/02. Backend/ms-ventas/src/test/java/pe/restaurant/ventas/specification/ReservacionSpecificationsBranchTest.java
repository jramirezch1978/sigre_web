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
import pe.restaurant.ventas.entity.Reservacion;

import java.time.LocalDate;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("ReservacionSpecifications — Branch Coverage")
class ReservacionSpecificationsBranchTest {

    @Mock private Root<Reservacion> root;
    @Mock private CriteriaQuery<?> query;
    @Mock private CriteriaBuilder cb;

    private Predicate mockP() {
        return org.mockito.Mockito.mock(Predicate.class);
    }

    @Test
    @DisplayName("filtered() todos nulos -> conjunction")
    void filtered_todosNulos_retornaConjunction() {
        when(cb.conjunction()).thenReturn(mockP());

        var spec = ReservacionSpecifications.filtered(null, null, null, null, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).conjunction();
    }

    @Test
    @DisplayName("filtered() con sucursalId -> equal")
    void filtered_conSucursalId_agregaEqual() {
        var conj = mockP();
        var p = mockP();
        when(cb.conjunction()).thenReturn(conj);
        when(cb.equal(root.get("sucursalId"), 1L)).thenReturn(p);
        when(cb.and(conj, p)).thenReturn(p);

        var spec = ReservacionSpecifications.filtered(1L, null, null, null, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).equal(root.get("sucursalId"), 1L);
    }

    @Test
    @DisplayName("filtered() con clienteId -> equal")
    void filtered_conClienteId_agregaEqual() {
        var conj = mockP();
        var p = mockP();
        when(cb.conjunction()).thenReturn(conj);
        when(cb.equal(root.get("clienteId"), 1L)).thenReturn(p);
        when(cb.and(conj, p)).thenReturn(p);

        var spec = ReservacionSpecifications.filtered(null, 1L, null, null, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).equal(root.get("clienteId"), 1L);
    }

    @Test
    @DisplayName("filtered() con mesaId -> equal")
    void filtered_conMesaId_agregaEqual() {
        var conj = mockP();
        var p = mockP();
        when(cb.conjunction()).thenReturn(conj);
        when(cb.equal(root.get("mesaId"), 1L)).thenReturn(p);
        when(cb.and(conj, p)).thenReturn(p);

        var spec = ReservacionSpecifications.filtered(null, null, 1L, null, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).equal(root.get("mesaId"), 1L);
    }

    @Test
    @DisplayName("filtered() con estado -> equal con uppercase")
    void filtered_conEstado_agregaEqualUppercase() {
        var conj = mockP();
        var p = mockP();
        when(cb.conjunction()).thenReturn(conj);
        when(cb.equal(root.get("estado"), "CONFIRMADA")).thenReturn(p);
        when(cb.and(conj, p)).thenReturn(p);

        var spec = ReservacionSpecifications.filtered(null, null, null, "confirmada", null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).equal(root.get("estado"), "CONFIRMADA");
    }

    @Test
    @DisplayName("filtered() con estado vacío -> no agrega")
    void filtered_conEstadoVacio_soloConjunction() {
        when(cb.conjunction()).thenReturn(mockP());

        var spec = ReservacionSpecifications.filtered(null, null, null, "", null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).conjunction();
    }

    @Test
    @DisplayName("filtered() con estado blank -> no agrega")
    void filtered_conEstadoBlank_soloConjunction() {
        when(cb.conjunction()).thenReturn(mockP());

        var spec = ReservacionSpecifications.filtered(null, null, null, "   ", null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).conjunction();
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

        var spec = ReservacionSpecifications.filtered(null, null, null, null, fecha, null);
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

        var spec = ReservacionSpecifications.filtered(null, null, null, null, null, fecha);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
        verify(cb).lessThanOrEqualTo(root.get("fecha"), fecha);
    }

    @Test
    @DisplayName("filtered() con todos los parámetros -> todos los predicates")
    void filtered_conTodosLosParametros_agregaTodos() {
        var conj = mockP();
        var p = mockP();
        var desde = LocalDate.of(2024, 1, 1);
        var hasta = LocalDate.of(2024, 12, 31);
        when(cb.conjunction()).thenReturn(conj);
        when(cb.equal(root.get("sucursalId"), 1L)).thenReturn(p);
        when(cb.equal(root.get("clienteId"), 2L)).thenReturn(p);
        when(cb.equal(root.get("mesaId"), 3L)).thenReturn(p);
        when(cb.equal(root.get("estado"), "CONFIRMADA")).thenReturn(p);
        when(cb.greaterThanOrEqualTo(root.get("fecha"), desde)).thenReturn(p);
        when(cb.lessThanOrEqualTo(root.get("fecha"), hasta)).thenReturn(p);
        when(cb.and(any(Predicate.class), any(Predicate.class))).thenReturn(p);

        var spec = ReservacionSpecifications.filtered(1L, 2L, 3L, "confirmada", desde, hasta);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
    }

    @Test
    @DisplayName("filtered() con IDs y estado sin fechas -> predicates de IDs y estado")
    void filtered_conIdsYEstado_agregaPredicatesDeIds() {
        var conj = mockP();
        var p = mockP();
        when(cb.conjunction()).thenReturn(conj);
        when(cb.equal(root.get("sucursalId"), 1L)).thenReturn(p);
        when(cb.equal(root.get("clienteId"), 2L)).thenReturn(p);
        when(cb.equal(root.get("mesaId"), 3L)).thenReturn(p);
        when(cb.equal(root.get("estado"), "PENDIENTE")).thenReturn(p);
        when(cb.and(any(Predicate.class), any(Predicate.class))).thenReturn(p);

        var spec = ReservacionSpecifications.filtered(1L, 2L, 3L, "pendiente", null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
    }

    @Test
    @DisplayName("filtered() con fechas y estado sin IDs -> predicates de fechas y estado")
    void filtered_conFechasYEstado_agregaPredicatesDeFechas() {
        var conj = mockP();
        var p = mockP();
        var desde = LocalDate.of(2024, 6, 1);
        var hasta = LocalDate.of(2024, 6, 30);
        when(cb.conjunction()).thenReturn(conj);
        when(cb.equal(root.get("estado"), "CANCELADA")).thenReturn(p);
        when(cb.greaterThanOrEqualTo(root.get("fecha"), desde)).thenReturn(p);
        when(cb.lessThanOrEqualTo(root.get("fecha"), hasta)).thenReturn(p);
        when(cb.and(any(Predicate.class), any(Predicate.class))).thenReturn(p);

        var spec = ReservacionSpecifications.filtered(null, null, null, "cancelada", desde, hasta);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
    }

    @Test
    @DisplayName("filtered() con IDs y fechas sin estado -> predicates de IDs y fechas")
    void filtered_conIdsYFechas_agregaTodosSinEstado() {
        var conj = mockP();
        var p = mockP();
        var desde = LocalDate.of(2024, 6, 1);
        var hasta = LocalDate.of(2024, 6, 30);
        when(cb.conjunction()).thenReturn(conj);
        when(cb.equal(root.get("sucursalId"), 1L)).thenReturn(p);
        when(cb.equal(root.get("clienteId"), 2L)).thenReturn(p);
        when(cb.equal(root.get("mesaId"), 3L)).thenReturn(p);
        when(cb.greaterThanOrEqualTo(root.get("fecha"), desde)).thenReturn(p);
        when(cb.lessThanOrEqualTo(root.get("fecha"), hasta)).thenReturn(p);
        when(cb.and(any(Predicate.class), any(Predicate.class))).thenReturn(p);

        var spec = ReservacionSpecifications.filtered(1L, 2L, 3L, null, desde, hasta);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
    }

    @Test
    @DisplayName("filtered() con IDs y estado vacío -> no agrega estado")
    void filtered_conIdsYEstadoVacio_noAgregaEstado() {
        var conj = mockP();
        var p = mockP();
        when(cb.conjunction()).thenReturn(conj);
        when(cb.equal(root.get("sucursalId"), 1L)).thenReturn(p);
        when(cb.equal(root.get("clienteId"), 2L)).thenReturn(p);
        when(cb.equal(root.get("mesaId"), 3L)).thenReturn(p);
        when(cb.and(any(Predicate.class), any(Predicate.class))).thenReturn(p);

        var spec = ReservacionSpecifications.filtered(1L, 2L, 3L, "", null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
    }

    @Test
    @DisplayName("filtered() con IDs y estado blank -> no agrega estado")
    void filtered_conIdsYEstadoBlank_noAgregaEstado() {
        var conj = mockP();
        var p = mockP();
        when(cb.conjunction()).thenReturn(conj);
        when(cb.equal(root.get("sucursalId"), 1L)).thenReturn(p);
        when(cb.equal(root.get("clienteId"), 2L)).thenReturn(p);
        when(cb.equal(root.get("mesaId"), 3L)).thenReturn(p);
        when(cb.and(any(Predicate.class), any(Predicate.class))).thenReturn(p);

        var spec = ReservacionSpecifications.filtered(1L, 2L, 3L, "   ", null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isNotNull();
    }
}
