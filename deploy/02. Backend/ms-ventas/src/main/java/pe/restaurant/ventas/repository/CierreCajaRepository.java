package pe.restaurant.ventas.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.ventas.entity.CierreCaja;

@Repository
public interface CierreCajaRepository extends JpaRepository<CierreCaja, Long> {

    @Query("SELECT c FROM CierreCaja c WHERE " +
            "(:turnoId IS NULL OR c.turnoId = :turnoId) AND " +
            "(:abierto IS NULL OR " +
            "  (:abierto = true AND c.fechaCierre IS NULL) OR " +
            "  (:abierto = false AND c.fechaCierre IS NOT NULL))")
    Page<CierreCaja> findWithFilters(
            @Param("turnoId") Long turnoId,
            @Param("abierto") Boolean abierto,
            Pageable pageable);

    @Query("SELECT COUNT(c) FROM CierreCaja c WHERE c.turnoId = :turnoId AND c.fechaCierre IS NULL AND c.flagEstado = '1'")
    long countAbiertoByTurno(@Param("turnoId") Long turnoId);
}
