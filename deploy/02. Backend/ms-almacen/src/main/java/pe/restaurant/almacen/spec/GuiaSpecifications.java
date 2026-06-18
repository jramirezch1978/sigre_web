package pe.restaurant.almacen.spec;

import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.almacen.entity.Guia;

import java.time.LocalDate;

public final class GuiaSpecifications {

    private GuiaSpecifications() {
    }

    public static Specification<Guia> conFiltros(Long sucursalId,
                                                 String estado,
                                                 String serie,
                                                 String numero,
                                                 LocalDate fechaDesde,
                                                 LocalDate fechaHasta,
                                                 Long destinatarioId) {
        return (root, query, cb) -> {
            var p = cb.conjunction();
            if (sucursalId != null) {
                p = cb.and(p, cb.equal(root.get("sucursalId"), sucursalId));
            }
            if (estado != null && !estado.isBlank()) {
                p = cb.and(p, cb.equal(root.get("flagEstado"), estado.trim()));
            }
            if (serie != null && !serie.isBlank()) {
                p = cb.and(p, cb.equal(root.get("serie"), serie.trim()));
            }
            if (numero != null && !numero.isBlank()) {
                p = cb.and(p, cb.equal(root.get("numero"), numero.trim()));
            }
            if (fechaDesde != null) {
                p = cb.and(p, cb.greaterThanOrEqualTo(root.get("fechaEmision"), fechaDesde));
            }
            if (fechaHasta != null) {
                p = cb.and(p, cb.lessThanOrEqualTo(root.get("fechaEmision"), fechaHasta));
            }
            if (destinatarioId != null) {
                p = cb.and(p, cb.equal(root.get("destinatarioId"), destinatarioId));
            }
            return p;
        };
    }
}
