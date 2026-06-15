package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.TipoMovimientoCntaCrrteCreateRequest;
import com.sigre.rrhh.dto.request.TipoMovimientoCntaCrrteUpdateRequest;
import com.sigre.rrhh.dto.response.TipoMovimientoCntaCrrteResponse;

public interface TipoMovimientoCntaCrrteService {
    Page<TipoMovimientoCntaCrrteResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);
    TipoMovimientoCntaCrrteResponse obtenerPorId(Long id);
    TipoMovimientoCntaCrrteResponse crear(TipoMovimientoCntaCrrteCreateRequest request);
    TipoMovimientoCntaCrrteResponse actualizar(Long id, TipoMovimientoCntaCrrteUpdateRequest request);
    TipoMovimientoCntaCrrteResponse desactivar(Long id);
    TipoMovimientoCntaCrrteResponse activar(Long id);
    java.util.List<TipoMovimientoCntaCrrteResponse> listarActivos();
}
