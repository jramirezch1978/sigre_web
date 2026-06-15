package com.sigre.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.core.entity.ArticuloCateg;

public interface ArticuloCategService {
    Page<ArticuloCateg> findAll(Pageable pageable);
    ArticuloCateg findById(Long id);
    ArticuloCateg create(ArticuloCateg entity);
    ArticuloCateg update(Long id, ArticuloCateg entity);
    ArticuloCateg activate(Long id);
    ArticuloCateg deactivate(Long id);
    void delete(Long id);
}
