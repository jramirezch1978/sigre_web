package com.sigre.almacen.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import com.sigre.almacen.entity.ArticuloAlmacen;

import java.util.List;
import java.util.Optional;

public interface ArticuloAlmacenRepository extends JpaRepository<ArticuloAlmacen, Long> {

    Optional<ArticuloAlmacen> findByAlmacenIdAndArticuloId(Long almacenId, Long articuloId);

    @Query("""
            SELECT a FROM ArticuloAlmacen a
            WHERE (:almacenId IS NULL OR a.almacenId = :almacenId)
              AND (:articuloId IS NULL OR a.articuloId = :articuloId)
            """)
    Page<ArticuloAlmacen> buscarStock(@Param("almacenId") Long almacenId,
                                      @Param("articuloId") Long articuloId,
                                      Pageable pageable);

    /**
     * Diagnóstico por almacén: {@code [almacenId, totalArticulos, totalUnidades,
     * valorInventario]}.
     * <p>Equivale a Oracle SIGRE: {@code SUM(aa.sldo_total * aa.costo_prom_sol)}
     * sobre {@code articulo_almacen} con saldo &gt; 0.</p>
     */
    @Query("""
            SELECT a.almacenId,
                   COUNT(a),
                   COALESCE(SUM(a.cantidadDisponible), 0),
                   COALESCE(SUM(a.cantidadDisponible * a.costoPromedio), 0)
            FROM ArticuloAlmacen a
            WHERE a.cantidadDisponible > 0
              AND (:almacenId IS NULL OR a.almacenId = :almacenId)
            GROUP BY a.almacenId
            ORDER BY 4 DESC, a.almacenId
            """)
    List<Object[]> diagnosticoPorAlmacen(@Param("almacenId") Long almacenId);
}
