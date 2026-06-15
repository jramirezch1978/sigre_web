package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.TipoSancionCreateRequest;
import com.sigre.rrhh.dto.request.TipoSancionUpdateRequest;
import com.sigre.rrhh.dto.response.TipoSancionResponse;

public interface TipoSancionService {
    Page<TipoSancionResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);
    TipoSancionResponse obtenerPorId(Long id);
    TipoSancionResponse crear(TipoSancionCreateRequest request);
    TipoSancionResponse actualizar(Long id, TipoSancionUpdateRequest request);
    TipoSancionResponse desactivar(Long id);
    TipoSancionResponse activar(Long id);
    java.util.List<TipoSancionResponse> listarActivos();
}
