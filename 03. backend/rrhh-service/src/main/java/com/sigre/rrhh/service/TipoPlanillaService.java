package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.TipoPlanillaCreateRequest;
import com.sigre.rrhh.dto.request.TipoPlanillaUpdateRequest;
import com.sigre.rrhh.dto.response.TipoPlanillaResponse;

public interface TipoPlanillaService {
    Page<TipoPlanillaResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);
    TipoPlanillaResponse obtenerPorId(Long id);
    TipoPlanillaResponse crear(TipoPlanillaCreateRequest request);
    TipoPlanillaResponse actualizar(Long id, TipoPlanillaUpdateRequest request);
    TipoPlanillaResponse desactivar(Long id);
    TipoPlanillaResponse activar(Long id);
    java.util.List<TipoPlanillaResponse> listarActivos();
}
