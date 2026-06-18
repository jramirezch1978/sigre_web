package pe.restaurant.ventas.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.ventas.entity.DescuentoPromocion;

@Repository
public interface DescuentoPromocionRepository extends JpaRepository<DescuentoPromocion, Long> {

    @Query("SELECT d FROM DescuentoPromocion d WHERE " +
            "(:nombre IS NULL OR :nombre = '' OR LOWER(d.nombre) LIKE LOWER(CONCAT('%', :nombre, '%'))) AND " +
            "(:tipo IS NULL OR :tipo = '' OR d.tipo = :tipo) AND " +
            "(:flagEstado IS NULL OR :flagEstado = '' OR d.flagEstado = :flagEstado)")
    Page<DescuentoPromocion> findWithFilters(
            @Param("nombre") String nombre,
            @Param("tipo") String tipo,
            @Param("flagEstado") String flagEstado,
            Pageable pageable);
}
