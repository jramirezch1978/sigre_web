package pe.restaurant.rrhh.specification;

import jakarta.persistence.criteria.Predicate;
import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.rrhh.entity.ImpuestoRentaTramo;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public final class ImpuestoRentaTramoSpecification {
    private ImpuestoRentaTramoSpecification() { throw new UnsupportedOperationException(); }

    public static Specification<ImpuestoRentaTramo> filtros(LocalDate fechaVigIni, Integer secuencia, String flagEstado) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (fechaVigIni != null) {
                predicates.add(cb.equal(root.get("fechaVigIni"), fechaVigIni));
            }
            if (secuencia != null) {
                predicates.add(cb.equal(root.get("secuencia"), secuencia));
            }
            if (flagEstado != null && !flagEstado.isEmpty()) {
                predicates.add(cb.equal(root.get("flagEstado"), flagEstado));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
