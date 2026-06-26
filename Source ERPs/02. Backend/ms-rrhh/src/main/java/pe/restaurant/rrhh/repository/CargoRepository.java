package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.rrhh.entity.Cargo;

import java.util.List;

/**
 * Repositorio para la gestión de cargos organizacionales.
 * Repositorio para la gestión de cargos organizacionales.
 * Incluye queries personalizadas para validaciones de negocio.
 */
@Repository
public interface CargoRepository extends JpaRepository<Cargo, Long>, JpaSpecificationExecutor<Cargo> {
    
    /**
     * Verifica si existe un cargo con el nombre dado (case-insensitive).
     * 
     * @param nombre Nombre del cargo a verificar
     * @return true si existe un cargo con ese nombre
     */
    boolean existsByNombreIgnoreCase(String nombre);
    
    /**
     * Verifica si existe un cargo con el nombre dado, excluyendo un ID específico.
     * Útil para validaciones en actualizaciones.
     * 
     * @param nombre Nombre del cargo a verificar
     * @param excludeId ID del cargo a excluir de la búsqueda
     * @return true si existe otro cargo con ese nombre
     */
    boolean existsByNombreIgnoreCaseAndIdNot(String nombre, Long excludeId);
    
    /**
     * Cuenta cuántos trabajadores tienen asignado un cargo específico.
     * Necesario para validar eliminación de cargos.
     * 
     * @param cargoId ID del cargo
     * @return Cantidad de trabajadores asignados al cargo
     */
    @Query("SELECT COUNT(t) FROM Trabajador t WHERE t.cargoId = :cargoId")
    long countTrabajadoresByCargoId(@Param("cargoId") Long cargoId);

    List<Cargo> findByFlagEstadoOrderByNombreAsc(String flagEstado);
}
