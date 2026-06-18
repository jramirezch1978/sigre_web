package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.rrhh.entity.Contrato;

import java.util.List;
import java.util.Optional;

/**
 * Repositorio JPA para la entidad {@link Contrato}.
 * Gestiona contratos laborales como sub-recurso de un trabajador.
 */
@Repository
public interface ContratoRepository extends JpaRepository<Contrato, Long> {

    /** Lista todos los contratos de un trabajador ordenados por fecha de creación descendente. */
    List<Contrato> findByTrabajadorIdOrderByFecCreacionDesc(Long trabajadorId);

    /** Lista contratos de un trabajador filtrados por estado (activo/inactivo). */
    List<Contrato> findByTrabajadorIdAndFlagEstadoOrderByFecCreacionDesc(Long trabajadorId, String flagEstado);

    /** Busca un contrato por su ID verificando que pertenezca al trabajador indicado. */
    Optional<Contrato> findByIdAndTrabajadorId(Long id, Long trabajadorId);

    /** Verifica si el trabajador ya tiene un contrato en el estado indicado. */
    boolean existsByTrabajadorIdAndFlagEstado(Long trabajadorId, String flagEstado);

    /**
     * Desactiva en bloque todos los contratos activos de un trabajador.
     * Se usa al cesar o desactivar al trabajador (cascada lógica).
     */
    @Modifying
    @Query("UPDATE Contrato c SET c.flagEstado = '0', c.updatedBy = :userId, c.fecModificacion = CURRENT_TIMESTAMP "
            + "WHERE c.trabajadorId = :trabajadorId AND c.flagEstado = '1'")
    void desactivarTodosPorTrabajador(@Param("trabajadorId") Long trabajadorId, @Param("userId") Long userId);
}
