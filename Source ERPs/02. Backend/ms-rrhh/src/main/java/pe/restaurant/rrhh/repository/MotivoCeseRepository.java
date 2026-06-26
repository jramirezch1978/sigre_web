package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import pe.restaurant.rrhh.entity.MotivoCese;
import java.util.List;
import java.util.Optional;

public interface MotivoCeseRepository extends JpaRepository<MotivoCese, Long>, JpaSpecificationExecutor<MotivoCese> {
    Optional<MotivoCese> findByCodigo(String codigo);
    boolean existsByCodigo(String codigo);
    List<MotivoCese> findByFlagEstadoOrderByNombreAsc(String flagEstado);
}
