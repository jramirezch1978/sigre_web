package com.sigre.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.sigre.rrhh.entity.GanDesctFijo;

import java.util.List;
import java.util.Optional;

@Repository
public interface GanDesctFijoRepository extends JpaRepository<GanDesctFijo, Long> {

    List<GanDesctFijo> findByTrabajadorIdAndFlagEstado(Long trabajadorId, String flagEstado);

    List<GanDesctFijo> findByTrabajadorId(Long trabajadorId);

    Optional<GanDesctFijo> findByTrabajadorIdAndConceptoId(Long trabajadorId, Long conceptoId);

    /**
     * Devuelve los registros activos del trabajador cuyos conceptos pertenecen
     * a un grupo de cálculo. Uso principal: ganancias fijas del motor.
     */
    @Query("SELECT gdf FROM GanDesctFijo gdf " +
           "WHERE gdf.trabajadorId = :trabajadorId " +
           "AND gdf.flagEstado = '1' " +
           "AND gdf.conceptoId IN (" +
           "  SELECT gcd.conceptoPlanillaId FROM GrupoCalculoDet gcd " +
           "  WHERE gcd.grupoCalculoId = :grupoCalculoId AND gcd.flagEstado = '1'" +
           ")")
    List<GanDesctFijo> findActivosByTrabajadorAndGrupo(
            @Param("trabajadorId") Long trabajadorId,
            @Param("grupoCalculoId") Long grupoCalculoId);
}
