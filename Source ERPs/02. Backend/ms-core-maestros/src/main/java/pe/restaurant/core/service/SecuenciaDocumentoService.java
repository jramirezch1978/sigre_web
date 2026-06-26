package pe.restaurant.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.core.entity.SecuenciaDocumento;

public interface SecuenciaDocumentoService {
    Page<SecuenciaDocumento> findAll(Pageable pageable);
    SecuenciaDocumento findById(Long id);
    SecuenciaDocumento create(SecuenciaDocumento entity);
    SecuenciaDocumento update(Long id, SecuenciaDocumento entity);
    void delete(Long id);
}
