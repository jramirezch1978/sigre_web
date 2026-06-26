package pe.restaurant.activos.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.activos.entity.AfSoftware;

import java.util.List;

public interface AfSoftwareRepository extends JpaRepository<AfSoftware, Long> {

    List<AfSoftware> findByAfMaestroIdOrderByFechaVigenciaFinDesc(Long afMaestroId);
}
