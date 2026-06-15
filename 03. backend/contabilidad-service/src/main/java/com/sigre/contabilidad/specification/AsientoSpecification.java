package com.sigre.contabilidad.specification;

import jakarta.persistence.criteria.*;
import org.springframework.data.jpa.domain.Specification;
import com.sigre.contabilidad.entity.CntblAsiento;
import com.sigre.contabilidad.entity.CntblAsientoDet;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class AsientoSpecification {

    public static Specification<CntblAsiento> conFiltros(
            LocalDate fechaDesde,
            LocalDate fechaHasta,
            Long cuentaContableId,
            String naturalezaAsiento,
            String flagEstado) {

        return (Root<CntblAsiento> root, CriteriaQuery<?> query, CriteriaBuilder cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (fechaDesde != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("fecha"), fechaDesde));
            }

            if (fechaHasta != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("fecha"), fechaHasta));
            }

            if (naturalezaAsiento != null && !naturalezaAsiento.isEmpty()) {
                predicates.add(cb.equal(root.get("naturalezaAsiento"), naturalezaAsiento));
            }

            if (flagEstado != null && !flagEstado.isEmpty()) {
                predicates.add(cb.equal(root.get("flagEstado"), flagEstado));
            }

            if (cuentaContableId != null) {
                Join<CntblAsiento, CntblAsientoDet> detallesJoin = root.join("detalles", JoinType.INNER);
                predicates.add(cb.equal(detallesJoin.get("planContableDetId"), cuentaContableId));
                query.distinct(true);
            }

            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
