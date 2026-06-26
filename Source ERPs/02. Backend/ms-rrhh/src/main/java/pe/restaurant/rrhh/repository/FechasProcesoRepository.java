package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.rrhh.entity.FechasProceso;

import java.time.LocalDate;
import java.util.Optional;

@Repository
public interface FechasProcesoRepository extends JpaRepository<FechasProceso, Long> {

    /**
     * Busca el período para una combinación origen + fec_proceso + tipo_trabajador + tipo_planilla.
     * Equivale al SELECT de validación del SP principal de SIGRE.
     */
    Optional<FechasProceso> findByOrigenAndFecProcesoAndTipoTrabajadorIdAndTipoPlanillaId(
            String origen, LocalDate fecProceso, Long tipoTrabajadorId, Long tipoPlanillaId);

    /** Verifica existencia del período (validación de entrada del motor). */
    boolean existsByOrigenAndFecProcesoAndTipoTrabajadorId(
            String origen, LocalDate fecProceso, Long tipoTrabajadorId);

    @Query("SELECT fp FROM FechasProceso fp " +
           "WHERE fp.origen = :origen AND fp.fecProceso = :fecProceso " +
           "AND fp.tipoTrabajadorId = :tipoTrabajadorId " +
           "ORDER BY fp.tipoPlanillaId ASC")
    java.util.List<FechasProceso> findByOrigenFecProcesoTipoTrabajador(
            @Param("origen") String origen,
            @Param("fecProceso") LocalDate fecProceso,
            @Param("tipoTrabajadorId") Long tipoTrabajadorId);
}
