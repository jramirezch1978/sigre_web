package com.sigre.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.core.entity.EjercicioPeriodo;

public interface EjercicioPeriodoService {
    Page<EjercicioPeriodo> findAll(Integer anio, Pageable pageable);
    EjercicioPeriodo findById(Long id);
    EjercicioPeriodo create(EjercicioPeriodo entity);
    EjercicioPeriodo update(Long id, EjercicioPeriodo entity);
    void delete(Long id);
    EjercicioPeriodo activate(Long id);
    EjercicioPeriodo deactivate(Long id);
}
