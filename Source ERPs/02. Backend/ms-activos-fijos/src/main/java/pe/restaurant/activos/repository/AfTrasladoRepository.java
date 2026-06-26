package pe.restaurant.activos.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.restaurant.activos.entity.AfTraslado;

import java.time.LocalDate;
import java.util.List;

public interface AfTrasladoRepository extends JpaRepository<AfTraslado, Long> {

    List<AfTraslado> findByAfMaestroId(Long afMaestroId);

    @Query("SELECT t FROM AfTraslado t WHERE t.fechaSolicitud BETWEEN :fechaInicio AND :fechaFin")
    List<AfTraslado> findByFechaRange(@Param("fechaInicio") LocalDate fechaInicio, @Param("fechaFin") LocalDate fechaFin);

    @Query("SELECT t FROM AfTraslado t WHERE t.ubicacionOrigenId = :ubicacionId OR t.ubicacionDestinoId = :ubicacionId")
    List<AfTraslado> findByUbicacion(@Param("ubicacionId") Long ubicacionId);
}
