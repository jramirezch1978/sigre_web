package com.sigre.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.core.entity.ParametroSistema;

import java.util.List;

public interface ParametroSistemaService {
    Page<ParametroSistema> findAll(String codigo, String modulo, Pageable pageable);
    ParametroSistema findById(Long id);
    ParametroSistema create(ParametroSistema entity);
    ParametroSistema update(Long id, ParametroSistema entity);
    List<ParametroSistema> updateBatch(List<ParametroSistema> entities);
    void delete(Long id);
    ParametroSistema activate(Long id);
    ParametroSistema deactivate(Long id);
}
