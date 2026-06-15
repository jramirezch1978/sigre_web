package com.sigre.almacen.spec;

import org.springframework.data.jpa.domain.Specification;
import com.sigre.almacen.entity.OrdenTraslado;

import java.time.LocalDate;

public final class OrdenTrasladoSpecifications {

    private OrdenTrasladoSpecifications() {
    }

    public static Specification<OrdenTraslado> conFiltros(Long almacenOrigenId,
                                                          Long almacenDestinoId,
                                                          String estado,
                                                          LocalDate fechaDesde,
                                                          LocalDate fechaHasta) {
        return (root, query, cb) -> {
            var p = cb.conjunction();
            if (almacenOrigenId != null) {
                p = cb.and(p, cb.equal(root.get("almacenOrigenId"), almacenOrigenId));
            }
            if (almacenDestinoId != null) {
                p = cb.and(p, cb.equal(root.get("almacenDestinoId"), almacenDestinoId));
            }
            if (estado != null && !estado.isBlank()) {
                p = cb.and(p, cb.equal(root.get("flagEstado"), estado.trim()));
            }
            if (fechaDesde != null) {
                p = cb.and(p, cb.greaterThanOrEqualTo(root.get("fecha"), fechaDesde));
            }
            if (fechaHasta != null) {
                p = cb.and(p, cb.lessThanOrEqualTo(root.get("fecha"), fechaHasta));
            }
            return p;
        };
    }
}
