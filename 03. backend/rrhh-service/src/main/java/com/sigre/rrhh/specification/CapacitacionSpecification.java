package com.sigre.rrhh.specification;

import jakarta.persistence.criteria.Predicate;
import org.springframework.data.jpa.domain.Specification;
import com.sigre.rrhh.entity.Capacitacion;
import java.util.ArrayList;
import java.util.List;

public final class CapacitacionSpecification {
    private CapacitacionSpecification() { throw new UnsupportedOperationException(); }

    public static Specification<Capacitacion> filtros(String nombre, String flagEstado) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (nombre != null && !nombre.isEmpty())
                predicates.add(cb.like(cb.lower(root.get("nombre")), "%" + nombre.toLowerCase() + "%"));
            if (flagEstado != null && !flagEstado.isEmpty())
                predicates.add(cb.equal(root.get("flagEstado"), flagEstado));
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
