package pe.restaurant.activos.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.activos.entity.AfTipoOperacion;

import java.util.Optional;

public interface AfTipoOperacionRepository extends JpaRepository<AfTipoOperacion, Long> {

    Optional<AfTipoOperacion> findByCodigoIgnoreCase(String codigo);

    boolean existsByCodigoIgnoreCase(String codigo);

    boolean existsByCodigoIgnoreCaseAndIdNot(String codigo, Long id);
}
