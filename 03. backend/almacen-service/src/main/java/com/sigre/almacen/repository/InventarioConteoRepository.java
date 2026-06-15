package com.sigre.almacen.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import com.sigre.almacen.entity.InventarioConteo;

import java.time.LocalDate;

public interface InventarioConteoRepository extends JpaRepository<InventarioConteo, Long>,
        JpaSpecificationExecutor<InventarioConteo> {

    Page<InventarioConteo> findByAlmacenId(Long almacenId, Pageable pageable);

    /** Comparación físico vs sistema (conteos) filtrable por almacén, artículo y rango de fechas. */
    @Query("""
            SELECT c FROM InventarioConteo c
            WHERE (:almacenId IS NULL OR c.almacenId = :almacenId)
              AND (:articuloId IS NULL OR c.articuloId = :articuloId)
              AND (:fechaDesde IS NULL OR c.fechaConteo >= :fechaDesde)
              AND (:fechaHasta IS NULL OR c.fechaConteo <= :fechaHasta)
            """)
    Page<InventarioConteo> comparacion(@Param("almacenId") Long almacenId,
                                       @Param("articuloId") Long articuloId,
                                       @Param("fechaDesde") LocalDate fechaDesde,
                                       @Param("fechaHasta") LocalDate fechaHasta,
                                       Pageable pageable);
}
