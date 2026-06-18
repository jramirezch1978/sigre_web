package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.TipoDocIdentidad;

import java.util.List;
import java.util.Optional;

public interface TipoDocIdentidadRepository extends JpaRepository<TipoDocIdentidad, Long> {
    List<TipoDocIdentidad> findByFlagEstadoOrderByNombre(String flagEstado);
    Optional<TipoDocIdentidad> findByCodigo(String codigo);
}
