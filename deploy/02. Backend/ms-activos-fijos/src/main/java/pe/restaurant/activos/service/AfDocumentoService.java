package pe.restaurant.activos.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.entity.AfDocumento;

import java.util.List;

public interface AfDocumentoService {
    Page<AfDocumento> findAll(Pageable pageable);
    AfDocumento findById(Long id);
    AfDocumento create(AfDocumento entity);
    AfDocumento update(Long id, AfDocumento entity);
    void delete(Long id);
    List<AfDocumento> findByActivo(Long activoId);
    Page<AfDocumento> findByTipo(String tipoDocumento, Pageable pageable);
}
