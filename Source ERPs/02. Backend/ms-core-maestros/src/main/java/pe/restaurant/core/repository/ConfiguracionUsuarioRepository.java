package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.ConfiguracionUsuario;

import java.util.List;
import java.util.Optional;

public interface ConfiguracionUsuarioRepository extends JpaRepository<ConfiguracionUsuario, Long> {
    List<ConfiguracionUsuario> findByUsuarioIdAndFlagEstado(Long usuarioId, String flagEstado);
    Optional<ConfiguracionUsuario> findByUsuarioIdAndParametroAndFlagEstado(Long usuarioId, String parametro, String flagEstado);
}
