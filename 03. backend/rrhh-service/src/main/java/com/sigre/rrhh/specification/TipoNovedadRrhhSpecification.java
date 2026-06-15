package com.sigre.rrhh.specification;

import org.springframework.data.jpa.domain.Specification;
import com.sigre.rrhh.entity.TipoNovedadRrhh;

public class TipoNovedadRrhhSpecification {

    private TipoNovedadRrhhSpecification() {
        throw new UnsupportedOperationException("Clase de especificaciones — no instanciable");
    }

    public static Specification<TipoNovedadRrhh> codigoContains(String codigo) {
        if (codigo == null || codigo.isEmpty()) return null;
        return (root, query, cb) ->
            cb.like(cb.lower(root.get("codigo")), "%" + codigo.toLowerCase() + "%");
    }

    public static Specification<TipoNovedadRrhh> nombreContains(String nombre) {
        if (nombre == null || nombre.isEmpty()) return null;
        return (root, query, cb) ->
            cb.like(cb.lower(root.get("nombre")), "%" + nombre.toLowerCase() + "%");
    }

    public static Specification<TipoNovedadRrhh> flagEstadoEquals(String flagEstado) {
        if (flagEstado == null || flagEstado.isEmpty()) return null;
        return (root, query, cb) ->
            cb.equal(root.get("flagEstado"), flagEstado);
    }
}
