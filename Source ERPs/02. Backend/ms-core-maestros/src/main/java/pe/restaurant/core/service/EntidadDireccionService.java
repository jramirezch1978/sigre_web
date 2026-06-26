package pe.restaurant.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.core.entity.EntidadDireccion;

public interface EntidadDireccionService {
    Page<EntidadDireccion> findAll(Pageable pageable);
    EntidadDireccion findById(Long id);
    EntidadDireccion create(EntidadDireccion entity);
    EntidadDireccion update(Long id, EntidadDireccion entity);
    void delete(Long id);
    EntidadDireccion activate(Long id);
    EntidadDireccion deactivate(Long id);
}
