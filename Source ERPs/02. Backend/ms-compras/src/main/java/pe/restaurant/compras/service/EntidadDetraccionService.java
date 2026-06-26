package pe.restaurant.compras.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.compras.entity.EntidadDetraccion;

public interface EntidadDetraccionService {
    Page<EntidadDetraccion> findAll(Pageable pageable);
    EntidadDetraccion findById(Long id);
    EntidadDetraccion create(EntidadDetraccion entity);
    EntidadDetraccion update(Long id, EntidadDetraccion entity);
    void delete(Long id);
    EntidadDetraccion activate(Long id);
    EntidadDetraccion deactivate(Long id);
}
