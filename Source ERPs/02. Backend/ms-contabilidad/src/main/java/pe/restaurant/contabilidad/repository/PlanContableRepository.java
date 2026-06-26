package pe.restaurant.contabilidad.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.contabilidad.entity.PlanContable;

import java.util.Optional;

@Repository
public interface PlanContableRepository extends JpaRepository<PlanContable, Long> {

    Optional<PlanContable> findByCodigo(String codigo);

    Optional<PlanContable> findFirstByFlagEstadoOrderByEffectiveFromDesc(String flagEstado);

    @Query(value = "SELECT p FROM PlanContable p WHERE " +
           "(:codigo IS NULL OR p.codigo LIKE %:codigo%) " +
           "AND (:anio IS NULL OR p.anio = :anio) " +
           "AND (:flagEstado IS NULL OR p.flagEstado = :flagEstado) " +
           "ORDER BY p.anio DESC, p.codigo")
    Page<PlanContable> buscar(
            @Param("codigo") String codigo,
            @Param("anio") Integer anio,
            @Param("flagEstado") String flagEstado,
            Pageable pageable);
}
