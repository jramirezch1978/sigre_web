package pe.restaurant.compras.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.compras.entity.TipoEntidadContribuyente;

public interface TipoEntidadContribuyenteService {

    Page<TipoEntidadContribuyente> findAll(Pageable pageable);

    TipoEntidadContribuyente findById(Long id);

    TipoEntidadContribuyente create(TipoEntidadContribuyente entity);

    TipoEntidadContribuyente update(Long id, TipoEntidadContribuyente entity);

    void delete(Long id);

    TipoEntidadContribuyente activate(Long id);

    TipoEntidadContribuyente deactivate(Long id);
}
