package pe.restaurant.produccion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import pe.restaurant.produccion.entity.ParteProduccion;

public interface ParteProduccionRepository extends JpaRepository<ParteProduccion, Long>,
        JpaSpecificationExecutor<ParteProduccion> {
}
