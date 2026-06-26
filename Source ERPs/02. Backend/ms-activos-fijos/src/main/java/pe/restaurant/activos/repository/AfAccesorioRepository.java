package pe.restaurant.activos.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.activos.entity.AfAccesorio;

import java.util.List;

public interface AfAccesorioRepository extends JpaRepository<AfAccesorio, Long> {

    List<AfAccesorio> findByAfMaestroIdOrderByFechaInstalacionDesc(Long afMaestroId);
}
