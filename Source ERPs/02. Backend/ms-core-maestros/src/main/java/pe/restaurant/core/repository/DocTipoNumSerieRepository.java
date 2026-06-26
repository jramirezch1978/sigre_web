package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.DocTipoNumSerie;

import java.util.Optional;

public interface DocTipoNumSerieRepository extends JpaRepository<DocTipoNumSerie, Long> {

    Optional<DocTipoNumSerie> findBySucursalIdAndDocTipoIdAndSerie(
            Long sucursalId, Long docTipoId, String serie);
}
