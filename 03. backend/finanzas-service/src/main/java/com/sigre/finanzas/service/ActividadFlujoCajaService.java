package com.sigre.finanzas.service;

import org.springframework.data.domain.Pageable;
import com.sigre.finanzas.dto.response.ActividadFlujoCajaResponse;
import com.sigre.finanzas.dto.response.PageData;
import com.sigre.finanzas.dto.request.ActividadFlujoCajaRequest;

public interface ActividadFlujoCajaService {

    PageData<ActividadFlujoCajaResponse> listar(String flagEstado, String codigo, String nombre, Pageable pageable);

    ActividadFlujoCajaResponse findById(Long id);

    ActividadFlujoCajaResponse create(ActividadFlujoCajaRequest request);

    ActividadFlujoCajaResponse update(Long id, ActividadFlujoCajaRequest request);

    ActividadFlujoCajaResponse activate(Long id);

    ActividadFlujoCajaResponse deactivate(Long id);
}
