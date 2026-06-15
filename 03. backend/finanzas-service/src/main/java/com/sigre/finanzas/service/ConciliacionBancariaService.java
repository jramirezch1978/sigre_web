package com.sigre.finanzas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.finanzas.dto.request.ConciliacionBancariaRequest;
import com.sigre.finanzas.dto.request.ConciliarPartidasRequest;
import com.sigre.finanzas.dto.response.CerrarConciliacionResponse;
import com.sigre.finanzas.dto.response.ConciliacionBancariaResponse;
import com.sigre.finanzas.dto.response.ConciliarPartidasResponse;

public interface ConciliacionBancariaService {

    Page<ConciliacionBancariaResponse> listar(Long bancoCntaId, Integer periodoAnio, 
                                               Integer periodoMes, String estado, Pageable pageable);

    ConciliacionBancariaResponse obtenerPorId(Long id);

    ConciliacionBancariaResponse crear(ConciliacionBancariaRequest request);

    ConciliacionBancariaResponse actualizar(Long id, ConciliacionBancariaRequest request);

    ConciliarPartidasResponse conciliar(Long id, ConciliarPartidasRequest request);

    CerrarConciliacionResponse cerrar(Long id);
}
