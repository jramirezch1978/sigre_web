package pe.restaurant.activos.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.restaurant.activos.entity.AfUbicacion;

import java.util.Optional;

public interface AfUbicacionRepository extends JpaRepository<AfUbicacion, Long> {

    Optional<AfUbicacion> findBySucursalIdAndCodigoIgnoreCase(Long sucursalId, String codigo);

    boolean existsBySucursalIdAndCodigoIgnoreCase(Long sucursalId, String codigo);

    boolean existsBySucursalIdAndCodigoIgnoreCaseAndIdNot(Long sucursalId, String codigo, Long id);

    @Query("SELECT CASE WHEN COUNT(a) > 0 THEN true ELSE false END FROM AfUbicacion a WHERE a.sucursalId = :sucursalId")
    boolean existsBySucursalId(@Param("sucursalId") Long sucursalId);
}
