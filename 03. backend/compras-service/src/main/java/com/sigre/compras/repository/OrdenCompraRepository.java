package com.sigre.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import com.sigre.compras.entity.OrdenCompra;

import java.util.Optional;

public interface OrdenCompraRepository extends JpaRepository<OrdenCompra, Long>, JpaSpecificationExecutor<OrdenCompra> {

    @Query("SELECT DISTINCT d.ordenCompra FROM OrdenCompraDet d " +
           "WHERE d.referenciaSolCompraId = :solCompraId AND d.flagEstado = '1'")
    java.util.List<OrdenCompra> findBySolicitudCompraIdViaDetalle(@Param("solCompraId") Long solCompraId);

    @Query("SELECT oc FROM OrdenCompra oc LEFT JOIN FETCH oc.lineas WHERE oc.id = :id")
    Optional<OrdenCompra> findByIdWithLineas(@Param("id") Long id);
}
