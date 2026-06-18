package pe.restaurant.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.core.entity.ArticuloSubCateg;

import java.util.List;

public interface ArticuloSubCategService {
    Page<ArticuloSubCateg> findAll(Pageable pageable);
    List<ArticuloSubCateg> findByCategoria(Long articuloCategId);
    ArticuloSubCateg findById(Long id);
    ArticuloSubCateg create(ArticuloSubCateg entity);
    ArticuloSubCateg update(Long id, ArticuloSubCateg entity);
    ArticuloSubCateg activate(Long id);
    ArticuloSubCateg deactivate(Long id);
    void delete(Long id);
}
