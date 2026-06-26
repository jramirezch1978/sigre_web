package pe.restaurant.activos.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.activos.entity.AfAseguradora;

public interface AfAseguradoraService {
    Page<AfAseguradora> findAll(Pageable pageable);
    AfAseguradora findById(Long id);
    AfAseguradora create(AfAseguradora entity);
    AfAseguradora update(Long id, AfAseguradora entity);
    AfAseguradora activate(Long id);
    AfAseguradora deactivate(Long id);
    void delete(Long id);
}
