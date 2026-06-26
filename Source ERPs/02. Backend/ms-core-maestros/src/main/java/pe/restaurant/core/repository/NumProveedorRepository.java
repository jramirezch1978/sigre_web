package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.NumProveedor;

import java.util.Optional;

public interface NumProveedorRepository extends JpaRepository<NumProveedor, Long> {

    Optional<NumProveedor> findBySucursalIdAndSerieAndAnio(Long sucursalId, String serie, Integer anio);
}
