package pe.restaurant.rrhh.specification;

import jakarta.persistence.criteria.Predicate;
import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.rrhh.entity.NovedadRrhh;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public final class NovedadRrhhSpecification {
    private NovedadRrhhSpecification() { throw new UnsupportedOperationException(); }

    public static Specification<NovedadRrhh> filtros(Long trabajadorId, Long tipoNovedadRrhhId,
                                                      LocalDate fechaDesde, LocalDate fechaHasta, String flagEstado) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (trabajadorId != null) predicates.add(cb.equal(root.get("trabajadorId"), trabajadorId));
            if (tipoNovedadRrhhId != null) predicates.add(cb.equal(root.get("tipoNovedadRrhhId"), tipoNovedadRrhhId));
            if (fechaDesde != null) predicates.add(cb.greaterThanOrEqualTo(root.get("fechaIni"), fechaDesde));
            if (fechaHasta != null) predicates.add(cb.lessThanOrEqualTo(root.get("fechaFin"), fechaHasta));
            if (flagEstado != null && !flagEstado.isEmpty()) predicates.add(cb.equal(root.get("flagEstado"), flagEstado));
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
