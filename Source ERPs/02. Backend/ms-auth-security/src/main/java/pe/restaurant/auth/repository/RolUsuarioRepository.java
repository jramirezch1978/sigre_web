package pe.restaurant.auth.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.auth.entity.RolUsuario;

import java.util.List;
import java.util.Optional;

public interface RolUsuarioRepository extends JpaRepository<RolUsuario, Long> {

    List<RolUsuario> findAllByUsuarioId(Long usuarioId);

    List<RolUsuario> findAllByRolId(Long rolId);

    Optional<RolUsuario> findByUsuarioIdAndRolId(Long usuarioId, Long rolId);
}
