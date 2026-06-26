package pe.restaurant.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.compras.entity.ConfiguracionRef;

import java.util.Optional;

public interface ConfiguracionRefRepository extends JpaRepository<ConfiguracionRef, Long> {
    Optional<ConfiguracionRef> findFirstByParametro(String parametro);
}
