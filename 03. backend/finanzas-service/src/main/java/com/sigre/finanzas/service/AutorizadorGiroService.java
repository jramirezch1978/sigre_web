package com.sigre.finanzas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.finanzas.dto.request.AutorizadorGiroRequest;
import com.sigre.finanzas.dto.response.AutorizadorGiroResponse;

import java.util.List;

public interface AutorizadorGiroService {

    Page<AutorizadorGiroResponse> findAll(Pageable pageable);
    
    AutorizadorGiroResponse findById(Long id);
    
    AutorizadorGiroResponse create(AutorizadorGiroRequest request);
    
    AutorizadorGiroResponse update(Long id, AutorizadorGiroRequest request);
    
    void deleteById(Long id);
    
    AutorizadorGiroResponse activate(Long id);
    
    AutorizadorGiroResponse deactivate(Long id);
    
    List<AutorizadorGiroResponse> findByCentroCosto(Long centrosCostoId);
    
    List<AutorizadorGiroResponse> findActivosByCentroCosto(Long centrosCostoId);
}
