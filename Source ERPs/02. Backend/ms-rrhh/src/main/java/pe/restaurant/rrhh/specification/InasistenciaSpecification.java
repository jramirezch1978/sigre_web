package pe.restaurant.rrhh.specification;

import jakarta.persistence.criteria.Predicate;
import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.rrhh.entity.Inasistencia;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public final class InasistenciaSpecification {

    private InasistenciaSpecification() {
        throw new UnsupportedOperationException("Clase de specification — no instanciable");
    }

    public static Specification<Inasistencia> filtros(Long trabajadorId, LocalDate fechaDesde,
                                                    LocalDate fechaHasta, String flagEstado) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (trabajadorId != null) {
                predicates.add(cb.equal(root.get("trabajadorId"), trabajadorId));
            }
            if (fechaDesde != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("fechaDesde"), fechaDesde));
            }
            if (fechaHasta != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("fechaDesde"), fechaHasta));
            }
            if (flagEstado != null && !flagEstado.isBlank()) {
                predicates.add(cb.equal(root.get("flagEstado"), flagEstado));
            } else {
                predicates.add(cb.notEqual(root.get("flagEstado"), "0"));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
