package pe.restaurant.almacen.spec;

import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.almacen.domain.ValeMovFlagEstado;
import pe.restaurant.almacen.entity.ValeMov;

import java.time.LocalDate;

public final class ValeMovSpecifications {

    private ValeMovSpecifications() {
    }

    public static Specification<ValeMov> conFiltros(Long sucursalId,
                                                    Long almacenId,
                                                    Long articuloMovTipoId,
                                                    String estado,
                                                    LocalDate fechaDesde,
                                                    LocalDate fechaHasta,
                                                    Long ordenCompraId,
                                                    Long ordenVentaId,
                                                    String tipoReferenciaOrigen) {
        return (root, query, cb) -> {
            var p = cb.conjunction();
            if (sucursalId != null) {
                p = cb.and(p, cb.equal(root.get("sucursalId"), sucursalId));
            }
            if (almacenId != null) {
                p = cb.and(p, cb.equal(root.get("almacenId"), almacenId));
            }
            if (articuloMovTipoId != null) {
                p = cb.and(p, cb.equal(root.get("articuloMovTipoId"), articuloMovTipoId));
            }
            if (estado != null && !estado.isBlank()) {
                String fe = ValeMovFlagEstado.fromFiltro(estado);
                if (fe != null) {
                    p = cb.and(p, cb.equal(root.get("flagEstado"), fe));
                }
            }
            if (fechaDesde != null) {
                p = cb.and(p, cb.greaterThanOrEqualTo(root.get("fechaMov"), fechaDesde));
            }
            if (fechaHasta != null) {
                p = cb.and(p, cb.lessThanOrEqualTo(root.get("fechaMov"), fechaHasta));
            }
            if (ordenCompraId != null) {
                p = cb.and(p, cb.equal(root.get("ordenCompraId"), ordenCompraId));
            }
            if (ordenVentaId != null) {
                p = cb.and(p, cb.equal(root.get("ordenVentaId"), ordenVentaId));
            }
            if (tipoReferenciaOrigen != null && !tipoReferenciaOrigen.isBlank()) {
                p = cb.and(p, cb.equal(root.get("tipoReferenciaOrigen"),
                        tipoReferenciaOrigen.trim().substring(0, 1).toUpperCase()));
            }
            return p;
        };
    }
}
