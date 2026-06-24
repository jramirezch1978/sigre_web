package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.TipoSangreCreateRequest;
import com.sigre.rrhh.dto.request.TipoSangreUpdateRequest;
import com.sigre.rrhh.dto.response.TipoSangreResponse;
import java.util.List;

public interface TipoSangreService {
    Page<TipoSangreResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);
    TipoSangreResponse obtenerPorId(Long id);
    TipoSangreResponse crear(TipoSangreCreateRequest request);
    TipoSangreResponse actualizar(Long id, TipoSangreUpdateRequest request);
    TipoSangreResponse desactivar(Long id);
    TipoSangreResponse activar(Long id);
    List<TipoSangreResponse> listarActivos();
}
