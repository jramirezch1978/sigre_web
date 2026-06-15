package com.sigre.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.core.entity.ArticuloClase;

public interface ArticuloClaseService {
    Page<ArticuloClase> findAll(Pageable pageable);
    ArticuloClase findById(Long id);
    ArticuloClase create(ArticuloClase entity);
    ArticuloClase update(Long id, ArticuloClase entity);
    ArticuloClase activate(Long id);
    ArticuloClase deactivate(Long id);
    void delete(Long id);
}
