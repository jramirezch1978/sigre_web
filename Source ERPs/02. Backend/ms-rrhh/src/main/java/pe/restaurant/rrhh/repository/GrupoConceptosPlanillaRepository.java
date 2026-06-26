package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.rrhh.entity.GrupoConceptosPlanilla;

import java.util.Optional;

public interface GrupoConceptosPlanillaRepository extends JpaRepository<GrupoConceptosPlanilla, Long> {

    Optional<GrupoConceptosPlanilla> findByCodigo(String codigo);
}
