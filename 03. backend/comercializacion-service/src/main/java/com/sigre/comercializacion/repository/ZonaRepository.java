package com.sigre.comercializacion.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.sigre.comercializacion.entity.Zona;

import java.util.List;
import java.util.Optional;

@Repository
public interface ZonaRepository extends JpaRepository<Zona, Long> {
    
    boolean existsBySucursalIdAndNombreAndFlagEstado(Long sucursalId, String nombre, String flagEstado);
    
    boolean existsBySucursalIdAndNombreAndFlagEstadoAndIdNot(Long sucursalId, String nombre, String flagEstado, Long id);
    
    @Query("SELECT z FROM Zona z WHERE z.sucursal.id = :sucursalId AND z.flagEstado = '1' ORDER BY z.nombre")
    List<Zona> findBySucursalIdAndActivo(@Param("sucursalId") Long sucursalId);
    
    @Query("SELECT z FROM Zona z WHERE z.flagEstado = '1' ORDER BY z.nombre")
    List<Zona> findAllActivas();
    
    @Query("SELECT z FROM Zona z WHERE " +
           "(:sucursalId IS NULL OR z.sucursal.id = :sucursalId) AND " +
           "(:nombre IS NULL OR LOWER(z.nombre) LIKE LOWER(CONCAT('%', :nombre, '%'))) AND " +
           "(:flagEstado IS NULL OR z.flagEstado = :flagEstado)")
    Page<Zona> findByFilters(@Param("sucursalId") Long sucursalId, 
                           @Param("nombre") String nombre, 
                           @Param("flagEstado") String flagEstado, 
                           Pageable pageable);
    
    Optional<Zona> findByIdAndFlagEstado(Long id, String flagEstado);
}
