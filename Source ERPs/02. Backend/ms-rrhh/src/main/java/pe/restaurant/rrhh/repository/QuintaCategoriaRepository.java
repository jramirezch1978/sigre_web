package pe.restaurant.rrhh.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.rrhh.entity.QuintaCategoria;

import java.time.LocalDate;
import java.util.List;

/**
 * Repositorio JPA para {@link QuintaCategoria}.
 */
@Repository
public interface QuintaCategoriaRepository extends JpaRepository<QuintaCategoria, Long> {

    List<QuintaCategoria> findByFecProcesoBetween(LocalDate desde, LocalDate hasta);

    @Modifying
    @Query("""
            DELETE FROM QuintaCategoria q
            WHERE q.fecProceso >= :desde AND q.fecProceso <= :hasta
            """)
    void deleteByFecProcesoBetween(@Param("desde") LocalDate desde, @Param("hasta") LocalDate hasta);

    @Query("""
            SELECT q FROM QuintaCategoria q
            WHERE (:trabajadorId IS NULL OR q.trabajadorId = :trabajadorId)
              AND (:anio IS NULL OR EXTRACT(YEAR FROM q.fecProceso) = :anio)
              AND (:mes IS NULL OR EXTRACT(MONTH FROM q.fecProceso) = :mes)
            """)
    Page<QuintaCategoria> findWithFilters(
            @Param("trabajadorId") Long trabajadorId,
            @Param("anio") Integer anio,
            @Param("mes") Integer mes,
            Pageable pageable);
}
