package com.sigre.produccion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import com.sigre.produccion.entity.Labor;

public interface LaborRepository extends JpaRepository<Labor, Long>, JpaSpecificationExecutor<Labor> {

    boolean existsByCodigoIgnoreCase(String codigo);

    boolean existsByCodigoIgnoreCaseAndIdNot(String codigo, Long id);

    /**
     * PRD-LB-005: bloquea DELETE si la labor esta referenciada por receta_labor o
     * operaciones_det (no se incluyen las propias sub-entidades labor_insumo y
     * labor_produccion porque se eliminan en cascada logica).
     */
    @Query(value = """
            SELECT
              (EXISTS (SELECT 1 FROM produccion.receta_labor    WHERE labor_id = :laborId))
              OR
              (EXISTS (SELECT 1 FROM produccion.operaciones_det WHERE labor_id = :laborId))
            """, nativeQuery = true)
    boolean existsReferenciaByLaborId(@Param("laborId") Long laborId);
}
