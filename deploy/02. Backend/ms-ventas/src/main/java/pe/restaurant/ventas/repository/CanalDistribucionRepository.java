package pe.restaurant.ventas.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.ventas.entity.CanalDistribucion;

@Repository
public interface CanalDistribucionRepository extends JpaRepository<CanalDistribucion, Long> {

    boolean existsByCodigoAndFlagEstado(String codigo, String flagEstado);

    boolean existsByCodigoAndFlagEstadoAndIdNot(String codigo, String flagEstado, Long id);

    // Búsqueda con filtros según contrato: codigo, nombre, flagEstado
    @Query("SELECT cd FROM CanalDistribucion cd " +
           "WHERE (:codigo IS NULL OR :codigo = '' OR LOWER(cd.codigo) LIKE LOWER(CONCAT('%', :codigo, '%'))) " +
           "AND (:nombre IS NULL OR :nombre = '' OR LOWER(cd.nombre) LIKE LOWER(CONCAT('%', :nombre, '%'))) " +
           "AND (:flagEstado IS NULL OR cd.flagEstado = :flagEstado)")
    Page<CanalDistribucion> findAllWithFilters(@Param("codigo") String codigo,
                                               @Param("nombre") String nombre,
                                               @Param("flagEstado") String flagEstado,
                                               Pageable pageable);
}
