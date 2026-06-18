package pe.restaurant.ventas.specification;

import jakarta.persistence.criteria.Predicate;
import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.ventas.entity.Comanda;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

/**
 * Filtros opcionales sin JPQL del estilo {@code (:x IS NULL OR :x = '' OR col = :x)}: en PostgreSQL el driver
 * no siempre infiere el tipo de los parámetros repetidos y devuelve {@code could not determine data type of parameter}.
 */
public final class ComandaSpecifications {

    private ComandaSpecifications() {}

    public static Specification<Comanda> filtered(
            Long sucursalId,
            Long puntoVentaId,
            String mesaContains,
            String flagEstado,
            Instant fechaDesde,
            Instant fechaHasta) {

        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (sucursalId != null) {
                predicates.add(cb.equal(root.get("sucursalId"), sucursalId));
            }
            if (puntoVentaId != null) {
                predicates.add(cb.equal(root.get("puntoVentaId"), puntoVentaId));
            }
            if (mesaContains != null && !mesaContains.isBlank()) {
                String pattern = "%" + mesaContains.toLowerCase(Locale.ROOT) + "%";
                predicates.add(cb.like(cb.lower(root.get("mesa")), pattern));
            }
            if (flagEstado != null && !flagEstado.isBlank()) {
                predicates.add(cb.equal(root.get("flagEstado"), flagEstado));
            }
            if (fechaDesde != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("fechaHora"), fechaDesde));
            }
            if (fechaHasta != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("fechaHora"), fechaHasta));
            }

            if (predicates.isEmpty()) {
                return cb.conjunction();
            }
            return cb.and(predicates.toArray(Predicate[]::new));
        };
    }
}
