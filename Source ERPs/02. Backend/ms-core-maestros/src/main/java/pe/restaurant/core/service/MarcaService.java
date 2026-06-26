package pe.restaurant.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.core.entity.Marca;

public interface MarcaService {
    Page<Marca> findAll(Pageable pageable);
    Marca findById(Long id);
    Marca create(Marca entity);
    Marca update(Long id, Marca entity);
    void delete(Long id);
    Marca activate(Long id);
    Marca deactivate(Long id);
}
