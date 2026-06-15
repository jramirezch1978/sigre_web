package com.sigre.comercializacion.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.comercializacion.dto.request.CanalDistribucionRequest;
import com.sigre.comercializacion.dto.response.CanalDistribucionResponse;
import com.sigre.comercializacion.entity.CanalDistribucion;

public interface CanalDistribucionService {

    Page<CanalDistribucion> findAll(Pageable pageable);

    // Método con filtros según contrato: codigo, nombre, flagEstado
    Page<CanalDistribucion> findAllWithFilters(String codigo, String nombre, String flagEstado, Pageable pageable);

    CanalDistribucion findById(Long id);

    CanalDistribucion create(CanalDistribucion entity);

    CanalDistribucion update(Long id, CanalDistribucion entity);

    void delete(Long id);

    CanalDistribucion activate(Long id);

    CanalDistribucion deactivate(Long id);
}
