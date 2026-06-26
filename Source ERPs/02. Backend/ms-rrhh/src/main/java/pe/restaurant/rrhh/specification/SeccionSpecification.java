package pe.restaurant.rrhh.specification;

import jakarta.persistence.criteria.Predicate;
import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.rrhh.entity.Seccion;
import java.util.ArrayList;
import java.util.List;

public final class SeccionSpecification {
    private SeccionSpecification() { throw new UnsupportedOperationException(); }

    public static Specification<Seccion> filtros(String codigo, String nombre, String flagEstado) {
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
