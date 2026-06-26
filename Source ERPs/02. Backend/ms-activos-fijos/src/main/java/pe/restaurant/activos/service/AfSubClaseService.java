package pe.restaurant.activos.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.entity.AfSubClase;

public interface AfSubClaseService {
    Page<AfSubClase> findAll(Pageable pageable);
    AfSubClase findById(Long id);
    AfSubClase create(AfSubClase entity);
    AfSubClase update(Long id, AfSubClase entity);
    AfSubClase activate(Long id);
    AfSubClase deactivate(Long id);
    void delete(Long id);
}
