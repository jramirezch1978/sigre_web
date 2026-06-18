package pe.restaurant.ventas.specification;

import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.ventas.entity.Propina;

import java.time.LocalDate;

public final class PropinaSpecifications {

    private PropinaSpecifications() {
    }

    public static Specification<Propina> filtered(
            Long fsFacturaSimplId,
            Long trabajadorId,
            LocalDate fechaDesde,
            LocalDate fechaHasta,
            String flagEstado) {
        return (root, query, cb) -> {
            var preds = cb.conjunction();
            if (fsFacturaSimplId != null) {
                preds = cb.and(preds, cb.equal(root.get("fsFacturaSimplId"), fsFacturaSimplId));
            }
            if (trabajadorId != null) {
                preds = cb.and(preds, cb.equal(root.get("trabajadorId"), trabajadorId));
            }
            if (fechaDesde != null) {
                preds = cb.and(preds, cb.greaterThanOrEqualTo(root.get("fecha"), fechaDesde));
            }
            if (fechaHasta != null) {
                preds = cb.and(preds, cb.lessThanOrEqualTo(root.get("fecha"), fechaHasta));
            }
            if (flagEstado != null && !flagEstado.isBlank()) {
                preds = cb.and(preds, cb.equal(root.get("flagEstado"), flagEstado));
            }
            return preds;
        };
    }
}
