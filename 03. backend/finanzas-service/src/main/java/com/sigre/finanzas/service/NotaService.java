package com.sigre.finanzas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.finanzas.dto.request.NotaRequest;
import com.sigre.finanzas.dto.response.NotaResponse;

public interface NotaService {
    
    Page<NotaResponse> listarNotas(Pageable pageable);
    
    NotaResponse obtenerNotaPorId(Long id);
    
    NotaResponse crearNota(NotaRequest request);
    
    NotaResponse anularNota(Long id);
}
