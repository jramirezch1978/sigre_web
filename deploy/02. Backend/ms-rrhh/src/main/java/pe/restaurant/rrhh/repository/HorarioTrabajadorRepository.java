package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.rrhh.entity.HorarioTrabajador;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * Repositorio JPA para la entidad {@link HorarioTrabajador}.
 * Gestiona asignaciones de turno como sub-recurso de un trabajador.
 */
@Repository
public interface HorarioTrabajadorRepository extends JpaRepository<HorarioTrabajador, Long> {

    /** Lista todos los horarios de un trabajador ordenados por fecha de creación descendente. */
    List<HorarioTrabajador> findByTrabajadorIdOrderByFecCreacionDesc(Long trabajadorId);

    /** Lista horarios de un trabajador filtrados por estado (activo/inactivo). */
    List<HorarioTrabajador> findByTrabajadorIdAndFlagEstadoOrderByFecCreacionDesc(Long trabajadorId, String flagEstado);

    /** Busca un horario por su ID verificando que pertenezca al trabajador indicado. */
    Optional<HorarioTrabajador> findByIdAndTrabajadorId(Long id, Long trabajadorId);

    /** Verifica si el trabajador ya tiene un horario en el estado indicado. */
    boolean existsByTrabajadorIdAndFlagEstado(Long trabajadorId, String flagEstado);

    /**
     * Detecta solapamiento de fechas con horarios activos del trabajador.
     * Excluye opcionalmente un horario por ID (para actualizaciones).
     * Un horario sin {@code fechaHasta} se considera vigente indefinidamente.
     */
    @Query("SELECT CASE WHEN COUNT(h) > 0 THEN true ELSE false END FROM HorarioTrabajador h "
            + "WHERE h.trabajadorId = :trabajadorId "
            + "AND h.flagEstado = '1' "
            + "AND (:excludeId IS NULL OR h.id <> :excludeId) "
            + "AND h.fechaDesde <= :fechaHasta "
            + "AND (h.fechaHasta IS NULL OR h.fechaHasta >= :fechaDesde)")
    boolean existsSolapamiento(
            @Param("trabajadorId") Long trabajadorId,
            @Param("fechaDesde") LocalDate fechaDesde,
            @Param("fechaHasta") LocalDate fechaHasta,
            @Param("excludeId") Long excludeId);

    /**
     * Desactiva en bloque todos los horarios activos de un trabajador.
     * Se usa al cesar o desactivar al trabajador (cascada lógica).
     */
    @Modifying
    @Query("UPDATE HorarioTrabajador h SET h.flagEstado = '0', h.updatedBy = :userId, h.fecModificacion = CURRENT_TIMESTAMP "
            + "WHERE h.trabajadorId = :trabajadorId AND h.flagEstado = '1'")
    void desactivarTodosPorTrabajador(@Param("trabajadorId") Long trabajadorId, @Param("userId") Long userId);

    /** Verifica si existen horarios asignados a un turno específfico con estado activo. */
    boolean existsByTurnoIdAndFlagEstado(Long turnoId, String flagEstado);
}
