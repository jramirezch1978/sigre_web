package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.DocTipoNum;

import java.util.Optional;

public interface DocTipoNumRepository extends JpaRepository<DocTipoNum, Long> {

    Optional<DocTipoNum> findBySucursalIdAndDocTipoIdAndOrigenIdAndAnio(
            Long sucursalId, Long docTipoId, Long origenId, Integer anio);
}
