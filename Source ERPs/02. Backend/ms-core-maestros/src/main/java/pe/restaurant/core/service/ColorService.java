package pe.restaurant.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.core.entity.Color;

public interface ColorService {
    Page<Color> findAll(Pageable pageable);
    Color findById(Long id);
    Color create(Color entity);
    Color update(Long id, Color entity);
    void delete(Long id);
    Color activate(Long id);
    Color deactivate(Long id);
}
