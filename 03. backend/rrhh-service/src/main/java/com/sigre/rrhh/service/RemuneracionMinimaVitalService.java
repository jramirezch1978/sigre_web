package com.sigre.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.rrhh.dto.request.RemuneracionMinimaVitalCreateRequest;
import com.sigre.rrhh.dto.request.RemuneracionMinimaVitalUpdateRequest;
import com.sigre.rrhh.dto.response.RemuneracionMinimaVitalResponse;

import java.util.List;

public interface RemuneracionMinimaVitalService {

    Page<RemuneracionMinimaVitalResponse> listar(Long tipoTrabajadorId, String flagEstado, Pageable pageable);

    RemuneracionMinimaVitalResponse obtenerPorId(Long id);

    RemuneracionMinimaVitalResponse crear(RemuneracionMinimaVitalCreateRequest request);

    RemuneracionMinimaVitalResponse actualizar(Long id, RemuneracionMinimaVitalUpdateRequest request);

    RemuneracionMinimaVitalResponse desactivar(Long id);

    RemuneracionMinimaVitalResponse activar(Long id);

    List<RemuneracionMinimaVitalResponse> listarActivos();
}
