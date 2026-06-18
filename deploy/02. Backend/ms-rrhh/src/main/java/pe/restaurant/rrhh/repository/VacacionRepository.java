package pe.restaurant.rrhh.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.rrhh.entity.Vacacion;
import java.util.List;
import java.util.Optional;

@Repository
public interface VacacionRepository extends JpaRepository<Vacacion, Long>, JpaSpecificationExecutor<Vacacion> {

    Optional<Vacacion> findByTrabajadorIdAndPeriodoAnio(Long trabajadorId, Integer periodoAnio);

    boolean existsByTrabajadorIdAndPeriodoAnio(Long trabajadorId, Integer periodoAnio);

    @Query("SELECT COUNT(v) > 0 FROM Vacacion v WHERE v.trabajadorId = :trabajadorId AND v.periodoAnio = :periodoAnio AND v.flagEstado NOT IN :estadosExcluidos")
    boolean existsByTrabajadorIdAndPeriodoAnioExcluyendoEstados(@Param("trabajadorId") Long trabajadorId, @Param("periodoAnio") Integer periodoAnio, @Param("estadosExcluidos") List<String> estadosExcluidos);

    @Query("SELECT COALESCE(SUM(v.diasPendientes), 0) FROM Vacacion v WHERE v.trabajadorId = :trabajadorId AND v.periodoAnio = :anio")
    Integer sumDiasPendientesByTrabajadorAndAnio(@Param("trabajadorId") Long trabajadorId, @Param("anio") Integer anio);

    Page<Vacacion> findByTrabajadorId(Long trabajadorId, Pageable pageable);
}
