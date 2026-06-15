package com.sigre.comercializacion.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.sigre.comercializacion.entity.ZonaReparto;

@Repository
public interface ZonaRepartoRepository extends JpaRepository<ZonaReparto, Long> {

    boolean existsByZonaRepartoAndFlagEstado(String zonaReparto, String flagEstado);

    boolean existsByZonaRepartoAndFlagEstadoAndIdNot(String zonaReparto, String flagEstado, Long id);

    // Búsqueda con filtros según contrato: zonaReparto, descZonaReparto, ubigeo, flagEstado
    @Query("SELECT z FROM ZonaReparto z " +
           "WHERE (:zonaReparto IS NULL OR :zonaReparto = '' OR LOWER(z.zonaReparto) LIKE LOWER(CONCAT('%', :zonaReparto, '%'))) " +
           "AND (:descZonaReparto IS NULL OR :descZonaReparto = '' OR LOWER(z.descZonaReparto) LIKE LOWER(CONCAT('%', :descZonaReparto, '%'))) " +
           "AND (:ubigeo IS NULL OR z.ubigeo = :ubigeo) " +
           "AND (:flagEstado IS NULL OR z.flagEstado = :flagEstado)")
    Page<ZonaReparto> findAllWithFilters(@Param("zonaReparto") String zonaReparto,
                                        @Param("descZonaReparto") String descZonaReparto,
                                        @Param("ubigeo") String ubigeo,
                                        @Param("flagEstado") String flagEstado,
                                        Pageable pageable);
}
