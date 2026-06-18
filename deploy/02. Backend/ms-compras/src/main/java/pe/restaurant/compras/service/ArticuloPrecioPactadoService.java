package pe.restaurant.compras.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.compras.entity.ArticuloPrecioPactado;

public interface ArticuloPrecioPactadoService {

    Page<ArticuloPrecioPactado> findAll(Long articuloId, Long proveedorId, Pageable pageable);

    ArticuloPrecioPactado findById(Long id);

    ArticuloPrecioPactado create(ArticuloPrecioPactado entity);

    ArticuloPrecioPactado update(Long id, ArticuloPrecioPactado entity);

    void delete(Long id);

    ArticuloPrecioPactado activate(Long id);

    ArticuloPrecioPactado deactivate(Long id);
}
