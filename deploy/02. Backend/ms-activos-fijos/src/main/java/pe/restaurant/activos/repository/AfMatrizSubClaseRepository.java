package pe.restaurant.activos.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.restaurant.activos.entity.AfMatrizSubClase;

import java.util.Optional;

public interface AfMatrizSubClaseRepository extends JpaRepository<AfMatrizSubClase, Long> {

    Optional<AfMatrizSubClase> findByAfSubClaseId(Long afSubClaseId);

    boolean existsByAfSubClaseId(Long afSubClaseId);

    boolean existsByAfSubClaseIdAndIdNot(Long afSubClaseId, Long id);

    /**
     * Valida contra el plan contable del tenant (mismo servidor BD, esquema contabilidad).
     */
    @Query(
            value = "SELECT COUNT(*) FROM contabilidad.plan_contable_det p "
                    + "WHERE p.id = :id AND COALESCE(NULLIF(TRIM(p.flag_estado), ''), '1') = '1'",
            nativeQuery = true)
    long countPlanContableDetActivo(@Param("id") Long id);
}
