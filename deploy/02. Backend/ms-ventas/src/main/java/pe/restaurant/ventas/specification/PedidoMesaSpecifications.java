package pe.restaurant.ventas.specification;

import jakarta.persistence.criteria.Predicate;
import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.ventas.entity.PedidoMesa;

import java.util.ArrayList;
import java.util.List;

public final class PedidoMesaSpecifications {

    private PedidoMesaSpecifications() {}

    public static Specification<PedidoMesa> filtered(
            Long sucursalId,
            Long mesaId,
            Long meseroId,
            Long turnoId,
            String flagEstado) {

        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (sucursalId != null) {
                predicates.add(cb.equal(root.get("sucursalId"), sucursalId));
            }
            if (mesaId != null) {
                predicates.add(cb.equal(root.get("mesa").get("id"), mesaId));
            }
            if (meseroId != null) {
                predicates.add(cb.equal(root.get("meseroId"), meseroId));
            }
            if (turnoId != null) {
                predicates.add(cb.equal(root.get("turnoId"), turnoId));
            }
            if (flagEstado != null && !flagEstado.isBlank()) {
                predicates.add(cb.equal(root.get("flagEstado"), flagEstado));
            }

            if (predicates.isEmpty()) {
                return cb.conjunction();
            }
            return cb.and(predicates.toArray(Predicate[]::new));
        };
    }
}
