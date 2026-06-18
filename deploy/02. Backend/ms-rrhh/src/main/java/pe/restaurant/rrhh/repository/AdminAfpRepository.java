package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import pe.restaurant.rrhh.entity.AdminAfp;

import java.util.List;

/**
 * Repositorio para el acceso a datos de la entidad AdminAfp.
 * 
 * <p>Proporciona métodos para realizar operaciones CRUD y consultas
 * especializadas sobre las Administradoras de Fondos de Pensiones.</p>
 * 
 * @author Sistema de RRHH
 * @version 1.0
 */
@Repository
public interface AdminAfpRepository extends JpaRepository<AdminAfp, Long>, JpaSpecificationExecutor<AdminAfp> {
    
    /**
     * Verifica si existe una AFP con el nombre especificado (ignorando mayúsculas/minúsculas).
     * 
     * @param nombre nombre de la AFP a verificar
     * @return true si existe una AFP con ese nombre, false en caso contrario
     */
    boolean existsByNombreIgnoreCase(String nombre);
    
    /**
     * Verifica si existe una AFP con el nombre especificado, excluyendo un ID específico.
     * Útil para validaciones en actualizaciones.
     * 
     * @param nombre nombre de la AFP a verificar
     * @param id ID de la AFP a excluir de la búsqueda
     * @return true si existe otra AFP con ese nombre, false en caso contrario
     */
    boolean existsByNombreIgnoreCaseAndIdNot(String nombre, Long id);

    List<AdminAfp> findByFlagEstadoOrderByNombreAsc(String flagEstado);
}
