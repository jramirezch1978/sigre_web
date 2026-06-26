package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.TiposImpuesto;

import java.util.Optional;

public interface TiposImpuestoRepository extends JpaRepository<TiposImpuesto, Long> {

    Optional<TiposImpuesto> findByTipoImpuesto(String tipoImpuesto);
}
