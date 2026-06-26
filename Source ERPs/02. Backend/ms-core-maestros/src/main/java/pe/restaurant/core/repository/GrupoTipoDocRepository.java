package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.GrupoTipoDoc;

import java.util.Optional;

public interface GrupoTipoDocRepository extends JpaRepository<GrupoTipoDoc, Long> {

    Optional<GrupoTipoDoc> findByCodigo(String codigo);
}
