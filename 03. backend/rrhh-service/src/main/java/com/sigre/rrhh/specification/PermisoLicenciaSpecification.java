package com.sigre.rrhh.specification;

import jakarta.persistence.criteria.Predicate;
import org.springframework.data.jpa.domain.Specification;
import com.sigre.rrhh.entity.PermisoLicencia;
import com.sigre.rrhh.util.RrhhFlagEstadoLegacyNormalizer;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public final class PermisoLicenciaSpecification {

    private PermisoLicenciaSpecification() {
        throw new UnsupportedOperationException("Clase de specification — no instanciable");
    }

    public static Specification<PermisoLicencia> filtros(Long trabajadorId, LocalDate fechaDesde,
                                                          LocalDate fechaHasta, String flagEstado) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (trabajadorId != null) {
                predicates.add(cb.equal(root.get("trabajadorId"), trabajadorId));
            }
            if (fechaDesde != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("fechaInicio"), fechaDesde));
            }
            if (fechaHasta != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("fechaFin"), fechaHasta));
            }
            if (flagEstado != null && !flagEstado.isEmpty()) {
                var valores = RrhhFlagEstadoLegacyNormalizer.permisoFlagEstadosParaFiltro(flagEstado);
                predicates.add(root.get("flagEstado").in(valores));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
