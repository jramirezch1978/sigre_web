package pe.restaurant.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.rrhh.dto.request.RemuneracionMinimaVitalCreateRequest;
import pe.restaurant.rrhh.dto.request.RemuneracionMinimaVitalUpdateRequest;
import pe.restaurant.rrhh.dto.response.RemuneracionMinimaVitalResponse;

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
