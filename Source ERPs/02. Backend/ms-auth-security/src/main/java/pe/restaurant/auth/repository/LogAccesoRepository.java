package pe.restaurant.auth.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.auth.entity.LogAcceso;

public interface LogAccesoRepository extends JpaRepository<LogAcceso, Long> {
}
