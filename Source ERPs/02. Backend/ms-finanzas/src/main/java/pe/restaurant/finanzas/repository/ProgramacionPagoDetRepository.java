package pe.restaurant.finanzas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.finanzas.entity.ProgramacionPagoDet;

import java.util.List;

@Repository
public interface ProgramacionPagoDetRepository extends JpaRepository<ProgramacionPagoDet, Long> {

    @Query("SELECT d FROM ProgramacionPagoDet d " +
           "WHERE d.programacionPago.id = :programacionId " +
           "AND d.flagEstado = '1'")
    List<ProgramacionPagoDet> findByProgramacionId(@Param("programacionId") Long programacionId);

    @Query("SELECT COUNT(d) FROM ProgramacionPagoDet d " +
           "WHERE d.programacionPago.id = :programacionId " +
           "AND d.flagEstado = '1'")
    Integer contarDetallesPorProgramacion(@Param("programacionId") Long programacionId);
}
