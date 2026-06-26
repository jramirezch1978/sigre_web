package pe.restaurant.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.core.entity.NumeradorDocumento;

public interface NumeradorDocumentoService {
    Page<NumeradorDocumento> findAll(Pageable pageable);
    NumeradorDocumento findById(NumeradorDocumento.NumeradorDocumentoId id);
    NumeradorDocumento create(NumeradorDocumento entity);
    NumeradorDocumento update(NumeradorDocumento entity);
    void delete(NumeradorDocumento.NumeradorDocumentoId id);
    NumeradorDocumento activate(NumeradorDocumento.NumeradorDocumentoId id);
    NumeradorDocumento deactivate(NumeradorDocumento.NumeradorDocumentoId id);
}
