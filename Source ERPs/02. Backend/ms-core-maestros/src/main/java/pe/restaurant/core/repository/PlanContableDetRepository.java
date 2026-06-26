package pe.restaurant.core.repository;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.core.entity.PlanContableDet;

import java.util.List;

@Repository
public interface PlanContableDetRepository extends JpaRepository<PlanContableDet, Long> {

    /**
     * Búsqueda de cuentas activas por código o descripción (para selectores).
     * Proyección [id, cntaCtbl, descCnta] (no carga la entidad completa).
     */
    @Query("SELECT p.id, p.cntaCtbl, p.descCnta FROM PlanContableDet p WHERE p.flagEstado = '1' "
            + "AND (:q IS NULL OR :q = '' "
            + "OR LOWER(p.cntaCtbl) LIKE LOWER(CONCAT('%', :q, '%')) "
            + "OR LOWER(p.descCnta) LIKE LOWER(CONCAT('%', :q, '%'))) "
            + "ORDER BY p.cntaCtbl")
    List<Object[]> buscarResumen(@Param("q") String q, Pageable pageable);
}
