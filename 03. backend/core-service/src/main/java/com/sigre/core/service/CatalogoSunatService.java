package com.sigre.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.core.entity.CatalogoSunat;

public interface CatalogoSunatService {

    Page<CatalogoSunat> findAll(String codigoCatalogo, String nombreCatalogo, String flagEstado, Pageable pageable);

    CatalogoSunat findById(Long id);

    CatalogoSunat create(CatalogoSunat entity);

    CatalogoSunat update(Long id, CatalogoSunat entity);

    CatalogoSunat activate(Long id);

    CatalogoSunat deactivate(Long id);
}
