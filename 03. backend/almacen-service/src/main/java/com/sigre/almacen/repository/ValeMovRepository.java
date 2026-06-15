package com.sigre.almacen.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import com.sigre.almacen.entity.ValeMov;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

public interface ValeMovRepository extends JpaRepository<ValeMov, Long>, JpaSpecificationExecutor<ValeMov> {

    @Query("SELECT CASE WHEN COUNT(v) > 0 THEN true ELSE false END FROM ValeMov v "
            + "WHERE v.valeMovOrigId = :origId AND v.flagEstado <> '0'")
    boolean existeValeHijoReferenciandoOrigen(Long origId);

    List<ValeMov> findByAlmacenIdAndArticuloMovTipoIdAndFlagEstado(Long almacenId, Long articuloMovTipoId, String flagEstado);

    @Query("SELECT COALESCE(SUM(d.cantProcesada),0) FROM ValeMovDet d " +
            "WHERE d.valeMov.valeMovOrigId = :valeMovOrigId " +
            "AND d.articuloId = :articuloId " +
            "AND d.valeMov.flagEstado <> '0'")
    BigDecimal sumCantDevueltaPorArticulo(Long valeMovOrigId, Long articuloId);

    @Query(value = "SELECT oc.flag_estado FROM compras.orden_compra oc WHERE oc.id = :ordenCompraId", nativeQuery = true)
    String obtenerFlagEstadoOrdenCompra(Long ordenCompraId);

    @Query(value = "SELECT EXISTS(SELECT 1 FROM almacen.guia_remision gr " +
            "WHERE gr.vale_mov_id = :valeMovId AND gr.flag_estado = '1')", nativeQuery = true)
    boolean tieneGuiaRemisionActiva(Long valeMovId);

    @Query(value = "SELECT EXISTS(SELECT 1 FROM ventas.factura_det fd " +
            "INNER JOIN almacen.vale_mov_det vmd ON vmd.id = fd.vale_mov_det_id " +
            "WHERE vmd.vale_mov_id = :valeMovId AND fd.flag_estado = '1')", nativeQuery = true)
    boolean tieneCantidadFacturada(Long valeMovId);

    @Query(value = "SELECT EXISTS(SELECT 1 FROM almacen.consignacion c " +
            "WHERE c.vale_mov_id = :valeMovId AND c.flag_estado = '1')", nativeQuery = true)
    boolean tieneConsignacionActiva(Long valeMovId);

    @Query(value = "SELECT EXISTS(SELECT 1 FROM almacen.guia_recepcion_mp grm " +
            "WHERE grm.vale_mov_id = :valeMovId AND grm.flag_estado = '1')", nativeQuery = true)
    boolean tieneGuiaRecepcionMP(Long valeMovId);

    @Query(value = "SELECT EXISTS(SELECT 1 FROM produccion.parte_produccion_insumo ppi " +
            "WHERE ppi.vale_mov_id = :valeMovId AND ppi.flag_estado = '1')", nativeQuery = true)
    boolean tieneParteProduccionInsumoActivo(Long valeMovId);

    /**
     * Primer vale creado después de {@code despuesDeId} para la misma orden de traslado (p. ej. movimiento espejo).
     */
    Optional<ValeMov> findFirstByOrdenTrasladoIdAndIdGreaterThanOrderByIdAsc(Long ordenTrasladoId, Long despuesDeId);
}
