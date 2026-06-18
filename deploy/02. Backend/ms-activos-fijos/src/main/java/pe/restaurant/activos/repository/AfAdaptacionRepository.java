package pe.restaurant.activos.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.restaurant.activos.entity.AfAdaptacion;

import java.time.LocalDate;
import java.util.List;

public interface AfAdaptacionRepository extends JpaRepository<AfAdaptacion, Long> {

    Page<AfAdaptacion> findByAfMaestroId(Long afMaestroId, Pageable pageable);

    List<AfAdaptacion> findByAfMaestroId(Long afMaestroId);

    @Query("SELECT a FROM AfAdaptacion a WHERE a.fecha BETWEEN :fechaInicio AND :fechaFin")
    List<AfAdaptacion> findByFechaRange(@Param("fechaInicio") LocalDate fechaInicio, @Param("fechaFin") LocalDate fechaFin);

    @Query("SELECT SUM(a.montoTotal) FROM AfAdaptacion a WHERE a.afMaestroId = :activoId")
    java.math.BigDecimal obtenerTotalCapitalizado(@Param("activoId") Long activoId);
}
