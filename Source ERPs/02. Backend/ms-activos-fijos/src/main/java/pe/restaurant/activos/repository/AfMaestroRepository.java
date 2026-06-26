package pe.restaurant.activos.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.restaurant.activos.entity.AfMaestro;

import java.util.Optional;

public interface AfMaestroRepository extends JpaRepository<AfMaestro, Long> {

    Page<AfMaestro> findByFlagEstado(String flagEstado, Pageable pageable);

    Optional<AfMaestro> findByCodigoIgnoreCase(String codigo);

    boolean existsByCodigoIgnoreCase(String codigo);

    boolean existsByCodigoIgnoreCaseAndIdNot(String codigo, Long id);

    Page<AfMaestro> findByAfSubClaseId(Long afSubClaseId, Pageable pageable);

    Page<AfMaestro> findByAfUbicacionId(Long afUbicacionId, Pageable pageable);

    @Query("SELECT CASE WHEN COUNT(m) > 0 THEN true ELSE false END FROM AfMaestro m WHERE m.afSubClaseId = :afSubClaseId")
    boolean existsByAfSubClaseId(@Param("afSubClaseId") Long afSubClaseId);

    @Query("SELECT CASE WHEN COUNT(m) > 0 THEN true ELSE false END FROM AfMaestro m WHERE m.afUbicacionId = :afUbicacionId")
    boolean existsByAfUbicacionId(@Param("afUbicacionId") Long afUbicacionId);

    @Query("SELECT CASE WHEN COUNT(m) > 0 THEN true ELSE false END FROM AfMaestro m WHERE m.proveedorId = :proveedorId")
    boolean existsByProveedorId(@Param("proveedorId") Long proveedorId);

    default boolean existsByOrdenCompraIdAndOrdenCompraLineaId(Long ordenCompraId, Long ordenCompraLineaId) {
        return false;
    }

    boolean existsByProveedorIdAndFacturaProveedorSerieIgnoreCaseAndFacturaProveedorNumeroIgnoreCase(
            Long proveedorId, String serie, String numero);
}
