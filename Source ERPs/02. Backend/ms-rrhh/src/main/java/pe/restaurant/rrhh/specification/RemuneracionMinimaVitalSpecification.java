package pe.restaurant.rrhh.specification;

import jakarta.persistence.criteria.Predicate;
import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.rrhh.entity.RemuneracionMinimaVital;

import java.util.ArrayList;
import java.util.List;

public final class RemuneracionMinimaVitalSpecification {
    private RemuneracionMinimaVitalSpecification() { throw new UnsupportedOperationException(); }

    public static Specification<RemuneracionMinimaVital> filtros(Long tipoTrabajadorId, String flagEstado) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (tipoTrabajadorId != null) {
                predicates.add(cb.equal(root.get("tipoTrabajadorId"), tipoTrabajadorId));
            }
            if (flagEstado != null && !flagEstado.isEmpty()) {
                predicates.add(cb.equal(root.get("flagEstado"), flagEstado));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
