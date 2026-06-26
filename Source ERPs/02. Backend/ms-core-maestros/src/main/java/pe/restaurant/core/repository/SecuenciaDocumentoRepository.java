package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.SecuenciaDocumento;

import java.util.Optional;

public interface SecuenciaDocumentoRepository extends JpaRepository<SecuenciaDocumento, Long> {

    Optional<SecuenciaDocumento> findBySucursalIdAndTipoDocumentoAndSerieAndAnio(
            Long sucursalId, String tipoDocumento, String serie, Integer anio);
}
