package com.sigre.produccion.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.produccion.entity.OtTipo;

public interface OtTipoService {

    Page<OtTipo> findAll(String codigo, String nombre, String flagEstado, Pageable pageable);

    OtTipo findById(Long id);

    OtTipo create(OtTipo entity);

    OtTipo update(Long id, OtTipo entity);

    OtTipo activate(Long id);

    OtTipo deactivate(Long id);

    void delete(Long id);
}
