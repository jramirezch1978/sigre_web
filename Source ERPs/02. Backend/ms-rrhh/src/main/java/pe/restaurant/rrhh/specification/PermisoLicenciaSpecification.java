package pe.restaurant.rrhh.specification;

import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Subquery;
import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.rrhh.entity.PermisoLicencia;
import pe.restaurant.rrhh.entity.PermisoLicenciaDet;
import pe.restaurant.rrhh.util.RrhhFlagEstadoLegacyNormalizer;

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
            if (fechaDesde != null || fechaHasta != null) {
                Subquery<Long> sub = query.subquery(Long.class);
                var detRoot = sub.from(PermisoLicenciaDet.class);
                sub.select(detRoot.get("permisoLicenciaId"));
                List<Predicate> subPredicates = new ArrayList<>();
                subPredicates.add(cb.equal(detRoot.get("permisoLicenciaId"), root.get("id")));
                if (fechaDesde != null) {
                    subPredicates.add(cb.greaterThanOrEqualTo(detRoot.get("fechaInicio"), fechaDesde));
                }
                if (fechaHasta != null) {
                    subPredicates.add(cb.or(
                            cb.isNull(detRoot.get("fechaFin")),
                            cb.lessThanOrEqualTo(detRoot.get("fechaFin"), fechaHasta)
                    ));
                }
                sub.where(subPredicates.toArray(new Predicate[0]));
                predicates.add(cb.exists(sub));
            }
            if (flagEstado != null && !flagEstado.isEmpty()) {
                var valores = RrhhFlagEstadoLegacyNormalizer.permisoFlagEstadosParaFiltro(flagEstado);
                predicates.add(root.get("flagEstado").in(valores));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
