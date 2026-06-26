package pe.restaurant.almacen.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.almacen.entity.ArticuloBonificacion;

public interface ArticuloBonificacionService {

    Page<ArticuloBonificacion> findAll(Long articuloId, Pageable pageable);

    ArticuloBonificacion findById(Long id);

    ArticuloBonificacion create(ArticuloBonificacion entity);

    ArticuloBonificacion update(Long id, ArticuloBonificacion entity);

    void delete(Long id);

    ArticuloBonificacion activate(Long id);

    ArticuloBonificacion deactivate(Long id);
}
