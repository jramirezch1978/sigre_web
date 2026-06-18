package pe.restaurant.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.rrhh.dto.request.TipoSuspensionLaboralCreateRequest;
import pe.restaurant.rrhh.dto.request.TipoSuspensionLaboralUpdateRequest;
import pe.restaurant.rrhh.dto.response.TipoSuspensionLaboralResponse;

public interface TipoSuspensionLaboralService {

    Page<TipoSuspensionLaboralResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);

    TipoSuspensionLaboralResponse obtenerPorId(Long id);

    TipoSuspensionLaboralResponse crear(TipoSuspensionLaboralCreateRequest request);

    TipoSuspensionLaboralResponse actualizar(Long id, TipoSuspensionLaboralUpdateRequest request);

    TipoSuspensionLaboralResponse desactivar(Long id);

    TipoSuspensionLaboralResponse activar(Long id);

    java.util.List<TipoSuspensionLaboralResponse> listarActivos();
}
