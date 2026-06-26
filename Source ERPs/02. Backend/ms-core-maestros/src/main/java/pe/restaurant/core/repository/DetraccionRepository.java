package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.Detraccion;

public interface DetraccionRepository extends JpaRepository<Detraccion, Long> {
    java.util.Optional<Detraccion> findByBienServ(String bienServ);
    boolean existsByBienServ(String bienServ);
}
