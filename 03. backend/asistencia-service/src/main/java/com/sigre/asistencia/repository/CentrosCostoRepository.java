package com.sigre.asistencia.repository;

import com.sigre.asistencia.entity.CentrosCosto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CentrosCostoRepository extends JpaRepository<CentrosCosto, String> {
    
    /**
     * Buscar centros de costo activos
     */
    List<CentrosCosto> findByFlagEstadoOrderByDescripcionCencos(String flagEstado);
    
    /**
     * Buscar centro de costo por código y que esté activo
     */
    Optional<CentrosCosto> findByCencosAndFlagEstado(String cencos, String flagEstado);
    
    /**
     * Verificar si existe un centro de costo activo
     */
    boolean existsByCencosAndFlagEstado(String cencos, String flagEstado);
    
    /**
     * Buscar centros de costo por descripción (búsqueda parcial)
     */
    @Query("SELECT c FROM CentrosCosto c " +
           "WHERE c.flagEstado = '1' " +
           "AND UPPER(c.descripcionCencos) LIKE UPPER(CONCAT('%', :descripcion, '%')) " +
           "ORDER BY c.descripcionCencos")
    List<CentrosCosto> findByDescripcionContaining(@Param("descripcion") String descripcion);
    
    /**
     * Buscar centros de costo por grupo contable
     */
    List<CentrosCosto> findByGrupoCntblAndFlagEstadoOrderByDescripcionCencos(String grupoCntbl, String flagEstado);
    
    /**
     * Contar trabajadores activos por centro de costo
     */
    @Query("SELECT COUNT(m) FROM Maestro m " +
           "WHERE m.centroCosto = :cencos " +
           "AND m.flagEstado = '1'")
    Long countTrabajadoresActivosByCencos(@Param("cencos") String cencos);
}
