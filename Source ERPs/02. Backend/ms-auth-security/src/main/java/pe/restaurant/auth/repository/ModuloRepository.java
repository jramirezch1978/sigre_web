package pe.restaurant.auth.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.auth.entity.Modulo;

import java.util.List;
import java.util.Optional;

public interface ModuloRepository extends JpaRepository<Modulo, Long> {

    Optional<Modulo> findByCodigo(String codigo);

    List<Modulo> findAllByOrderByNombreAsc();
}
