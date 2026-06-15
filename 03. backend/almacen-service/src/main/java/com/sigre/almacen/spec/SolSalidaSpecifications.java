package com.sigre.almacen.spec;

import org.springframework.data.jpa.domain.Specification;
import com.sigre.almacen.entity.SolSalida;

public final class SolSalidaSpecifications {

    private SolSalidaSpecifications() {
    }

    public static Specification<SolSalida> conFiltros(Long almacenId, String estado) {
        return (root, query, cb) -> {
            var p = cb.conjunction();
            if (almacenId != null) {
                p = cb.and(p, cb.equal(root.get("almacenId"), almacenId));
            }
            if (estado != null && !estado.isBlank()) {
                p = cb.and(p, cb.equal(root.get("flagEstado"), estado.trim()));
            }
            return p;
        };
    }
}
