package pe.restaurant.produccion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import pe.restaurant.produccion.entity.CosteoProduccion;

import java.util.List;
import java.util.Optional;

public interface CosteoProduccionRepository extends JpaRepository<CosteoProduccion, Long>,
        JpaSpecificationExecutor<CosteoProduccion> {

    Optional<CosteoProduccion> findByOrdenTrabajoIdAndAnioAndMes(Long ordenTrabajoId, Integer anio, Integer mes);

    List<CosteoProduccion> findAllByAnioAndMes(Integer anio, Integer mes);

    List<CosteoProduccion> findAllByOrdenTrabajoIdIn(List<Long> ordenTrabajoIds);
}
