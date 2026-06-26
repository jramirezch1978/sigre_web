package pe.restaurant.auth.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.auth.entity.Sesion;

public interface SesionRepository extends JpaRepository<Sesion, Long> {
}
