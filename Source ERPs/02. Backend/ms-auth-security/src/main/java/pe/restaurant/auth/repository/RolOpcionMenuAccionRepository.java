package pe.restaurant.auth.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.auth.entity.RolOpcionMenuAccion;

import java.util.List;
import java.util.Optional;

public interface RolOpcionMenuAccionRepository extends JpaRepository<RolOpcionMenuAccion, Long> {

    List<RolOpcionMenuAccion> findAllByRolOpcionMenuId(Long rolOpcionMenuId);

    Optional<RolOpcionMenuAccion> findByRolOpcionMenuIdAndAccionId(Long rolOpcionMenuId, Long accionId);
}
