package com.sigre.finanzas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.finanzas.dto.request.GrupoCodigoFlujoCajaRequest;
import com.sigre.finanzas.dto.response.GrupoCodigoFlujoCajaResponse;
import com.sigre.finanzas.dto.response.PageData;

public interface GrupoCodigoFlujoCajaService {

    PageData<GrupoCodigoFlujoCajaResponse> findAll(Pageable pageable);
    
    GrupoCodigoFlujoCajaResponse findById(Long id);
    
    GrupoCodigoFlujoCajaResponse create(GrupoCodigoFlujoCajaRequest request);
    
    GrupoCodigoFlujoCajaResponse update(Long id, GrupoCodigoFlujoCajaRequest request);
    
    void deleteById(Long id);
    
    GrupoCodigoFlujoCajaResponse activate(Long id);
    
    GrupoCodigoFlujoCajaResponse deactivate(Long id);
}
