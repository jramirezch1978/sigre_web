package pe.restaurant.activos.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.entity.AfUbicacion;

public interface AfUbicacionService {
    Page<AfUbicacion> findAll(Pageable pageable);
    AfUbicacion findById(Long id);
    AfUbicacion create(AfUbicacion entity);
    AfUbicacion update(Long id, AfUbicacion entity);
    AfUbicacion activate(Long id);
    AfUbicacion deactivate(Long id);
    void delete(Long id);
}
