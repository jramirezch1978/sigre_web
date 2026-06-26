package pe.restaurant.compras.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.compras.entity.EntidadArticulo;

public interface EntidadArticuloService {
    Page<EntidadArticulo> findAll(Pageable pageable);
    EntidadArticulo findById(Long id);
    EntidadArticulo create(EntidadArticulo entity);
    EntidadArticulo update(Long id, EntidadArticulo entity);
    void delete(Long id);
    EntidadArticulo activate(Long id);
    EntidadArticulo deactivate(Long id);
}
