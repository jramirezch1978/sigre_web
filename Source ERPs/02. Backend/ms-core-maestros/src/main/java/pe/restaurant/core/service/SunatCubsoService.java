package pe.restaurant.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.core.entity.SunatCubso;

public interface SunatCubsoService {
    Page<SunatCubso> findAll(Pageable pageable);
    SunatCubso findById(Long id);
    SunatCubso create(SunatCubso entity);
    SunatCubso update(Long id, SunatCubso entity);
    void delete(Long id);
    SunatCubso activate(Long id);
    SunatCubso deactivate(Long id);
}
