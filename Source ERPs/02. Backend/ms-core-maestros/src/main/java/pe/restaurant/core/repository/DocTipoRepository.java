package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.DocTipo;

import java.util.Optional;

public interface DocTipoRepository extends JpaRepository<DocTipo, Long> {

    Optional<DocTipo> findByCodigo(String codigo);
}
