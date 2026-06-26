package pe.restaurant.auth.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.auth.entity.UsuarioEmpresa;

import java.util.List;
import java.util.Optional;

public interface UsuarioEmpresaRepository extends JpaRepository<UsuarioEmpresa, Long> {

    List<UsuarioEmpresa> findAllByUsuarioId(Long usuarioId);

    List<UsuarioEmpresa> findAllByEmpresaId(Long empresaId);

    Optional<UsuarioEmpresa> findByUsuarioIdAndEmpresaId(Long usuarioId, Long empresaId);
}
