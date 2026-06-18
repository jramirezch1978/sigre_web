package pe.restaurant.activos.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.restaurant.activos.entity.AfOperaciones;

import java.time.LocalDate;
import java.util.List;

public interface AfOperacionesRepository extends JpaRepository<AfOperaciones, Long> {

    List<AfOperaciones> findByAfMaestroId(Long afMaestroId);

    @Query("SELECT o FROM AfOperaciones o WHERE o.fechaProgramada <= :fecha")
    List<AfOperaciones> findProgramadas(@Param("fecha") LocalDate fecha);

    @Query("SELECT o FROM AfOperaciones o WHERE o.tipo = :tipo")
    List<AfOperaciones> findByTipo(@Param("tipo") String tipo);

    @Query("SELECT o FROM AfOperaciones o WHERE o.fechaProgramada BETWEEN :fechaInicio AND :fechaFin")
    List<AfOperaciones> findByFechaRange(@Param("fechaInicio") LocalDate fechaInicio, @Param("fechaFin") LocalDate fechaFin);

    boolean existsByAfTipoOperacionId(Long afTipoOperacionId);
}
