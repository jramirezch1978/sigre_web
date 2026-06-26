package pe.restaurant.rrhh.specification;

import jakarta.persistence.criteria.Predicate;
import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.rrhh.entity.OcupacionRtps;
import java.util.ArrayList;
import java.util.List;

public final class OcupacionRtpsSpecification {
    private OcupacionRtpsSpecification() { throw new UnsupportedOperationException(); }

    public static Specification<OcupacionRtps> filtros(String codigo, String nombre, String flagEstado) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            if (codigo != null && !codigo.isEmpty())
                predicates.add(cb.like(cb.lower(root.get("codigo")), "%" + codigo.toLowerCase() + "%"));
            if (nombre != null && !nombre.isEmpty())
                predicates.add(cb.like(cb.lower(root.get("nombre")), "%" + nombre.toLowerCase() + "%"));
            if (flagEstado != null && !flagEstado.isEmpty())
                predicates.add(cb.equal(root.get("flagEstado"), flagEstado));
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
