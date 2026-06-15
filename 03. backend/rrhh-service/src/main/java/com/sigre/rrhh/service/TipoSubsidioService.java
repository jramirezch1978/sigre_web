package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.TipoSubsidioCreateRequest;
import com.sigre.rrhh.dto.request.TipoSubsidioUpdateRequest;
import com.sigre.rrhh.dto.response.TipoSubsidioResponse;

public interface TipoSubsidioService {
    Page<TipoSubsidioResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);
    TipoSubsidioResponse obtenerPorId(Long id);
    TipoSubsidioResponse crear(TipoSubsidioCreateRequest request);
    TipoSubsidioResponse actualizar(Long id, TipoSubsidioUpdateRequest request);
    TipoSubsidioResponse desactivar(Long id);
    TipoSubsidioResponse activar(Long id);
    java.util.List<TipoSubsidioResponse> listarActivos();
}
