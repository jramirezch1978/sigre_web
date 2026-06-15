package com.sigre.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.core.entity.NaturalezaContable;

public interface NaturalezaContableService {
    Page<NaturalezaContable> findAll(Pageable pageable);
    NaturalezaContable findById(Long id);
    NaturalezaContable create(NaturalezaContable entity);
    NaturalezaContable update(Long id, NaturalezaContable entity);
    void delete(Long id);
    NaturalezaContable activate(Long id);
    NaturalezaContable deactivate(Long id);
}
