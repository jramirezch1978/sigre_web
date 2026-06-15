package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.TurnoRequest;
import com.sigre.rrhh.dto.response.TurnoResponse;

import java.util.List;

public interface TurnoService {
    Page<TurnoResponse> listar(String nombre, String flagEstado, Pageable pageable);
    TurnoResponse obtenerPorId(Long id);
    TurnoResponse crear(TurnoRequest request);
    TurnoResponse actualizar(Long id, TurnoRequest request);
    TurnoResponse desactivar(Long id);
    TurnoResponse activar(Long id);
    List<TurnoResponse> listarActivos();
}
