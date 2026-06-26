package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.Marca;

import java.util.List;
import java.util.Optional;

public interface MarcaRepository extends JpaRepository<Marca, Long> {

    Optional<Marca> findByCodigo(String codigo);

    List<Marca> findByFlagEstado(String flagEstado);
}
