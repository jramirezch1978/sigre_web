package pe.restaurant.finanzas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.finanzas.dto.request.LetraCanjeRequest;
import pe.restaurant.finanzas.dto.response.LetraCanjeDetalleResponse;
import pe.restaurant.finanzas.dto.response.LetraCanjeResponse;

import java.time.LocalDate;

public interface LetraCanjeService {
    
    Page<LetraCanjeResponse> listarCanjes(String referencia, Long proveedorId, 
                                          LocalDate fechaDesde, LocalDate fechaHasta, 
                                          Pageable pageable);
    
    LetraCanjeDetalleResponse obtenerCanjePorReferencia(String referencia);
    
    LetraCanjeDetalleResponse ejecutarCanje(LetraCanjeRequest request);
    
    LetraCanjeDetalleResponse anularCanje(String referencia);
}
