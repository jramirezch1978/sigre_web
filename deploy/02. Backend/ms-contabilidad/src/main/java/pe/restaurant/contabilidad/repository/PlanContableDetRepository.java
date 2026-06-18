package pe.restaurant.contabilidad.repository;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.contabilidad.entity.PlanContableDet;

import java.util.Optional;

@Repository
public interface PlanContableDetRepository extends JpaRepository<PlanContableDet, Long>, JpaSpecificationExecutor<PlanContableDet> {

    Optional<PlanContableDet> findByIdAndFlagEstado(Long id, String flagEstado);

    boolean existsByPlanContableIdAndCntaCtbl(Long planContableId, String cntaCtbl);

    boolean existsByPlanContableIdAndCntaCtblAndIdNot(Long planContableId, String cntaCtbl, Long id);

    /**
     * Búsqueda de cuentas activas por código o descripción (para selectores).
     * Proyección {@code [id, cntaCtbl, descCnta]} — NO carga la entidad completa
     * porque algunos tenants migrados (p. ej. Cantabria) no tienen todas las
     * columnas del modelo (abrev_cnta, naturaleza, tipo, requiere_cc...).
     */
    @Query("SELECT p.id, p.cntaCtbl, p.descCnta FROM PlanContableDet p WHERE p.flagEstado = '1' "
            + "AND (:q IS NULL OR :q = '' "
            + "OR LOWER(p.cntaCtbl) LIKE LOWER(CONCAT('%', :q, '%')) "
            + "OR LOWER(p.descCnta) LIKE LOWER(CONCAT('%', :q, '%'))) "
            + "ORDER BY p.cntaCtbl")
    java.util.List<Object[]> buscarResumen(@Param("q") String q, Pageable pageable);
}
