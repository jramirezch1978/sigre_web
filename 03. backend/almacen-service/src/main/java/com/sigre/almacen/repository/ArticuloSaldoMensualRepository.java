package com.sigre.almacen.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import com.sigre.almacen.entity.ArticuloSaldoMensual;

import java.time.LocalDate;
import java.util.List;

public interface ArticuloSaldoMensualRepository extends JpaRepository<ArticuloSaldoMensual, Long> {

    List<ArticuloSaldoMensual> findByValeMovDetId(Long valeMovDetId);

    void deleteByValeMovDetId(Long valeMovDetId);

    /** Kardex: asientos valorizados filtrables por almacén, artículo y rango de fechas. */
    @Query("""
            SELECT s FROM ArticuloSaldoMensual s
            WHERE (:almacenId IS NULL OR s.almacenId = :almacenId)
              AND (:articuloId IS NULL OR s.articuloId = :articuloId)
              AND (:fechaDesde IS NULL OR s.fecha >= :fechaDesde)
              AND (:fechaHasta IS NULL OR s.fecha <= :fechaHasta)
            """)
    Page<ArticuloSaldoMensual> buscarKardex(@Param("almacenId") Long almacenId,
                                            @Param("articuloId") Long articuloId,
                                            @Param("fechaDesde") LocalDate fechaDesde,
                                            @Param("fechaHasta") LocalDate fechaHasta,
                                            Pageable pageable);

    /**
     * Stock a una fecha de corte: por cada (almacén, artículo) toma el saldo del
     * último asiento (mayor id) cuya fecha sea &lt;= :fecha.
     */
    @Query("""
            SELECT s FROM ArticuloSaldoMensual s
            WHERE s.fecha <= :fecha
              AND (:almacenId IS NULL OR s.almacenId = :almacenId)
              AND (:articuloId IS NULL OR s.articuloId = :articuloId)
              AND s.id = (
                  SELECT MAX(s2.id) FROM ArticuloSaldoMensual s2
                  WHERE s2.almacenId = s.almacenId
                    AND s2.articuloId = s.articuloId
                    AND s2.fecha <= :fecha
              )
            """)
    Page<ArticuloSaldoMensual> stockAFecha(@Param("almacenId") Long almacenId,
                                           @Param("articuloId") Long articuloId,
                                           @Param("fecha") LocalDate fecha,
                                           Pageable pageable);
}
