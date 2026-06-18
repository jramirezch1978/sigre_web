package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.Sucursal;

public interface SucursalRepository extends JpaRepository<Sucursal, Long> {
}
