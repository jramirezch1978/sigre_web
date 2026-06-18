package pe.restaurant.produccion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import pe.restaurant.produccion.entity.Operacion;

import java.util.List;

public interface OperacionRepository extends JpaRepository<Operacion, Long>,
        JpaSpecificationExecutor<Operacion> {

    List<Operacion> findByOrdenTrabajoIdOrderByIdAsc(Long ordenTrabajoId);

    long countByOrdenTrabajoIdAndFlagEstado(Long ordenTrabajoId, String flagEstado);
}
