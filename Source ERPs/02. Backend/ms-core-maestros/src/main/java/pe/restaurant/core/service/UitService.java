package pe.restaurant.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.core.entity.Uit;

public interface UitService {
    Page<Uit> findAll(Pageable pageable);
    Uit findById(Long id);
    Uit create(Uit entity);
    Uit update(Long id, Uit entity);
    void delete(Long id);
    Uit activate(Long id);
    Uit deactivate(Long id);
}
