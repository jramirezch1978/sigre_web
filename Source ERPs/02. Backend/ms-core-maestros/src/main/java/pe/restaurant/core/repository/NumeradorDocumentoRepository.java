package pe.restaurant.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import pe.restaurant.core.entity.NumeradorDocumento;

public interface NumeradorDocumentoRepository
        extends JpaRepository<NumeradorDocumento, NumeradorDocumento.NumeradorDocumentoId> {
}
