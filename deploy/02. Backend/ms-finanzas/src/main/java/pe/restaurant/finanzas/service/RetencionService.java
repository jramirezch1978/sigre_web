package pe.restaurant.finanzas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.finanzas.dto.request.RetencionRequest;
import pe.restaurant.finanzas.dto.response.RetencionResponse;

public interface RetencionService {

    Page<RetencionResponse> listar(String nroCertificado, Long cntasPagarId, String flagEstado, Pageable pageable);

    RetencionResponse obtenerPorId(Long id);

    RetencionResponse crear(RetencionRequest request);

    RetencionResponse actualizar(Long id, RetencionRequest request);

    RetencionResponse activar(Long id);

    RetencionResponse desactivar(Long id);
}
