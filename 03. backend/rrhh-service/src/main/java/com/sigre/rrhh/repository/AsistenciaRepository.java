package com.sigre.rrhh.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.sigre.rrhh.entity.Asistencia;

import java.time.LocalDate;
import java.util.List;

/**
 * Repositorio JPA para la entidad {@link Asistencia}.
 * Incluye consulta paginada con filtros y validaciones de unicidad.
 */
@Repository
public interface AsistenciaRepository extends JpaRepository<Asistencia, Long> {

    /**
     * Listado paginado con filtros opcionales (todos nullable).
     * Permite filtrar por trabajador, rango de fechas y tipo de marca.
     */
    @Query(value = "SELECT * FROM rrhh.asistencia a WHERE a.flag_estado = '1' "
            + "AND (CAST(:trabajadorId AS BIGINT) IS NULL OR a.trabajador_id = CAST(:trabajadorId AS BIGINT)) "
            + "AND (CAST(:fechaDesde AS DATE) IS NULL OR a.fecha >= CAST(:fechaDesde AS DATE)) "
            + "AND (CAST(:fechaHasta AS DATE) IS NULL OR a.fecha <= CAST(:fechaHasta AS DATE)) "
            + "AND (CAST(:tipoMovAsistenciaId AS BIGINT) IS NULL OR a.tipo_mov_asistencia_id = CAST(:tipoMovAsistenciaId AS BIGINT)) "
            + "ORDER BY a.fecha DESC, a.hora_entrada DESC",
            nativeQuery = true)
    Page<Asistencia> findWithFilters(
            @Param("trabajadorId") Long trabajadorId,
            @Param("fechaDesde") LocalDate fechaDesde,
            @Param("fechaHasta") LocalDate fechaHasta,
            @Param("tipoMovAsistenciaId") Long tipoMovAsistenciaId,
            Pageable pageable);

    /**
     * Verifica si ya existe un registro de asistencia para
     * el mismo trabajador en la misma fecha (RH-AS-002).
     */
    boolean existsByTrabajadorIdAndFechaAndFlagEstado(Long trabajadorId, LocalDate fecha, String flagEstado);

    /**
     * Verifica duplicidad excluyendo el registro que se está editando (RH-AS-002).
     */
    boolean existsByTrabajadorIdAndFechaAndFlagEstadoAndIdNot(Long trabajadorId, LocalDate fecha, String flagEstado, Long id);

    /**
     * Obtiene nombres completos del trabajador para resolver FK en responses.
     */
    @Query(value = "SELECT CONCAT(nombres, ' ', COALESCE(apellido_paterno, ''), ' ', COALESCE(apellido_materno, '')) "
            + "FROM rrhh.trabajador WHERE id = :id", nativeQuery = true)
    String findTrabajadorNombresById(@Param("id") Long id);

    /** Valida existencia de tipo de movimiento de asistencia en esquema {@code rrhh}. */
    @Query(value = "SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END FROM rrhh.tipo_mov_asistencia WHERE id = :id", nativeQuery = true)
    boolean existsTipoMovAsistenciaById(@Param("id") Long id);

    /** Obtiene el nombre del tipo de movimiento de asistencia por ID para resolver FK en responses. */
    @Query(value = "SELECT nombre FROM rrhh.tipo_mov_asistencia WHERE id = :id", nativeQuery = true)
    String findTipoMovAsistenciaNombreById(@Param("id") Long id);
    String findTipoMovAsistenciaCodigoById(@Param("id") Long id);

    List<Asistencia> findByFechaBetween(LocalDate fechaDesde, LocalDate fechaHasta);

    @Modifying
    @Query(value = "UPDATE rrhh.asistencia SET flag_estado = :estado, updated_by = :userId, fec_modificacion = NOW() WHERE fecha BETWEEN :fechaDesde AND :fechaHasta", nativeQuery = true)
    int actualizarEstadoPorRangoFechas(@Param("fechaDesde") LocalDate fechaDesde, @Param("fechaHasta") LocalDate fechaHasta, @Param("estado") String estado, @Param("userId") Long userId);
}
