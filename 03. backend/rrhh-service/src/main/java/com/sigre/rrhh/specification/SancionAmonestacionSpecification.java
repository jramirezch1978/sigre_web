package com.sigre.rrhh.specification;

import jakarta.persistence.criteria.Predicate;
import org.springframework.data.jpa.domain.Specification;
import com.sigre.rrhh.entity.SancionAmonestacion;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public final class SancionAmonestacionSpecification {
    private SancionAmonestacionSpecification() { throw new UnsupportedOperationException(); }

    public static Specification<SancionAmonestacion> filtros(Long trabajadorId, Long tipoSancionId,
                                                              LocalDate fechaDesde, LocalDate fechaHasta,
                                                              String flagEstado) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (trabajadorId != null) predicates.add(cb.equal(root.get("trabajadorId"), trabajadorId));
            if (tipoSancionId != null) predicates.add(cb.equal(root.get("tipoSancionId"), tipoSancionId));
            if (fechaDesde != null) predicates.add(cb.greaterThanOrEqualTo(root.get("fecha"), fechaDesde));
            if (fechaHasta != null) predicates.add(cb.lessThanOrEqualTo(root.get("fecha"), fechaHasta));
            if (flagEstado != null && !flagEstado.isEmpty()) predicates.add(cb.equal(root.get("flagEstado"), flagEstado));
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
