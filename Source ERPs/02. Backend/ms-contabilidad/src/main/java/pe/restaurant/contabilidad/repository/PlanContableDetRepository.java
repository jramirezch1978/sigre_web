package pe.restaurant.contabilidad.repository;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.contabilidad.entity.PlanContableDet;

import java.util.List;
import java.util.Optional;

@Repository
public interface PlanContableDetRepository extends JpaRepository<PlanContableDet, Long>, JpaSpecificationExecutor<PlanContableDet> {

    Optional<PlanContableDet> findByIdAndFlagEstado(Long id, String flagEstado);

    /**
     * Busca todas las cuentas hijas (descendientes) de una cuenta contable dentro
     * del mismo plan, excluyendo la cuenta consultada.
     * <p>
     * La relación padre-hijo se determina por prefijo del código contable:
     * cualquier cuenta cuyo {@code cnta_ctbl} comience con el patrón dado es
     * considerada descendiente. Ej: patrón {@code "10%"} encuentra {@code 101},
     * {@code 10101}, {@code 10101101}, etc.
     *
     * @param planContableId plan contable al que pertenecen las cuentas
     * @param pattern        patrón LIKE para buscar hijos (ej. {@code "10%"})
     * @param id             ID de la cuenta padre a excluir de los resultados
     * @return lista de cuentas hijas encontradas
     */
    @Query("SELECT p FROM PlanContableDet p WHERE p.planContableId = :planContableId AND p.cntaCtbl LIKE :pattern AND p.id <> :id")
    List<PlanContableDet> findDescendants(@Param("planContableId") Long planContableId,
                                          @Param("pattern") String pattern,
                                          @Param("id") Long id);

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
