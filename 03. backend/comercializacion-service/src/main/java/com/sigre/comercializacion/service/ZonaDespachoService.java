package com.sigre.comercializacion.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.comercializacion.dto.request.ZonaDespachoRequest;
import com.sigre.comercializacion.dto.response.ZonaDespachoResponse;
import com.sigre.comercializacion.entity.ZonaDespacho;

public interface ZonaDespachoService {

    Page<ZonaDespacho> findAll(Pageable pageable);

    // Método con filtros según contrato: zonaDespacho, descZonaDespacho, ubigeo, flagEstado
    Page<ZonaDespacho> findAllWithFilters(String zonaDespacho, String descZonaDespacho, String ubigeo, String flagEstado, Pageable pageable);

    ZonaDespacho findById(Long id);

    ZonaDespacho create(ZonaDespacho entity);

    ZonaDespacho update(Long id, ZonaDespacho entity);

    void delete(Long id);

    ZonaDespacho activate(Long id);

    ZonaDespacho deactivate(Long id);
}
