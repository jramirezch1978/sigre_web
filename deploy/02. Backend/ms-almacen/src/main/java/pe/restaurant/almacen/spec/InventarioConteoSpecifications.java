package pe.restaurant.almacen.spec;

import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.almacen.entity.InventarioConteo;

import java.time.LocalDate;

public final class InventarioConteoSpecifications {

    private InventarioConteoSpecifications() {
    }

    public static Specification<InventarioConteo> conFiltros(Long almacenId,
                                                             Long articuloId,
                                                             String estado,
                                                             LocalDate fechaDesde,
                                                             LocalDate fechaHasta) {
        return (root, query, cb) -> {
            var p = cb.conjunction();
            if (almacenId != null) {
                p = cb.and(p, cb.equal(root.get("almacenId"), almacenId));
            }
            if (articuloId != null) {
                p = cb.and(p, cb.equal(root.get("articuloId"), articuloId));
            }
            if (estado != null && !estado.isBlank()) {
                p = cb.and(p, cb.equal(root.get("flagEstado"), estado.trim()));
            }
            if (fechaDesde != null) {
                p = cb.and(p, cb.greaterThanOrEqualTo(root.get("fechaConteo"), fechaDesde));
            }
            if (fechaHasta != null) {
                p = cb.and(p, cb.lessThanOrEqualTo(root.get("fechaConteo"), fechaHasta));
            }
            return p;
        };
    }
}
