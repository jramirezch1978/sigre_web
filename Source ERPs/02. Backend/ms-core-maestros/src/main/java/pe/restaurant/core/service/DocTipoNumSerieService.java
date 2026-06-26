package pe.restaurant.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.core.entity.DocTipoNumSerie;

public interface DocTipoNumSerieService {
    Page<DocTipoNumSerie> findAll(Pageable pageable);
    DocTipoNumSerie findById(Long id);
    DocTipoNumSerie create(DocTipoNumSerie entity);
    DocTipoNumSerie update(Long id, DocTipoNumSerie entity);
    void delete(Long id);
    DocTipoNumSerie activate(Long id);
    DocTipoNumSerie deactivate(Long id);
}
