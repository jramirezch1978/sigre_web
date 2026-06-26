package pe.restaurant.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.core.entity.ArticuloEquivalencia;

public interface ArticuloEquivalenciaService {
    Page<ArticuloEquivalencia> findAll(Long articuloId, Pageable pageable);
    ArticuloEquivalencia findById(Long id);
    ArticuloEquivalencia create(ArticuloEquivalencia entity);
    ArticuloEquivalencia update(Long id, ArticuloEquivalencia entity);
    void delete(Long id);
    ArticuloEquivalencia activate(Long id);
    ArticuloEquivalencia deactivate(Long id);
}
