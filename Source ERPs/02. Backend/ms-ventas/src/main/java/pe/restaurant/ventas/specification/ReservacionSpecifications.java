package pe.restaurant.ventas.specification;

import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.ventas.entity.Reservacion;

import java.time.LocalDate;

public final class ReservacionSpecifications {

    private ReservacionSpecifications() {
    }

    public static Specification<Reservacion> filtered(
            Long sucursalId,
            Long clienteId,
            Long mesaId,
            String estado,
            LocalDate fechaDesde,
            LocalDate fechaHasta) {
        return (root, query, cb) -> {
            var preds = cb.conjunction();
            if (sucursalId != null) {
                preds = cb.and(preds, cb.equal(root.get("sucursalId"), sucursalId));
            }
            if (clienteId != null) {
                preds = cb.and(preds, cb.equal(root.get("clienteId"), clienteId));
            }
            if (mesaId != null) {
                preds = cb.and(preds, cb.equal(root.get("mesaId"), mesaId));
            }
            if (estado != null && !estado.isBlank()) {
                preds = cb.and(preds, cb.equal(root.get("estado"), estado.toUpperCase()));
            }
            if (fechaDesde != null) {
                preds = cb.and(preds, cb.greaterThanOrEqualTo(root.get("fecha"), fechaDesde));
            }
            if (fechaHasta != null) {
                preds = cb.and(preds, cb.lessThanOrEqualTo(root.get("fecha"), fechaHasta));
            }
            return preds;
        };
    }
}
