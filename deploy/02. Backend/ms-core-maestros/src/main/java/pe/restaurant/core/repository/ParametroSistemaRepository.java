package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import pe.restaurant.core.entity.ParametroSistema;

import java.util.Optional;

public interface ParametroSistemaRepository extends JpaRepository<ParametroSistema, Long>, JpaSpecificationExecutor<ParametroSistema> {
    Optional<ParametroSistema> findByCodigo(String codigo);
}
