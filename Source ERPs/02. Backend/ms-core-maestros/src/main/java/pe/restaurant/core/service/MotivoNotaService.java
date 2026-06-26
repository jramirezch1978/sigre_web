package pe.restaurant.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.core.entity.MotivoNota;

public interface MotivoNotaService {
    Page<MotivoNota> findAll(Pageable pageable);
    MotivoNota findById(Long id);
    MotivoNota create(MotivoNota entity);
    MotivoNota update(Long id, MotivoNota entity);
    void delete(Long id);
    MotivoNota activate(Long id);
    MotivoNota deactivate(Long id);
}
