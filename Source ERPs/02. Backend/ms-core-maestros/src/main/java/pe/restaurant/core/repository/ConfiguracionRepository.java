package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.Configuracion;

import java.util.List;
import java.util.Optional;

public interface ConfiguracionRepository extends JpaRepository<Configuracion, Long> {
    List<Configuracion> findByModulo(String modulo);
    Optional<Configuracion> findByParametro(String parametro);
}
