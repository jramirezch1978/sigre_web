package pe.restaurant.auth.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.auth.entity.Pais;

import java.util.Optional;

public interface PaisRepository extends JpaRepository<Pais, Long> {

    Optional<Pais> findByCodigo(String codigo);
}
