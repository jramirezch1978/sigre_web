package com.sigre.comercializacion.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.sigre.comercializacion.entity.OrdenVenta;

import java.util.Optional;

@Repository
public interface OrdenVentaRepository extends JpaRepository<OrdenVenta, Long> {

    boolean existsByNroOrdenVenta(String nroOrdenVenta);

    @EntityGraph(attributePaths = "detalles")
    @Query("SELECT o FROM OrdenVenta o WHERE o.id = :id")
    Optional<OrdenVenta> findByIdWithDetalles(@Param("id") Long id);

    @EntityGraph(attributePaths = "detalles")
    @Query("SELECT o FROM OrdenVenta o WHERE " +
            "(:sucursalId IS NULL OR o.sucursalId = :sucursalId) AND " +
            "(:clienteId IS NULL OR o.clienteId = :clienteId) AND " +
            "(:nro IS NULL OR :nro = '' OR LOWER(o.nroOrdenVenta) LIKE LOWER(CONCAT('%', :nro, '%')))")
    Page<OrdenVenta> findWithFilters(
            @Param("sucursalId") Long sucursalId,
            @Param("clienteId") Long clienteId,
            @Param("nro") String nro,
            Pageable pageable);
}
