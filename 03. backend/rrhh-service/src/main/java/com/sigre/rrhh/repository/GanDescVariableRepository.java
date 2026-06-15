package com.sigre.rrhh.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.sigre.rrhh.entity.GanDescVariable;

/**
 * Repositorio JPA para la entidad {@link GanDescVariable}.
 * Incluye consulta de filtrado paginado con parámetros opcionales.
 */
@Repository
public interface GanDescVariableRepository extends JpaRepository<GanDescVariable, Long> {

    /**
     * Listado paginado con filtros opcionales (todos nullable).
     * Filtra por trabajador, concepto, año/mes de la fecha de movimiento y tipo de planilla.
     */
    @Query("SELECT g FROM GanDescVariable g WHERE "
            + "(:trabajadorId IS NULL OR g.trabajadorId = :trabajadorId) "
            + "AND (:conceptoId IS NULL OR g.conceptoId = :conceptoId) "
            + "AND (:anio IS NULL OR EXTRACT(YEAR FROM g.fecMovim) = :anio) "
            + "AND (:mes IS NULL OR EXTRACT(MONTH FROM g.fecMovim) = :mes) "
            + "AND (:tipoPlanillaId IS NULL OR g.tipoPlanillaId = :tipoPlanillaId)")
    Page<GanDescVariable> findWithFilters(
            @Param("trabajadorId") Long trabajadorId,
            @Param("conceptoId") Long conceptoId,
            @Param("anio") Integer anio,
            @Param("mes") Integer mes,
            @Param("tipoPlanillaId") Long tipoPlanillaId,
            Pageable pageable);

    /** Valida existencia de tipo de planilla en esquema {@code rrhh}. */
    @Query(value = "SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END FROM rrhh.tipo_planilla WHERE id = :id", nativeQuery = true)
    boolean existsTipoPlanillaById(@Param("id") Long id);

    /** Obtiene el nombre del tipo de planilla por ID para resolver FK en responses. */
    @Query(value = "SELECT nombre FROM rrhh.tipo_planilla WHERE id = :id", nativeQuery = true)
    String findTipoPlanillaNombreById(@Param("id") Long id);
}
