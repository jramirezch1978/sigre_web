package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.TipoZonaCreateRequest;
import com.sigre.rrhh.dto.request.TipoZonaUpdateRequest;
import com.sigre.rrhh.dto.response.TipoZonaResponse;
import java.util.List;

public interface TipoZonaService {
    Page<TipoZonaResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);
    TipoZonaResponse obtenerPorId(Long id);
    TipoZonaResponse crear(TipoZonaCreateRequest request);
    TipoZonaResponse actualizar(Long id, TipoZonaUpdateRequest request);
    TipoZonaResponse desactivar(Long id);
    TipoZonaResponse activar(Long id);
    List<TipoZonaResponse> listarActivos();
}
