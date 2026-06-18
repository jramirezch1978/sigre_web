package pe.restaurant.finanzas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.finanzas.dto.request.GrupoCodigoFlujoCajaRequest;
import pe.restaurant.finanzas.dto.response.GrupoCodigoFlujoCajaResponse;
import pe.restaurant.finanzas.dto.response.PageData;

public interface GrupoCodigoFlujoCajaService {

    PageData<GrupoCodigoFlujoCajaResponse> findAll(Pageable pageable);
    
    GrupoCodigoFlujoCajaResponse findById(Long id);
    
    GrupoCodigoFlujoCajaResponse create(GrupoCodigoFlujoCajaRequest request);
    
    GrupoCodigoFlujoCajaResponse update(Long id, GrupoCodigoFlujoCajaRequest request);
    
    void deleteById(Long id);
    
    GrupoCodigoFlujoCajaResponse activate(Long id);
    
    GrupoCodigoFlujoCajaResponse deactivate(Long id);
}
