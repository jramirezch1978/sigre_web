package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.ControlSubsidioCreateRequest;
import com.sigre.rrhh.dto.request.ControlSubsidioUpdateRequest;
import com.sigre.rrhh.dto.response.ControlSubsidioResponse;

public interface ControlSubsidioService {
    Page<ControlSubsidioResponse> listar(Pageable pageable);
    ControlSubsidioResponse obtenerPorId(Long id);
    ControlSubsidioResponse crear(ControlSubsidioCreateRequest request);
    ControlSubsidioResponse actualizar(Long id, ControlSubsidioUpdateRequest request);
    ControlSubsidioResponse desactivar(Long id);
}
