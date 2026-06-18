package pe.restaurant.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.rrhh.dto.request.TipoSubsidioCreateRequest;
import pe.restaurant.rrhh.dto.request.TipoSubsidioUpdateRequest;
import pe.restaurant.rrhh.dto.response.TipoSubsidioResponse;

public interface TipoSubsidioService {
    Page<TipoSubsidioResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);
    TipoSubsidioResponse obtenerPorId(Long id);
    TipoSubsidioResponse crear(TipoSubsidioCreateRequest request);
    TipoSubsidioResponse actualizar(Long id, TipoSubsidioUpdateRequest request);
    TipoSubsidioResponse desactivar(Long id);
    TipoSubsidioResponse activar(Long id);
    java.util.List<TipoSubsidioResponse> listarActivos();
}
