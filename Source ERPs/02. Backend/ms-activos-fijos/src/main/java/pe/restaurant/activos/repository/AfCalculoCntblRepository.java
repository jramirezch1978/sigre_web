package pe.restaurant.activos.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.restaurant.activos.entity.AfCalculoCntbl;

import java.util.List;
import java.util.Optional;

public interface AfCalculoCntblRepository extends JpaRepository<AfCalculoCntbl, Long> {

    Page<AfCalculoCntbl> findByAfMaestroId(Long afMaestroId, Pageable pageable);

    List<AfCalculoCntbl> findByAfMaestroIdOrderByAnioDescMesDesc(Long afMaestroId);

    Page<AfCalculoCntbl> findByAnioAndMes(Integer anio, Integer mes, Pageable pageable);

    List<AfCalculoCntbl> findByAnioAndMes(Integer anio, Integer mes);

    Optional<AfCalculoCntbl> findByAfMaestroIdAndAnioAndMes(Long afMaestroId, Integer anio, Integer mes);

    boolean existsByAfMaestroId(Long afMaestroId);

    boolean existsByAfMaestroIdAndAnioAndMes(Long afMaestroId, Integer anio, Integer mes);

    @Query("SELECT c FROM AfCalculoCntbl c WHERE c.afMaestroId = :afMaestroId ORDER BY c.anio DESC, c.mes DESC")
    List<AfCalculoCntbl> obtenerHistorialDepreciacion(@Param("afMaestroId") Long afMaestroId);

    @Query("SELECT c FROM AfCalculoCntbl c WHERE c.anio = :anio AND c.mes = :mes ORDER BY c.afMaestroId")
    List<AfCalculoCntbl> obtenerDepreciacionPorPeriodo(@Param("anio") Integer anio, @Param("mes") Integer mes);

    @Query("SELECT COALESCE(SUM(c.depreciacionPeriodo), 0) FROM AfCalculoCntbl c WHERE c.anio = :anio AND c.mes = :mes")
    java.math.BigDecimal obtenerTotalDepreciacionPeriodo(@Param("anio") Integer anio, @Param("mes") Integer mes);

    @Query("SELECT c FROM AfCalculoCntbl c WHERE c.afMaestroId = :afMaestroId ORDER BY c.anio DESC, c.mes DESC LIMIT 1")
    Optional<AfCalculoCntbl> obtenerUltimaDepreciacion(@Param("afMaestroId") Long afMaestroId);
}
