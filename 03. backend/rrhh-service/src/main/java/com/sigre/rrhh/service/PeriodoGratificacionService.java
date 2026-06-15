package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.PeriodoGratificacionCreateRequest;
import com.sigre.rrhh.dto.request.PeriodoGratificacionUpdateRequest;
import com.sigre.rrhh.dto.response.PeriodoGratificacionResponse;

public interface PeriodoGratificacionService {
    Page<PeriodoGratificacionResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);
    PeriodoGratificacionResponse obtenerPorId(Long id);
    PeriodoGratificacionResponse crear(PeriodoGratificacionCreateRequest request);
    PeriodoGratificacionResponse actualizar(Long id, PeriodoGratificacionUpdateRequest request);
    PeriodoGratificacionResponse desactivar(Long id);
    PeriodoGratificacionResponse activar(Long id);
    java.util.List<PeriodoGratificacionResponse> listarActivos();
}
