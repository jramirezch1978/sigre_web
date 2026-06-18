package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.CondicionPago;

public interface CondicionPagoRepository extends JpaRepository<CondicionPago, Long> {
    boolean existsByCodigoIgnoreCaseAndIdNot(String codigo, Long id);
    boolean existsByCodigoIgnoreCase(String codigo);
}
