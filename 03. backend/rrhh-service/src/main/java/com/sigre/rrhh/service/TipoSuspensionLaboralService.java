package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.TipoSuspensionLaboralCreateRequest;
import com.sigre.rrhh.dto.request.TipoSuspensionLaboralUpdateRequest;
import com.sigre.rrhh.dto.response.TipoSuspensionLaboralResponse;

public interface TipoSuspensionLaboralService {

    Page<TipoSuspensionLaboralResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);

    TipoSuspensionLaboralResponse obtenerPorId(Long id);

    TipoSuspensionLaboralResponse crear(TipoSuspensionLaboralCreateRequest request);

    TipoSuspensionLaboralResponse actualizar(Long id, TipoSuspensionLaboralUpdateRequest request);

    TipoSuspensionLaboralResponse desactivar(Long id);

    TipoSuspensionLaboralResponse activar(Long id);

    java.util.List<TipoSuspensionLaboralResponse> listarActivos();
}
