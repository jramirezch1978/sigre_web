package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.PrestamoCreateRequest;
import com.sigre.rrhh.dto.request.PrestamoUpdateRequest;
import com.sigre.rrhh.dto.response.PrestamoResponse;

public interface PrestamoService {
    Page<PrestamoResponse> listar(Long trabajadorId, String flagEstado, Pageable pageable);
    PrestamoResponse obtenerPorId(Long id);
    PrestamoResponse crear(PrestamoCreateRequest request);
    PrestamoResponse actualizar(Long id, PrestamoUpdateRequest request);
    PrestamoResponse cambiarEstado(Long id);
}
