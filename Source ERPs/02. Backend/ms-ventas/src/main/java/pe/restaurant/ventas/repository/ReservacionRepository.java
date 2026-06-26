package pe.restaurant.ventas.repository;

import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.ventas.entity.Reservacion;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Optional;

@Repository
public interface ReservacionRepository extends JpaRepository<Reservacion, Long>, JpaSpecificationExecutor<Reservacion> {

    @EntityGraph(attributePaths = {"items"})
    @Query("SELECT r FROM Reservacion r WHERE r.id = :id")
    Optional<Reservacion> findDetailById(@Param("id") Long id);

    @Query("SELECT COUNT(r) FROM Reservacion r WHERE r.mesaId = :mesaId AND r.fecha = :fecha AND r.hora = :hora "
            + "AND r.estado = 'CONFIRMADA' AND r.flagEstado = '1' AND (:excludeId IS NULL OR r.id <> :excludeId)")
    long countSolapeMesaFechaHora(
            @Param("mesaId") Long mesaId,
            @Param("fecha") LocalDate fecha,
            @Param("hora") LocalTime hora,
            @Param("excludeId") Long excludeId);

    boolean existsByFsFacturaSimplIdAndFlagEstadoAndEstadoIgnoreCase(
            Long fsFacturaSimplId, String flagEstado, String estado);
}
