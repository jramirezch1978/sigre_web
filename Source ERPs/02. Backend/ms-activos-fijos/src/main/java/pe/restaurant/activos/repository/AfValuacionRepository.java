package pe.restaurant.activos.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.restaurant.activos.entity.AfValuacion;

import java.time.LocalDate;
import java.util.List;

public interface AfValuacionRepository extends JpaRepository<AfValuacion, Long> {

    List<AfValuacion> findByAfMaestroIdOrderByFechaValuacionDesc(Long afMaestroId);

    @Query("SELECT v FROM AfValuacion v WHERE v.fechaValuacion BETWEEN :fechaInicio AND :fechaFin ORDER BY v.fechaValuacion DESC")
    List<AfValuacion> findByPeriodo(@Param("fechaInicio") LocalDate fechaInicio, @Param("fechaFin") LocalDate fechaFin);

    @Query("SELECT v FROM AfValuacion v WHERE v.metodoValuacion = :metodo")
    List<AfValuacion> findByMetodo(@Param("metodo") String metodo);

    @Query("SELECT v FROM AfValuacion v WHERE v.responsableId = :responsableId ORDER BY v.fechaValuacion DESC")
    List<AfValuacion> findByResponsable(@Param("responsableId") Long responsableId);
}
