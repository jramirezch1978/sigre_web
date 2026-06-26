package pe.restaurant.rrhh.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.rrhh.entity.GanDescFijo;

@Repository
public interface GanDescFijoRepository extends JpaRepository<GanDescFijo, Long>,
        JpaSpecificationExecutor<GanDescFijo> {

    @Query("SELECT g FROM GanDescFijo g WHERE "
            + "(:trabajadorId IS NULL OR g.trabajadorId = :trabajadorId) "
            + "AND (:conceptoId IS NULL OR g.conceptoId = :conceptoId) "
            + "AND (:flagEstado IS NULL OR g.flagEstado = :flagEstado)")
    Page<GanDescFijo> findWithFilters(
            @Param("trabajadorId") Long trabajadorId,
            @Param("conceptoId") Long conceptoId,
            @Param("flagEstado") String flagEstado,
            Pageable pageable);

    boolean existsByTrabajadorIdAndConceptoIdAndFlagEstado(
            Long trabajadorId, Long conceptoId, String flagEstado);
}
