package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.DocTipoUsuario;

import java.util.List;

public interface DocTipoUsuarioRepository extends JpaRepository<DocTipoUsuario, Long> {

    List<DocTipoUsuario> findByUsuarioId(Long usuarioId);

    List<DocTipoUsuario> findByUsuarioIdAndFlagEstado(Long usuarioId, String flagEstado);
}
