package pe.restaurant.auth.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.auth.entity.Accion;

import java.util.List;
import java.util.Optional;

public interface AccionRepository extends JpaRepository<Accion, Long> {

    Optional<Accion> findByCodigo(String codigo);

    List<Accion> findAllByOrderByNombreAsc();
}
