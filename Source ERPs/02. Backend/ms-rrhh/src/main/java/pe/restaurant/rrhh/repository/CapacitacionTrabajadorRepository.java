package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.rrhh.entity.CapacitacionTrabajador;
import java.util.List;
import java.util.Optional;

public interface CapacitacionTrabajadorRepository extends JpaRepository<CapacitacionTrabajador, Long> {

    List<CapacitacionTrabajador> findByCapacitacionId(Long capacitacionId);

    boolean existsByCapacitacionIdAndTrabajadorId(Long capacitacionId, Long trabajadorId);

    Optional<CapacitacionTrabajador> findByCapacitacionIdAndTrabajadorId(Long capacitacionId, Long trabajadorId);
}
