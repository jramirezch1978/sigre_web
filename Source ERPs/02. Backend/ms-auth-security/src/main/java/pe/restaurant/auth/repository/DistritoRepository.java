package pe.restaurant.auth.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.auth.entity.Distrito;

public interface DistritoRepository extends JpaRepository<Distrito, Long> {
}
