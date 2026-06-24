package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.OcupacionRtpsCreateRequest;
import com.sigre.rrhh.dto.request.OcupacionRtpsUpdateRequest;
import com.sigre.rrhh.dto.response.OcupacionRtpsResponse;
import java.util.List;

public interface OcupacionRtpsService {
    Page<OcupacionRtpsResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);
    OcupacionRtpsResponse obtenerPorId(Long id);
    OcupacionRtpsResponse crear(OcupacionRtpsCreateRequest request);
    OcupacionRtpsResponse actualizar(Long id, OcupacionRtpsUpdateRequest request);
    OcupacionRtpsResponse desactivar(Long id);
    OcupacionRtpsResponse activar(Long id);
    List<OcupacionRtpsResponse> listarActivos();
}
