package pe.restaurant.produccion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import pe.restaurant.produccion.entity.ProgramacionProduccion;

public interface ProgramacionProduccionRepository extends JpaRepository<ProgramacionProduccion, Long>,
        JpaSpecificationExecutor<ProgramacionProduccion> {
}
