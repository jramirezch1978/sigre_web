package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import pe.restaurant.rrhh.entity.Prestamo;

public interface PrestamoRepository extends JpaRepository<Prestamo, Long>,
        JpaSpecificationExecutor<Prestamo> {
}
