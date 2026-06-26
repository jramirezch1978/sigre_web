package pe.restaurant.activos.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.activos.entity.AfRevaluacion;

import java.util.List;

public interface AfRevaluacionRepository extends JpaRepository<AfRevaluacion, Long> {

    List<AfRevaluacion> findByAfMaestroIdOrderByFechaDesc(Long afMaestroId);
}
