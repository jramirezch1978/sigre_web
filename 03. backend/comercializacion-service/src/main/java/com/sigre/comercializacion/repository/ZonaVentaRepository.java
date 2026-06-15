package com.sigre.comercializacion.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.sigre.comercializacion.entity.ZonaVenta;

@Repository
public interface ZonaVentaRepository extends JpaRepository<ZonaVenta, Long> {

    boolean existsByZonaVentaAndFlagEstado(String zonaVenta, String flagEstado);

    boolean existsByZonaVentaAndFlagEstadoAndIdNot(String zonaVenta, String flagEstado, Long id);

    // Búsqueda con filtros según contrato: zonaVenta, descZonaVenta, ubigeo, flagEstado
    @Query("SELECT z FROM ZonaVenta z " +
           "WHERE (:zonaVenta IS NULL OR :zonaVenta = '' OR LOWER(z.zonaVenta) LIKE LOWER(CONCAT('%', :zonaVenta, '%'))) " +
           "AND (:descZonaVenta IS NULL OR :descZonaVenta = '' OR LOWER(z.descZonaVenta) LIKE LOWER(CONCAT('%', :descZonaVenta, '%'))) " +
           "AND (:ubigeo IS NULL OR z.ubigeo = :ubigeo) " +
           "AND (:flagEstado IS NULL OR z.flagEstado = :flagEstado)")
    Page<ZonaVenta> findAllWithFilters(@Param("zonaVenta") String zonaVenta,
                                       @Param("descZonaVenta") String descZonaVenta,
                                       @Param("ubigeo") String ubigeo,
                                       @Param("flagEstado") String flagEstado,
                                       Pageable pageable);
}
