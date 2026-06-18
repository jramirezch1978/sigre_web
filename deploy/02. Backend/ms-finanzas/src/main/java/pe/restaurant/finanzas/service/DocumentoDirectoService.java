package pe.restaurant.finanzas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.finanzas.dto.request.DocumentoDirectoRequest;
import pe.restaurant.finanzas.dto.response.DocumentoDirectoResponse;

public interface DocumentoDirectoService {
    
    Page<DocumentoDirectoResponse> listarDirectos(Pageable pageable);
    
    DocumentoDirectoResponse obtenerDirectoPorId(Long id);
    
    DocumentoDirectoResponse crearDirecto(DocumentoDirectoRequest request);
    
    DocumentoDirectoResponse actualizarDirecto(Long id, DocumentoDirectoRequest request);
    
    DocumentoDirectoResponse anularDirecto(Long id);
}
