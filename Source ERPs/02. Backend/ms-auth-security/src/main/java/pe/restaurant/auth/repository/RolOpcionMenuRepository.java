package pe.restaurant.auth.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.auth.entity.RolOpcionMenu;

import java.util.List;
import java.util.Optional;

public interface RolOpcionMenuRepository extends JpaRepository<RolOpcionMenu, Long> {

    List<RolOpcionMenu> findAllByRolId(Long rolId);

    Optional<RolOpcionMenu> findByRolIdAndOpcionMenuId(Long rolId, Long opcionMenuId);
}
