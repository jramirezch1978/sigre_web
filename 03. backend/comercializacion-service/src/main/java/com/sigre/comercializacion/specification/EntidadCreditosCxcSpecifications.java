package com.sigre.comercializacion.specification;

import org.springframework.data.jpa.domain.Specification;
import com.sigre.comercializacion.entity.EntidadCreditosCxc;

public final class EntidadCreditosCxcSpecifications {

    private EntidadCreditosCxcSpecifications() {
    }

    public static Specification<EntidadCreditosCxc> filtered(Long entidadContribuyenteId, Long monedaId, String flagEstado) {
        return (root, query, cb) -> {
            var preds = cb.conjunction();
            if (entidadContribuyenteId != null) {
                preds = cb.and(preds, cb.equal(root.get("entidadContribuyenteId"), entidadContribuyenteId));
            }
            if (monedaId != null) {
                preds = cb.and(preds, cb.equal(root.get("monedaId"), monedaId));
            }
            if (flagEstado != null && !flagEstado.isBlank()) {
                preds = cb.and(preds, cb.equal(root.get("flagEstado"), flagEstado));
            }
            return preds;
        };
    }
}
