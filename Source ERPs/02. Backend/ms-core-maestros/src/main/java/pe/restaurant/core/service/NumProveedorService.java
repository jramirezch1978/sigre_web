package pe.restaurant.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.core.entity.NumProveedor;

public interface NumProveedorService {
    Page<NumProveedor> findAll(Pageable pageable);
    NumProveedor findById(Long id);
    NumProveedor create(NumProveedor entity);
    NumProveedor update(Long id, NumProveedor entity);
    void delete(Long id);
}
