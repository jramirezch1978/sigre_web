package pe.restaurant.activos.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.entity.AfMaestro;

public interface AfMaestroService {
    Page<AfMaestro> findAll(Pageable pageable);
    AfMaestro findById(Long id);
    AfMaestro create(AfMaestro entity);
    AfMaestro update(Long id, AfMaestro entity);
    AfMaestro activate(Long id);
    AfMaestro deactivate(Long id);
    void delete(Long id);
    Page<AfMaestro> findByAfSubClaseId(Long afSubClaseId, Pageable pageable);
    Page<AfMaestro> findByAfUbicacionId(Long afUbicacionId, Pageable pageable);
}
