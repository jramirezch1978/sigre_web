package com.sigre.produccion.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.produccion.dto.response.EjecutorResponse;
import com.sigre.produccion.entity.Ejecutor;

import java.util.List;

public interface EjecutorService {

    Page<Ejecutor> findAll(String codigo, String nombre, String flagEstado, String flagExterno, Pageable pageable);

    Ejecutor findById(Long id);

    Ejecutor create(Ejecutor entity);

    Ejecutor update(Long id, Ejecutor entity);

    Ejecutor activate(Long id);

    Ejecutor deactivate(Long id);

    void delete(Long id);

    void enrich(List<EjecutorResponse> responses);
}
