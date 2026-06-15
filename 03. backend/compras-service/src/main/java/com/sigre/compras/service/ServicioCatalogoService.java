package com.sigre.compras.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.compras.entity.ServicioCatalogo;

public interface ServicioCatalogoService {

    Page<ServicioCatalogo> findAll(Pageable pageable);

    ServicioCatalogo findById(Long id);

    ServicioCatalogo create(ServicioCatalogo entity);

    ServicioCatalogo update(Long id, ServicioCatalogo entity);

    void delete(Long id);

    ServicioCatalogo activate(Long id);

    ServicioCatalogo deactivate(Long id);
}
