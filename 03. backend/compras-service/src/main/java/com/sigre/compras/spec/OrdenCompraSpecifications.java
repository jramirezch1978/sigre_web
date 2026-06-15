package com.sigre.compras.spec;

import org.springframework.data.jpa.domain.Specification;
import com.sigre.compras.entity.OrdenCompra;

import java.time.LocalDate;

public final class OrdenCompraSpecifications {

    private OrdenCompraSpecifications() {
    }

    public static Specification<OrdenCompra> conFiltros(Long sucursalId,
                                                        Long proveedorId,
                                                        String flagEstado,
                                                        LocalDate fechaDesde,
                                                        LocalDate fechaHasta,
                                                        String numero,
                                                        Long monedaId) {
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
            if (fechaDesde != null) {
                p = cb.and(p, cb.greaterThanOrEqualTo(root.get("fechaEmision"), fechaDesde));
            }
            if (fechaHasta != null) {
                p = cb.and(p, cb.lessThanOrEqualTo(root.get("fechaEmision"), fechaHasta));
            }
            if (numero != null && !numero.isBlank()) {
                p = cb.and(p, cb.like(cb.lower(root.get("nroOrdenCompra")),
                        "%" + numero.toLowerCase() + "%"));
            }
            if (monedaId != null) {
                p = cb.and(p, cb.equal(root.get("monedaId"), monedaId));
            }
            return p;
        };
    }
}
