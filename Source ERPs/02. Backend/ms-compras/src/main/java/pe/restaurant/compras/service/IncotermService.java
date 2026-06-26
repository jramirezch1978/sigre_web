package pe.restaurant.compras.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.compras.entity.Incoterm;

public interface IncotermService {
    Page<Incoterm> findAll(Pageable pageable);
    Incoterm findById(Long id);
    Incoterm create(Incoterm entity);
    Incoterm update(Long id, Incoterm entity);
    void delete(Long id);
    Incoterm activate(Long id);
    Incoterm deactivate(Long id);
}
