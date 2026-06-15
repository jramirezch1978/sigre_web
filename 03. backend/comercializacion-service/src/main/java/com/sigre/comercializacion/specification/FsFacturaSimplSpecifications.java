package com.sigre.comercializacion.specification;

import jakarta.persistence.criteria.Predicate;
import org.springframework.data.jpa.domain.Specification;
import com.sigre.comercializacion.entity.FsFacturaSimpl;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public final class FsFacturaSimplSpecifications {

    private FsFacturaSimplSpecifications() {}

    public static Specification<FsFacturaSimpl> filtered(
            Long sucursalId,
            Long clienteId,
            Long docTipoId,
            String serieContains,
            String numeroContains,
            String flagEstado,
            LocalDate fechaDesde,
            LocalDate fechaHasta) {

        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (sucursalId != null) {
                predicates.add(cb.equal(root.get("sucursalId"), sucursalId));
            }
            if (clienteId != null) {
                predicates.add(cb.equal(root.get("clienteId"), clienteId));
            }
            if (docTipoId != null) {
                predicates.add(cb.equal(root.get("docTipoId"), docTipoId));
            }
            if (serieContains != null && !serieContains.isBlank()) {
                String pattern = "%" + serieContains.toLowerCase(Locale.ROOT) + "%";
                predicates.add(cb.like(cb.lower(root.get("serie")), pattern));
            }
            if (numeroContains != null && !numeroContains.isBlank()) {
                String pattern = "%" + numeroContains.toLowerCase(Locale.ROOT) + "%";
                predicates.add(cb.like(cb.lower(root.get("numero")), pattern));
            }
            if (flagEstado != null && !flagEstado.isBlank()) {
                predicates.add(cb.equal(root.get("flagEstado"), flagEstado));
            }
            if (fechaDesde != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("fechaEmision"), fechaDesde));
            }
            if (fechaHasta != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("fechaEmision"), fechaHasta));
            }

            if (predicates.isEmpty()) {
                return cb.conjunction();
            }
            return cb.and(predicates.toArray(Predicate[]::new));
        };
    }
}
