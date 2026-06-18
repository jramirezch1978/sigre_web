package pe.restaurant.activos.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.restaurant.activos.entity.AfVenta;

import java.time.LocalDate;
import java.util.List;

public interface AfVentaRepository extends JpaRepository<AfVenta, Long> {

    boolean existsByAfMaestroId(Long afMaestroId);

    List<AfVenta> findByAfMaestroId(Long afMaestroId);

    @Query("SELECT v FROM AfVenta v WHERE YEAR(v.fechaBaja) = :anio")
    List<AfVenta> findByAnio(@Param("anio") Integer anio);

    @Query("SELECT v FROM AfVenta v WHERE v.motivo = :motivo")
    List<AfVenta> findByMotivo(@Param("motivo") String motivo);

    @Query("SELECT v FROM AfVenta v WHERE v.fechaBaja BETWEEN :fechaInicio AND :fechaFin")
    List<AfVenta> findByFechaRange(@Param("fechaInicio") LocalDate fechaInicio, @Param("fechaFin") LocalDate fechaFin);
}
