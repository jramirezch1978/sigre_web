package pe.restaurant.finanzas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.finanzas.dto.request.ConciliacionBancariaRequest;
import pe.restaurant.finanzas.dto.request.ConciliarPartidasRequest;
import pe.restaurant.finanzas.dto.response.CerrarConciliacionResponse;
import pe.restaurant.finanzas.dto.response.ConciliacionBancariaResponse;
import pe.restaurant.finanzas.dto.response.ConciliarPartidasResponse;

public interface ConciliacionBancariaService {

    Page<ConciliacionBancariaResponse> listar(Long bancoCntaId, Integer periodoAnio, 
                                               Integer periodoMes, String estado, Pageable pageable);

    ConciliacionBancariaResponse obtenerPorId(Long id);

    ConciliacionBancariaResponse crear(ConciliacionBancariaRequest request);

    ConciliacionBancariaResponse actualizar(Long id, ConciliacionBancariaRequest request);

    ConciliarPartidasResponse conciliar(Long id, ConciliarPartidasRequest request);

    CerrarConciliacionResponse cerrar(Long id);
}
