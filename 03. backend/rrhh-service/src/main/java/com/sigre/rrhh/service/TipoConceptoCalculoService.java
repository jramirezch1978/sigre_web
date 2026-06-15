package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.TipoConceptoCalculoCreateRequest;
import com.sigre.rrhh.dto.request.TipoConceptoCalculoUpdateRequest;
import com.sigre.rrhh.dto.response.TipoConceptoCalculoResponse;

public interface TipoConceptoCalculoService {
    Page<TipoConceptoCalculoResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);
    TipoConceptoCalculoResponse obtenerPorId(Long id);
    TipoConceptoCalculoResponse crear(TipoConceptoCalculoCreateRequest request);
    TipoConceptoCalculoResponse actualizar(Long id, TipoConceptoCalculoUpdateRequest request);
    TipoConceptoCalculoResponse desactivar(Long id);
    TipoConceptoCalculoResponse activar(Long id);
    java.util.List<TipoConceptoCalculoResponse> listarActivos();
}
