package pe.restaurant.ventas.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.ventas.entity.ZonaDespacho;

@Repository
public interface ZonaDespachoRepository extends JpaRepository<ZonaDespacho, Long> {

    boolean existsByZonaDespachoAndFlagEstado(String zonaDespacho, String flagEstado);

    boolean existsByZonaDespachoAndFlagEstadoAndIdNot(String zonaDespacho, String flagEstado, Long id);

    // Búsqueda con filtros según contrato: zonaDespacho, descZonaDespacho, ubigeo, flagEstado
    @Query("SELECT z FROM ZonaDespacho z " +
           "WHERE (:zonaDespacho IS NULL OR :zonaDespacho = '' OR LOWER(z.zonaDespacho) LIKE LOWER(CONCAT('%', :zonaDespacho, '%'))) " +
           "AND (:descZonaDespacho IS NULL OR :descZonaDespacho = '' OR LOWER(z.descZonaDespacho) LIKE LOWER(CONCAT('%', :descZonaDespacho, '%'))) " +
           "AND (:ubigeo IS NULL OR z.ubigeo = :ubigeo) " +
           "AND (:flagEstado IS NULL OR z.flagEstado = :flagEstado)")
    Page<ZonaDespacho> findAllWithFilters(@Param("zonaDespacho") String zonaDespacho,
                                         @Param("descZonaDespacho") String descZonaDespacho,
                                         @Param("ubigeo") String ubigeo,
                                         @Param("flagEstado") String flagEstado,
                                         Pageable pageable);
}
