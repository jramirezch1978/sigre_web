package pe.restaurant.almacen.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.restaurant.almacen.entity.AlmacenTacito;

public interface AlmacenTacitoRepository extends JpaRepository<AlmacenTacito, Long> {

    @Query("""
            SELECT a FROM AlmacenTacito a
            WHERE (:codClase IS NULL OR a.codClase = :codClase)
              AND (:sucursalId IS NULL OR a.sucursalId = :sucursalId)
              AND (:almacenId IS NULL OR a.almacenId = :almacenId)
            """)
    Page<AlmacenTacito> buscar(@Param("codClase") String codClase,
                               @Param("sucursalId") Long sucursalId,
                               @Param("almacenId") Long almacenId,
                               Pageable pageable);

    boolean existsByCodClaseIgnoreCaseAndSucursalId(String codClase, Long sucursalId);

    boolean existsByCodClaseIgnoreCaseAndSucursalIdAndIdNot(String codClase, Long sucursalId, Long id);
}
