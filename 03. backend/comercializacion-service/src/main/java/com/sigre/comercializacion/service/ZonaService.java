package com.sigre.comercializacion.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.comercializacion.dto.request.ZonaRequest;
import com.sigre.comercializacion.dto.response.ZonaResponse;
import com.sigre.comercializacion.entity.Zona;

import java.util.List;

public interface ZonaService {
    
    Page<Zona> findAll(Pageable pageable);
    
    Page<Zona> findAllWithFilters(Long sucursalId, String nombre, String flagEstado, Pageable pageable);
    
    ZonaResponse findById(Long id);
    
    List<ZonaResponse> findBySucursalId(Long sucursalId);
    
    List<ZonaResponse> findAllActivas();
    
    Zona create(Zona entity);
    
    Zona update(Long id, Zona entity);
    
    Zona activate(Long id);
    
    Zona deactivate(Long id);
    
    void delete(Long id);
}
