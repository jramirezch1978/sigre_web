package com.sigre.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.core.entity.Moneda;

public interface MonedaService {
    Page<Moneda> findAll(Pageable pageable);
    Moneda findById(Long id);
    Moneda create(Moneda entity);
    Moneda update(Long id, Moneda entity);
    Moneda activate(Long id);
    Moneda deactivate(Long id);
    void delete(Long id);
}
