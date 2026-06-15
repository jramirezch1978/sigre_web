package com.sigre.almacen.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import com.sigre.almacen.entity.LotePallet;

import java.time.LocalDate;

public interface LotePalletRepository extends JpaRepository<LotePallet, Long> {

    @Query("SELECT l FROM LotePallet l WHERE " +
            "(:almacenId IS NULL OR l.almacenId = :almacenId) AND " +
            "(:articuloId IS NULL OR l.articuloId = :articuloId)")
    Page<LotePallet> findFiltrado(
            @Param("almacenId") Long almacenId,
            @Param("articuloId") Long articuloId,
            Pageable pageable);

    /** Lotes activos con vencimiento hasta una fecha tope, ordenados por el más próximo. */
    @Query("""
            SELECT l FROM LotePallet l
            WHERE l.flagEstado = '1'
              AND l.fechaVencimiento IS NOT NULL
              AND l.fechaVencimiento <= :hasta
              AND (:almacenId IS NULL OR l.almacenId = :almacenId)
              AND (:articuloId IS NULL OR l.articuloId = :articuloId)
            ORDER BY l.fechaVencimiento ASC
            """)
    Page<LotePallet> buscarPorVencer(
            @Param("almacenId") Long almacenId,
            @Param("articuloId") Long articuloId,
            @Param("hasta") LocalDate hasta,
            Pageable pageable);

    boolean existsByAlmacenIdAndArticuloIdAndNroLoteIgnoreCase(Long almacenId, Long articuloId, String nroLote);

    boolean existsByAlmacenIdAndArticuloIdAndNroLoteIgnoreCaseAndIdNot(
            Long almacenId, Long articuloId, String nroLote, Long id);
}
