package pe.restaurant.produccion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import pe.restaurant.produccion.entity.OrdenTrabajo;

import java.util.Optional;

public interface OrdenTrabajoRepository extends JpaRepository<OrdenTrabajo, Long>,
        JpaSpecificationExecutor<OrdenTrabajo> {

    Optional<OrdenTrabajo> findByCodigo(String codigo);

    boolean existsByCodigo(String codigo);

    @Query(value = "SELECT COALESCE(MAX(CAST(SPLIT_PART(o.codigo, '-', 3) AS integer)), 0) " +
            "FROM produccion.orden_trabajo o " +
            "WHERE o.codigo LIKE CONCAT('OT-', :anio, '-%') " +
            "  AND o.codigo ~ '^OT-[0-9]{4}-[0-9]+$'",
            nativeQuery = true)
    int maxSecuenciaByAnio(String anio);
}
