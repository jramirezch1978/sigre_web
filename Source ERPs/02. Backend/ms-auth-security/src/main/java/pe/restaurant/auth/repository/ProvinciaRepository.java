package pe.restaurant.auth.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.auth.entity.Provincia;

public interface ProvinciaRepository extends JpaRepository<Provincia, Long> {
}
