package com.sigre.comercializacion.repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.springframework.stereotype.Repository;

/**
 * Validaciones FK contra esquemas core/auth en BD tenant (sin nuevas entidades JPA).
 */
@Repository
public class VentasFkValidator {

    @PersistenceContext
    private EntityManager entityManager;

    private boolean existsCountGeOne(String sql, String param, Long id) {
        if (id == null) {
            return false;
        }
        Number n = (Number) entityManager.createNativeQuery(sql)
                .setParameter(param, id)
                .getSingleResult();
        return n != null && n.longValue() > 0;
    }

    public boolean existsSucursalActiva(Long sucursalId) {
        return existsCountGeOne(
                "SELECT COUNT(*) FROM auth.sucursal WHERE id = :id AND flag_estado = '1'", "id", sucursalId);
    }

    public boolean existsEntidadContribuyenteActiva(Long id) {
        return existsCountGeOne(
                "SELECT COUNT(*) FROM core.entidad_contribuyente WHERE id = :id AND flag_estado = '1'", "id", id);
    }

    public boolean existsDocTipoActivo(Long id) {
        return existsCountGeOne(
                "SELECT COUNT(*) FROM core.doc_tipo WHERE id = :id AND flag_estado = '1'", "id", id);
    }

    public boolean existsMonedaActiva(Long id) {
        return existsCountGeOne(
                "SELECT COUNT(*) FROM core.moneda WHERE id = :id AND flag_estado = '1'", "id", id);
    }

    public boolean existsUnidadMedidaActiva(Long id) {
        return existsCountGeOne(
                "SELECT COUNT(*) FROM core.unidad_medida WHERE id = :id AND flag_estado = '1'", "id", id);
    }

    public boolean existsPuntoVentaActivo(Long id, Long sucursalId) {
        if (id == null || sucursalId == null) {
            return false;
        }
        Number n = (Number) entityManager.createNativeQuery(
                        "SELECT COUNT(*) FROM ventas.punto_venta WHERE id = :id AND sucursal_id = :sid AND flag_estado = '1'")
                .setParameter("id", id)
                .setParameter("sid", sucursalId)
                .getSingleResult();
        return n != null && n.longValue() > 0;
    }

    public boolean existsFacturaTriplet(Long docTipoId, String serie, String numero, Long excludeId) {
        String sql = "SELECT COUNT(*) FROM ventas.fs_factura_simpl WHERE doc_tipo_id = :dt AND serie = :ser AND numero = :num "
                + "AND flag_estado = '1'";
        if (excludeId != null) {
            sql += " AND id <> :ex";
        }
        var q = entityManager.createNativeQuery(sql)
                .setParameter("dt", docTipoId)
                .setParameter("ser", serie)
                .setParameter("num", numero);
        if (excludeId != null) {
            q.setParameter("ex", excludeId);
        }
        Number n = (Number) q.getSingleResult();
        return n != null && n.longValue() > 0;
    }

    public boolean existsTrabajadorActivo(Long trabajadorId) {
        return existsCountGeOne(
                "SELECT COUNT(*) FROM rrhh.trabajador WHERE id = :id AND flag_estado = '1'", "id", trabajadorId);
    }

    public boolean existsMesaActiva(Long mesaId) {
        return existsCountGeOne(
                "SELECT COUNT(*) FROM ventas.mesa WHERE id = :id AND flag_estado = '1'", "id", mesaId);
    }

    /** Factura simplificada existe y no está anulada (flag_estado distinto de 0). */
    public boolean existsFsFacturaSimplNoAnulada(Long fsFacturaSimplId) {
        return existsCountGeOne(
                "SELECT COUNT(*) FROM ventas.fs_factura_simpl WHERE id = :id AND flag_estado <> '0'",
                "id", fsFacturaSimplId);
    }

    @SuppressWarnings("unchecked")
    public String findSucursalNombre(Long sucursalId) {
        if (sucursalId == null) {
            return null;
        }
        var list = entityManager.createNativeQuery("SELECT nombre FROM auth.sucursal WHERE id = :id")
                .setParameter("id", sucursalId)
                .getResultList();
        return list.isEmpty() ? null : (String) list.get(0);
    }

    @SuppressWarnings("unchecked")
    public String findEntidadRazonSocial(Long entidadId) {
        if (entidadId == null) {
            return null;
        }
        var list = entityManager.createNativeQuery("SELECT razon_social FROM core.entidad_contribuyente WHERE id = :id")
                .setParameter("id", entidadId)
                .getResultList();
        return list.isEmpty() ? null : (String) list.get(0);
    }

    @SuppressWarnings("unchecked")
    public String findEntidadRuc(Long entidadId) {
        if (entidadId == null) {
            return null;
        }
        var list = entityManager.createNativeQuery(
                        "SELECT nro_documento FROM core.entidad_contribuyente WHERE id = :id")
                .setParameter("id", entidadId)
                .getResultList();
        return list.isEmpty() ? null : (String) list.get(0);
    }

    @SuppressWarnings("unchecked")
    public String findMonedaSimbolo(Long monedaId) {
        if (monedaId == null) {
            return null;
        }
        var list = entityManager.createNativeQuery("SELECT simbolo FROM core.moneda WHERE id = :id")
                .setParameter("id", monedaId)
                .getResultList();
        return list.isEmpty() ? null : (String) list.get(0);
    }
}
