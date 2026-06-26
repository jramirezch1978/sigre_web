package pe.restaurant.compras.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.compras.entity.ArticuloEstructura;
import pe.restaurant.compras.entity.ArticuloEstructuraId;

public interface ArticuloEstructuraService {

    Page<ArticuloEstructura> findAll(Long articuloPadreId, Pageable pageable);

    ArticuloEstructura findById(ArticuloEstructuraId id);

    ArticuloEstructura create(ArticuloEstructura entity);

    ArticuloEstructura update(ArticuloEstructuraId id, ArticuloEstructura entity);

    void delete(ArticuloEstructuraId id);
}
