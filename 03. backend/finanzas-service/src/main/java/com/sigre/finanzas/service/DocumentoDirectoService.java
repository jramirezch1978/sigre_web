package com.sigre.finanzas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.finanzas.dto.request.DocumentoDirectoRequest;
import com.sigre.finanzas.dto.response.DocumentoDirectoResponse;

public interface DocumentoDirectoService {
    
    Page<DocumentoDirectoResponse> listarDirectos(Pageable pageable);
    
    DocumentoDirectoResponse obtenerDirectoPorId(Long id);
    
    DocumentoDirectoResponse crearDirecto(DocumentoDirectoRequest request);
    
    DocumentoDirectoResponse actualizarDirecto(Long id, DocumentoDirectoRequest request);
    
    DocumentoDirectoResponse anularDirecto(Long id);
}
