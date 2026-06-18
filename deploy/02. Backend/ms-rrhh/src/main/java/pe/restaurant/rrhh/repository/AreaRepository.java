package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.rrhh.entity.Area;

import java.util.List;

/**
 * Repositorio para la gestión de áreas organizacionales.
 * Incluye queries personalizadas para validaciones jerárquicas y búsquedas.
 */
@Repository
public interface AreaRepository extends JpaRepository<Area, Long>, JpaSpecificationExecutor<Area> {
    
    /**
     * Verifica si existe un área con el nombre dado en el mismo nivel jerárquico.
     * 
     * @param nombre Nombre del área a verificar
     * @param padreId ID del área padre (null para áreas raíz)
     * @return true si existe un área con ese nombre en el mismo nivel
     */
    boolean existsByNombreIgnoreCaseAndPadreId(String nombre, Long padreId);
    
    /**
     * Verifica si existe un área con el nombre dado en el mismo nivel, excluyendo un ID específico.
     * Útil para validaciones en actualizaciones.
     * 
     * @param nombre Nombre del área a verificar
     * @param padreId ID del área padre (null para áreas raíz)
     * @param excludeId ID del área a excluir de la búsqueda
     * @return true si existe otra área con ese nombre en el mismo nivel
     */
    boolean existsByNombreIgnoreCaseAndPadreIdAndIdNot(String nombre, Long padreId, Long excludeId);
    
    /**
     * Cuenta cuántas sub-áreas tiene un área específica.
     * 
     * @param padreId ID del área padre
     * @return Cantidad de sub-áreas
     */
    @Query("SELECT COUNT(a) FROM Area a WHERE a.padreId = :padreId")
    long countByPadreId(@Param("padreId") Long padreId);
    
    /**
     * Obtiene todas las áreas raíz (sin padre) ordenadas por nombre.
     * 
     * @return Lista de áreas raíz
     */
    @Query("SELECT a FROM Area a WHERE a.padreId IS NULL ORDER BY a.nombre")
    List<Area> findRootAreas();
    
    /**
     * Obtiene todas las sub-áreas de un área específica ordenadas por nombre.
     * 
     * @param padreId ID del área padre
     * @return Lista de sub-áreas
     */
    @Query("SELECT a FROM Area a WHERE a.padreId = :padreId ORDER BY a.nombre")
    List<Area> findByPadreId(@Param("padreId") Long padreId);
}
