package pe.restaurant.auth.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.auth.entity.Rol;

import java.util.List;
import java.util.Optional;

public interface RolRepository extends JpaRepository<Rol, Long> {

    List<Rol> findAllByEmpresaIdOrderByNombreAsc(Long empresaId);

    Optional<Rol> findByEmpresaIdAndCodigo(Long empresaId, String codigo);
}
