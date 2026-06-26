package pe.restaurant.activos.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.entity.AfTipoOperacion;

public interface AfTipoOperacionService {

    Page<AfTipoOperacion> findAll(Pageable pageable);

    AfTipoOperacion findById(Long id);

    AfTipoOperacion create(AfTipoOperacion entity);

    AfTipoOperacion update(Long id, AfTipoOperacion entity);

    void delete(Long id);

    AfTipoOperacion activate(Long id);

    AfTipoOperacion deactivate(Long id);
}
