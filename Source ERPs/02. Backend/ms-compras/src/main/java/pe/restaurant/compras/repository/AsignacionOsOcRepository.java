package pe.restaurant.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.compras.entity.AsignacionOsOc;
import java.util.List;

public interface AsignacionOsOcRepository extends JpaRepository<AsignacionOsOc, Long> {
    List<AsignacionOsOc> findByOrdenServicioId(Long ordenServicioId);
}
