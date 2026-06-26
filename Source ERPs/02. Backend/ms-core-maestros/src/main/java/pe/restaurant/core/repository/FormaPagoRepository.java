package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.FormaPago;

import java.util.Optional;

public interface FormaPagoRepository extends JpaRepository<FormaPago, Long> {
    Optional<FormaPago> findByCodigo(String codigo);
}
