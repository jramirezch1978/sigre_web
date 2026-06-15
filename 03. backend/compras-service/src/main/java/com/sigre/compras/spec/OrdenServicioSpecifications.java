package com.sigre.compras.spec;

import org.springframework.data.jpa.domain.Specification;
import com.sigre.compras.entity.OrdenServicio;

import java.time.LocalDate;

public final class OrdenServicioSpecifications {

    private OrdenServicioSpecifications() {
    }

    public static Specification<OrdenServicio> conFiltros(Long sucursalId,
                                                          Long proveedorId,
                                                          String flagEstado,
                                                          String codOrigen,
                                                          String numero,
                                                          LocalDate fechaDesde,
                                                          LocalDate fechaHasta,
                                                          Long monedaId,
                                                          Long compradorId,
                                                          String flagReqServ,
                                                          Long ordenTrabajoId,
                                                          String jobCodigo) {
        return (root, query, cb) -> {
            var p = cb.conjunction();
            if (sucursalId != null) {
                p = cb.and(p, cb.equal(root.get("sucursalId"), sucursalId));
            }
            if (proveedorId != null) {
                p = cb.and(p, cb.equal(root.get("proveedorId"), proveedorId));
            }
            if (flagEstado != null && !flagEstado.isBlank()) {
                p = cb.and(p, cb.equal(root.get("flagEstado"), flagEstado));
            }
            if (codOrigen != null && !codOrigen.isBlank()) {
                p = cb.and(p, cb.equal(root.get("codOrigen"), codOrigen));
            }
            if (numero != null && !numero.isBlank()) {
                p = cb.and(p, cb.like(cb.lower(root.get("nroOs")),
                        "%" + numero.toLowerCase() + "%"));
            }
            if (fechaDesde != null) {
                p = cb.and(p, cb.greaterThanOrEqualTo(root.get("fecRegistro"), fechaDesde));
            }
            if (fechaHasta != null) {
                p = cb.and(p, cb.lessThanOrEqualTo(root.get("fecRegistro"), fechaHasta));
            }
            if (monedaId != null) {
                p = cb.and(p, cb.equal(root.get("monedaId"), monedaId));
            }
            if (compradorId != null) {
                p = cb.and(p, cb.equal(root.get("compradorId"), compradorId));
            }
            if (flagReqServ != null && !flagReqServ.isBlank()) {
                p = cb.and(p, cb.equal(root.get("flagReqServ"), flagReqServ));
            }
            if (ordenTrabajoId != null) {
                p = cb.and(p, cb.equal(root.get("ordenTrabajoId"), ordenTrabajoId));
            }
            if (jobCodigo != null && !jobCodigo.isBlank()) {
                p = cb.and(p, cb.equal(root.get("job"), jobCodigo));
            }
            return p;
        };
    }
}
