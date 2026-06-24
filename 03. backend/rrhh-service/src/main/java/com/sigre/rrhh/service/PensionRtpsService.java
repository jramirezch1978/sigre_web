package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.PensionRtpsCreateRequest;
import com.sigre.rrhh.dto.request.PensionRtpsUpdateRequest;
import com.sigre.rrhh.dto.response.PensionRtpsResponse;
import java.util.List;

public interface PensionRtpsService {
    Page<PensionRtpsResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);
    PensionRtpsResponse obtenerPorId(Long id);
    PensionRtpsResponse crear(PensionRtpsCreateRequest request);
    PensionRtpsResponse actualizar(Long id, PensionRtpsUpdateRequest request);
    PensionRtpsResponse desactivar(Long id);
    PensionRtpsResponse activar(Long id);
    List<PensionRtpsResponse> listarActivos();
}
