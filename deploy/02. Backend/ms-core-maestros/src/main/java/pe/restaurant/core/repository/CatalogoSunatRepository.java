package pe.restaurant.core.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.restaurant.core.entity.CatalogoSunat;

import java.util.Optional;

public interface CatalogoSunatRepository extends JpaRepository<CatalogoSunat, Long> {

    Optional<CatalogoSunat> findByCodigoCatalogo(String codigoCatalogo);

    @Query("SELECT c FROM CatalogoSunat c WHERE "
            + "(:codigoCatalogo IS NULL OR c.codigoCatalogo LIKE %:codigoCatalogo%) "
            + "AND (:nombreCatalogo IS NULL OR c.nombreCatalogo LIKE %:nombreCatalogo%) "
            + "AND (:flagEstado IS NULL OR c.flagEstado = :flagEstado)")
    Page<CatalogoSunat> findWithFilters(
            @Param("codigoCatalogo") String codigoCatalogo,
            @Param("nombreCatalogo") String nombreCatalogo,
            @Param("flagEstado") String flagEstado,
            Pageable pageable);
}
