package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.rrhh.entity.GrupoCalculoDet;

import java.util.List;

@Repository
public interface GrupoCalculoDetRepository extends JpaRepository<GrupoCalculoDet, Long> {

    List<GrupoCalculoDet> findByGrupoCalculoId(Long grupoCalculoId);

    List<GrupoCalculoDet> findByGrupoCalculoIdAndFlagEstado(Long grupoCalculoId, String flagEstado);

    /** Devuelve los IDs de concepto_planilla que pertenecen al grupo indicado (activos). */
    @Query("SELECT d.conceptoPlanillaId FROM GrupoCalculoDet d " +
           "WHERE d.grupoCalculoId = :grupoCalculoId AND d.flagEstado = '1'")
    List<Long> findConceptoIdsByGrupoCalculoId(@Param("grupoCalculoId") Long grupoCalculoId);

    /** Verifica si un concepto pertenece a un grupo de cálculo. */
    boolean existsByGrupoCalculoIdAndConceptoPlanillaId(Long grupoCalculoId, Long conceptoPlanillaId);
}
