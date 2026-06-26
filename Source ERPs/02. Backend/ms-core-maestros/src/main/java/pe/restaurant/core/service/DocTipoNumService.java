package pe.restaurant.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.core.entity.DocTipoNum;

public interface DocTipoNumService {
    Page<DocTipoNum> findAll(Pageable pageable);
    DocTipoNum findById(Long id);
    DocTipoNum create(DocTipoNum entity);
    DocTipoNum update(Long id, DocTipoNum entity);
    void delete(Long id);
    DocTipoNum activate(Long id);
    DocTipoNum deactivate(Long id);
}
