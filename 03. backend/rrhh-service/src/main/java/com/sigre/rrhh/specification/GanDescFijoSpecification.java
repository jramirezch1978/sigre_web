package com.sigre.rrhh.specification;

import jakarta.persistence.criteria.Predicate;
import org.springframework.data.jpa.domain.Specification;
import com.sigre.rrhh.entity.GanDescFijo;

import java.util.ArrayList;
import java.util.List;

public final class GanDescFijoSpecification {

    private GanDescFijoSpecification() {
        throw new UnsupportedOperationException("Utility class");
    }

    public static Specification<GanDescFijo> withFilters(
            Long trabajadorId, Long conceptoId, String flagEstado) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (trabajadorId != null) {
                predicates.add(cb.equal(root.get("trabajadorId"), trabajadorId));
            }
            if (conceptoId != null) {
                predicates.add(cb.equal(root.get("conceptoId"), conceptoId));
            }
            if (flagEstado != null) {
                predicates.add(cb.equal(root.get("flagEstado"), flagEstado));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
