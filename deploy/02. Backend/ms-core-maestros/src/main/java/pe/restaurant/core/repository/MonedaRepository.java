package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.Moneda;

import java.util.Optional;

public interface MonedaRepository extends JpaRepository<Moneda, Long> {
    Optional<Moneda> findByCodigo(String codigo);
}
