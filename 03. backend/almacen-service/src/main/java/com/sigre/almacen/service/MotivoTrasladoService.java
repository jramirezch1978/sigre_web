package com.sigre.almacen.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.almacen.entity.MotivoTraslado;

public interface MotivoTrasladoService {

    Page<MotivoTraslado> findAll(Pageable pageable);

    MotivoTraslado findById(Long id);

    MotivoTraslado create(MotivoTraslado entity);

    MotivoTraslado update(Long id, MotivoTraslado entity);

    MotivoTraslado activate(Long id);

    MotivoTraslado deactivate(Long id);

    void delete(Long id);
}
