package com.sigre.rrhh.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.sigre.rrhh.entity.Liquidacion;

import java.time.LocalDate;

/**
 * Repositorio JPA para la entidad {@link Liquidacion}.
 * Gestiona las liquidaciones de beneficios sociales por cese de trabajadores.
 */
@Repository
public interface LiquidacionRepository extends JpaRepository<Liquidacion, Long> {

    /**
     * Verifica si ya existe una liquidación activa (no anulada, {@code flag_estado != '0'})
     * para el mismo trabajador y fecha de cese.
     *
     * @param trabajadorId ID del trabajador
     * @param fechaCese    fecha de cese
     * @return {@code true} si existe al menos una liquidación no anulada
     */
    @Query("SELECT CASE WHEN COUNT(l) > 0 THEN true ELSE false END FROM Liquidacion l "
            + "WHERE l.trabajadorId = :trabajadorId AND l.fechaCese = :fechaCese AND l.flagEstado <> '0'")
    boolean existsActivaByTrabajadorAndFecha(@Param("trabajadorId") Long trabajadorId,
                                             @Param("fechaCese") LocalDate fechaCese);

    /**
     * Listado paginado con filtros opcionales (todos nullable).
     * El rango de fechas aplica sobre {@code fecha_cese}.
     *
     * @param trabajadorId filtro exacto por trabajador
     * @param flagEstado   filtro por estado ('1' pendiente, '2' aprobada, '0' anulada)
     * @param fechaDesde   límite inferior de fecha de cese (inclusive)
     * @param fechaHasta   límite superior de fecha de cese (inclusive)
     * @param pageable     paginación
     * @return página de liquidaciones
     */
    @Query("SELECT l FROM Liquidacion l WHERE "
            + "(:trabajadorId IS NULL OR l.trabajadorId = :trabajadorId) "
            + "AND (:flagEstado IS NULL OR :flagEstado = '' OR l.flagEstado = :flagEstado) "
            + "AND (:fechaDesde IS NULL OR l.fechaCese >= :fechaDesde) "
            + "AND (:fechaHasta IS NULL OR l.fechaCese <= :fechaHasta)")
    Page<Liquidacion> findWithFilters(
            @Param("trabajadorId") Long trabajadorId,
            @Param("flagEstado") String flagEstado,
            @Param("fechaDesde") LocalDate fechaDesde,
            @Param("fechaHasta") LocalDate fechaHasta,
            Pageable pageable);
}
