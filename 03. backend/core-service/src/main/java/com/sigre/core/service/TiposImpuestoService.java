package com.sigre.core.service;

import com.sigre.core.entity.TiposImpuesto;

import java.util.List;

public interface TiposImpuestoService {
    List<TiposImpuesto> findAll();
    TiposImpuesto findById(Long id);
    TiposImpuesto findByTipoImpuesto(String tipoImpuesto);
    TiposImpuesto create(TiposImpuesto entity);
    TiposImpuesto update(Long id, TiposImpuesto entity);
    void delete(Long id);
    TiposImpuesto activate(Long id);
    TiposImpuesto deactivate(Long id);
}
