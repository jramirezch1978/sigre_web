package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.ProgramVacacionCreateRequest;
import com.sigre.rrhh.dto.request.ProgramVacacionImportarRequest;
import com.sigre.rrhh.dto.request.ProgramVacacionUpdateRequest;
import com.sigre.rrhh.dto.response.ProgramVacacionResponse;

import java.util.List;

public interface ProgramVacacionService {
    Page<ProgramVacacionResponse> listar(Long trabajadorId, Integer anio, Pageable pageable);
    ProgramVacacionResponse obtenerPorId(Long id);
    ProgramVacacionResponse crear(ProgramVacacionCreateRequest request);
    ProgramVacacionResponse actualizar(Long id, ProgramVacacionUpdateRequest request);
    ProgramVacacionResponse desactivar(Long id);
    List<ProgramVacacionResponse> importar(ProgramVacacionImportarRequest request);
    byte[] exportarExcel(Integer anio);
}
