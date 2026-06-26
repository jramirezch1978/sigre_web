package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import pe.restaurant.rrhh.entity.SancionAmonestacion;

public interface SancionAmonestacionRepository extends JpaRepository<SancionAmonestacion, Long>,
        JpaSpecificationExecutor<SancionAmonestacion> {
}
