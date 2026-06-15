package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.SexoCreateRequest;
import com.sigre.rrhh.dto.request.SexoUpdateRequest;
import com.sigre.rrhh.dto.response.SexoResponse;

public interface SexoService {
    Page<SexoResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);
    SexoResponse obtenerPorId(Long id);
    SexoResponse crear(SexoCreateRequest request);
    SexoResponse actualizar(Long id, SexoUpdateRequest request);
    SexoResponse desactivar(Long id);
    SexoResponse activar(Long id);
    java.util.List<SexoResponse> listarActivos();
}
