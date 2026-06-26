package pe.restaurant.activos.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.restaurant.activos.entity.AfAdaptacionDep;

import java.util.List;
import java.util.Optional;

public interface AfAdaptacionDepRepository extends JpaRepository<AfAdaptacionDep, Long> {

    List<AfAdaptacionDep> findByAfAdaptacionId(Long afAdaptacionId);

    List<AfAdaptacionDep> findByAnioAndMes(Integer anio, Integer mes);

    boolean existsByAfAdaptacionIdAndAnioAndMes(Long afAdaptacionId, Integer anio, Integer mes);

    @Query("SELECT d FROM AfAdaptacionDep d WHERE d.afAdaptacionId = :adaptacionId AND d.anio = :anio AND d.mes = :mes")
    Optional<AfAdaptacionDep> findByAdaptacionAndPeriodo(
            @Param("adaptacionId") Long adaptacionId,
            @Param("anio") Integer anio,
            @Param("mes") Integer mes
    );

    @Query("SELECT d FROM AfAdaptacionDep d WHERE d.afAdaptacionId = :adaptacionId ORDER BY d.anio DESC, d.mes DESC")
    List<AfAdaptacionDep> findByAdaptacionOrderByPeriodoDesc(@Param("adaptacionId") Long adaptacionId);
}
