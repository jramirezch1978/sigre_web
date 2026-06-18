package pe.restaurant.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.core.entity.UnidadMedida;

public interface UnidadMedidaService {
    Page<UnidadMedida> findAll(Pageable pageable);
    UnidadMedida findById(Long id);
    UnidadMedida create(UnidadMedida entity);
    UnidadMedida update(Long id, UnidadMedida entity);
    void delete(Long id);
    UnidadMedida activate(Long id);
    UnidadMedida deactivate(Long id);
}
