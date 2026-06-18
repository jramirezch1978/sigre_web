package pe.restaurant.activos.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.entity.AfClase;

public interface AfClaseService {
    Page<AfClase> findAll(Pageable pageable);
    AfClase findById(Long id);
    AfClase create(AfClase entity);
    AfClase update(Long id, AfClase entity);
    AfClase activate(Long id);
    AfClase deactivate(Long id);
    void delete(Long id);
}
