package com.sigre.compras.spec;

import jakarta.persistence.criteria.*;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.data.jpa.domain.Specification;
import com.sigre.compras.entity.OrdenServicio;

import java.time.LocalDate;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@SuppressWarnings("unchecked")
@DisplayName("OrdenServicioSpecifications — Pruebas Unitarias")
class OrdenServicioSpecificationsTest {

    private final Root<OrdenServicio> root = mock(Root.class);
    private final CriteriaQuery<?> query = mock(CriteriaQuery.class);
    private final CriteriaBuilder cb = mock(CriteriaBuilder.class);

    @Test
    @DisplayName("conFiltros() todos null -> retorna conjunction")
    void conFiltros_todosNull_retornaConjunction() {
        Predicate conj = mock(Predicate.class);
        when(cb.conjunction()).thenReturn(conj);

        Specification<OrdenServicio> spec = OrdenServicioSpecifications.conFiltros(
                null, null, null, null, null, null, null, null, null, null, null, null);
        Predicate result = spec.toPredicate(root, query, cb);

        assertThat(result).isEqualTo(conj);
        verify(cb, never()).equal(any(Expression.class), anyLong());
    }

    @Test
    @DisplayName("conFiltros() con sucursal id agrega predicado")
    void conFiltros_conSucursalId_agregaPredicado() {
        Predicate conj = mock(Predicate.class);
        Predicate pred = mock(Predicate.class);
        Path<Object> path = mock(Path.class);
        when(cb.conjunction()).thenReturn(conj);
        when(root.get("sucursalId")).thenReturn(path);
        when(cb.equal(path, 1L)).thenReturn(pred);
        when(cb.and(conj, pred)).thenReturn(pred);

        Specification<OrdenServicio> spec = OrdenServicioSpecifications.conFiltros(
                1L, null, null, null, null, null, null, null, null, null, null, null);
        spec.toPredicate(root, query, cb);

        verify(cb).equal(path, 1L);
    }

    @Test
    @DisplayName("conFiltros() con proveedor id agrega predicado")
    void conFiltros_conProveedorId_agregaPredicado() {
        Predicate conj = mock(Predicate.class);
        Predicate pred = mock(Predicate.class);
        Path<Object> path = mock(Path.class);
        when(cb.conjunction()).thenReturn(conj);
        when(root.get("proveedorId")).thenReturn(path);
        when(cb.equal(path, 2L)).thenReturn(pred);
        when(cb.and(conj, pred)).thenReturn(pred);

        Specification<OrdenServicio> spec = OrdenServicioSpecifications.conFiltros(
                null, 2L, null, null, null, null, null, null, null, null, null, null);
        spec.toPredicate(root, query, cb);

        verify(cb).equal(path, 2L);
    }

    @Test
    @DisplayName("conFiltros() con flag estado agrega predicado")
    void conFiltros_conFlagEstado_agregaPredicado() {
        Predicate conj = mock(Predicate.class);
        Predicate pred = mock(Predicate.class);
        Path<Object> path = mock(Path.class);
        when(cb.conjunction()).thenReturn(conj);
        when(root.get("flagEstado")).thenReturn(path);
        when(cb.equal(path, "1")).thenReturn(pred);
        when(cb.and(conj, pred)).thenReturn(pred);

        Specification<OrdenServicio> spec = OrdenServicioSpecifications.conFiltros(
                null, null, "1", null, null, null, null, null, null, null, null, null);
        spec.toPredicate(root, query, cb);

        verify(cb).equal(path, "1");
    }

    @Test
    @DisplayName("conFiltros() con cod origen agrega predicado")
    void conFiltros_conCodOrigen_agregaPredicado() {
        Predicate conj = mock(Predicate.class);
        Predicate pred = mock(Predicate.class);
        Path<Object> path = mock(Path.class);
        when(cb.conjunction()).thenReturn(conj);
        when(root.get("codOrigen")).thenReturn(path);
        when(cb.equal(path, "OC")).thenReturn(pred);
        when(cb.and(conj, pred)).thenReturn(pred);

        Specification<OrdenServicio> spec = OrdenServicioSpecifications.conFiltros(
                null, null, null, "OC", null, null, null, null, null, null, null, null);
        spec.toPredicate(root, query, cb);

        verify(cb).equal(path, "OC");
    }

    @Test
    @DisplayName("conFiltros() con número agrega predicado like")
    void conFiltros_conNumero_agregaPredicadoLike() {
        Predicate conj = mock(Predicate.class);
        Predicate pred = mock(Predicate.class);
        Path<String> path = mock(Path.class);
        Expression<String> lowerExpr = mock(Expression.class);
        when(cb.conjunction()).thenReturn(conj);
        when(root.<String>get("nroOs")).thenReturn(path);
        when(cb.lower(path)).thenReturn(lowerExpr);
        when(cb.like(eq(lowerExpr), eq("%os-001%"))).thenReturn(pred);
        when(cb.and(conj, pred)).thenReturn(pred);

        Specification<OrdenServicio> spec = OrdenServicioSpecifications.conFiltros(
                null, null, null, null, "OS-001", null, null, null, null, null, null, null);
        spec.toPredicate(root, query, cb);

        verify(cb).like(eq(lowerExpr), eq("%os-001%"));
    }

    @Test
    @DisplayName("conFiltros() número blank -> ignora filtro")
    void conFiltros_numeroBlank_ignoraFiltro() {
        Predicate conj = mock(Predicate.class);
        when(cb.conjunction()).thenReturn(conj);

        Specification<OrdenServicio> spec = OrdenServicioSpecifications.conFiltros(
                null, null, null, null, "  ", null, null, null, null, null, null, null);
        spec.toPredicate(root, query, cb);

        verify(root, never()).get("nroOs");
    }

    @Test
    @DisplayName("conFiltros() con fecha desde agrega predicado")
    void conFiltros_conFechaDesde_agregaPredicado() {
        Predicate conj = mock(Predicate.class);
        Predicate pred = mock(Predicate.class);
        Path<LocalDate> path = mock(Path.class);
        when(cb.conjunction()).thenReturn(conj);
        when(root.<LocalDate>get("fecRegistro")).thenReturn(path);
        when(cb.greaterThanOrEqualTo(eq(path), any(LocalDate.class))).thenReturn(pred);
        when(cb.and(conj, pred)).thenReturn(pred);

        LocalDate desde = LocalDate.of(2026, 1, 1);
        Specification<OrdenServicio> spec = OrdenServicioSpecifications.conFiltros(
                null, null, null, null, null, desde, null, null, null, null, null, null);
        spec.toPredicate(root, query, cb);

        verify(cb).greaterThanOrEqualTo(eq(path), eq(desde));
    }

    @Test
    @DisplayName("conFiltros() con fecha hasta agrega predicado")
    void conFiltros_conFechaHasta_agregaPredicado() {
        Predicate conj = mock(Predicate.class);
        Predicate pred = mock(Predicate.class);
        Path<LocalDate> path = mock(Path.class);
        when(cb.conjunction()).thenReturn(conj);
        when(root.<LocalDate>get("fecRegistro")).thenReturn(path);
        when(cb.lessThanOrEqualTo(eq(path), any(LocalDate.class))).thenReturn(pred);
        when(cb.and(conj, pred)).thenReturn(pred);

        LocalDate hasta = LocalDate.of(2026, 12, 31);
        Specification<OrdenServicio> spec = OrdenServicioSpecifications.conFiltros(
                null, null, null, null, null, null, hasta, null, null, null, null, null);
        spec.toPredicate(root, query, cb);

        verify(cb).lessThanOrEqualTo(eq(path), eq(hasta));
    }

    @Test
    @DisplayName("conFiltros() con moneda id agrega predicado")
    void conFiltros_conMonedaId_agregaPredicado() {
        Predicate conj = mock(Predicate.class);
        Predicate pred = mock(Predicate.class);
        Path<Object> path = mock(Path.class);
        when(cb.conjunction()).thenReturn(conj);
        when(root.get("monedaId")).thenReturn(path);
        when(cb.equal(path, 1L)).thenReturn(pred);
        when(cb.and(conj, pred)).thenReturn(pred);

        Specification<OrdenServicio> spec = OrdenServicioSpecifications.conFiltros(
                null, null, null, null, null, null, null, 1L, null, null, null, null);
        spec.toPredicate(root, query, cb);

        verify(cb).equal(path, 1L);
    }

    @Test
    @DisplayName("conFiltros() con comprador id agrega predicado")
    void conFiltros_conCompradorId_agregaPredicado() {
        Predicate conj = mock(Predicate.class);
        Predicate pred = mock(Predicate.class);
        Path<Object> path = mock(Path.class);
        when(cb.conjunction()).thenReturn(conj);
        when(root.get("compradorId")).thenReturn(path);
        when(cb.equal(path, 3L)).thenReturn(pred);
        when(cb.and(conj, pred)).thenReturn(pred);

        Specification<OrdenServicio> spec = OrdenServicioSpecifications.conFiltros(
                null, null, null, null, null, null, null, null, 3L, null, null, null);
        spec.toPredicate(root, query, cb);

        verify(cb).equal(path, 3L);
    }

    @Test
    @DisplayName("conFiltros() con flag req serv agrega predicado")
    void conFiltros_conFlagReqServ_agregaPredicado() {
        Predicate conj = mock(Predicate.class);
        Predicate pred = mock(Predicate.class);
        Path<Object> path = mock(Path.class);
        when(cb.conjunction()).thenReturn(conj);
        when(root.get("flagReqServ")).thenReturn(path);
        when(cb.equal(path, "1")).thenReturn(pred);
        when(cb.and(conj, pred)).thenReturn(pred);

        Specification<OrdenServicio> spec = OrdenServicioSpecifications.conFiltros(
                null, null, null, null, null, null, null, null, null, "1", null, null);
        spec.toPredicate(root, query, cb);

        verify(cb).equal(path, "1");
    }

    @Test
    @DisplayName("conFiltros() con orden trabajo id agrega predicado")
    void conFiltros_conOrdenTrabajoId_agregaPredicado() {
        Predicate conj = mock(Predicate.class);
        Predicate pred = mock(Predicate.class);
        Path<Object> path = mock(Path.class);
        when(cb.conjunction()).thenReturn(conj);
        when(root.get("ordenTrabajoId")).thenReturn(path);
        when(cb.equal(path, 5L)).thenReturn(pred);
        when(cb.and(conj, pred)).thenReturn(pred);

        Specification<OrdenServicio> spec = OrdenServicioSpecifications.conFiltros(
                null, null, null, null, null, null, null, null, null, null, 5L, null);
        spec.toPredicate(root, query, cb);

        verify(cb).equal(path, 5L);
    }

    @Test
    @DisplayName("conFiltros() con job código agrega predicado")
    void conFiltros_conJobCodigo_agregaPredicado() {
        Predicate conj = mock(Predicate.class);
        Predicate pred = mock(Predicate.class);
        Path<Object> path = mock(Path.class);
        when(cb.conjunction()).thenReturn(conj);
        when(root.get("job")).thenReturn(path);
        when(cb.equal(path, "JOB-001")).thenReturn(pred);
        when(cb.and(conj, pred)).thenReturn(pred);

        Specification<OrdenServicio> spec = OrdenServicioSpecifications.conFiltros(
                null, null, null, null, null, null, null, null, null, null, null, "JOB-001");
        spec.toPredicate(root, query, cb);

        verify(cb).equal(path, "JOB-001");
    }

    @Test
    @DisplayName("conFiltros() todos llenos -> retorna specification no null")
    void conFiltros_todosLlenos_retornaSpecificationNoNull() {
        Specification<OrdenServicio> spec = OrdenServicioSpecifications.conFiltros(
                1L, 2L, "1", "OC", "OS-001",
                LocalDate.now().minusDays(30), LocalDate.now(),
                1L, 3L, "1", 5L, "JOB-001");
        assertThat(spec).isNotNull();
    }
}
