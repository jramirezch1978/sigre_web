package pe.restaurant.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.core.entity.Sucursal;

public interface SucursalService {
    Page<Sucursal> findAll(Pageable pageable);
    Sucursal findById(Long id);
    Sucursal create(Sucursal entity);
    Sucursal update(Long id, Sucursal entity);
    void delete(Long id);
    Sucursal activate(Long id);
    Sucursal deactivate(Long id);
}
