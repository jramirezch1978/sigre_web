package pe.restaurant.auth.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.auth.entity.UsuarioOpcionMenu;

import java.util.List;
import java.util.Optional;

public interface UsuarioOpcionMenuRepository extends JpaRepository<UsuarioOpcionMenu, Long> {

    List<UsuarioOpcionMenu> findAllByUsuarioIdAndEmpresaId(Long usuarioId, Long empresaId);

    Optional<UsuarioOpcionMenu> findByUsuarioIdAndEmpresaIdAndOpcionMenuId(Long usuarioId, Long empresaId, Long opcionMenuId);
}
