package com.sigre.rrhh.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.sigre.rrhh.entity.QuintaCategoria;

import java.util.List;

/**
 * Repositorio JPA para la entidad {@link QuintaCategoria}.
 * Gestiona los cálculos de retención de quinta categoría por trabajador y período.
 */
@Repository
public interface QuintaCategoriaRepository extends JpaRepository<QuintaCategoria, Long> {

    /** Lista todos los registros de un período (año/mes). */
    List<QuintaCategoria> findByAnioAndMes(Integer anio, Integer mes);

    /**
     * Elimina todos los registros de un período (año/mes).
     * Se usa para reprocesar de forma idempotente.
     */
    @Modifying
    @Query("DELETE FROM QuintaCategoria q WHERE q.anio = :anio AND q.mes = :mes")
    void deleteByAnioAndMes(@Param("anio") Integer anio, @Param("mes") Integer mes);

    /**
     * Listado paginado con filtros opcionales (todos nullable).
     */
    @Query("SELECT q FROM QuintaCategoria q WHERE "
            + "(:trabajadorId IS NULL OR q.trabajadorId = :trabajadorId) "
            + "AND (:anio IS NULL OR q.anio = :anio) "
            + "AND (:mes IS NULL OR q.mes = :mes)")
    Page<QuintaCategoria> findWithFilters(
            @Param("trabajadorId") Long trabajadorId,
            @Param("anio") Integer anio,
            @Param("mes") Integer mes,
            Pageable pageable);
}
