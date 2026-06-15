package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.RegimenLaboralCreateRequest;
import com.sigre.rrhh.dto.request.RegimenLaboralUpdateRequest;
import com.sigre.rrhh.dto.response.RegimenLaboralResponse;

public interface RegimenLaboralService {
    Page<RegimenLaboralResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);
    RegimenLaboralResponse obtenerPorId(Long id);
    RegimenLaboralResponse crear(RegimenLaboralCreateRequest request);
    RegimenLaboralResponse actualizar(Long id, RegimenLaboralUpdateRequest request);
    RegimenLaboralResponse desactivar(Long id);
    RegimenLaboralResponse activar(Long id);
    java.util.List<RegimenLaboralResponse> listarActivos();
}
