package pe.restaurant.ventas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.ventas.dto.request.ZonaRequest;
import pe.restaurant.ventas.dto.response.ZonaResponse;
import pe.restaurant.ventas.entity.Zona;

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
