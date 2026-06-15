package com.sigre.finanzas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.finanzas.dto.request.LetraCanjeRequest;
import com.sigre.finanzas.dto.response.LetraCanjeDetalleResponse;
import com.sigre.finanzas.dto.response.LetraCanjeResponse;

import java.time.LocalDate;

public interface LetraCanjeService {
    
    Page<LetraCanjeResponse> listarCanjes(String referencia, Long proveedorId, 
                                          LocalDate fechaDesde, LocalDate fechaHasta, 
                                          Pageable pageable);
    
    LetraCanjeDetalleResponse obtenerCanjePorReferencia(String referencia);
    
    LetraCanjeDetalleResponse ejecutarCanje(LetraCanjeRequest request);
    
    LetraCanjeDetalleResponse anularCanje(String referencia);
}
