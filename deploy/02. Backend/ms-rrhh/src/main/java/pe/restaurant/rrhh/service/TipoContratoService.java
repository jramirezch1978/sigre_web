package pe.restaurant.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.rrhh.dto.request.TipoContratoCreateRequest;
import pe.restaurant.rrhh.dto.request.TipoContratoUpdateRequest;
import pe.restaurant.rrhh.dto.response.TipoContratoResponse;

public interface TipoContratoService {
    Page<TipoContratoResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);
    TipoContratoResponse obtenerPorId(Long id);
    TipoContratoResponse crear(TipoContratoCreateRequest request);
    TipoContratoResponse actualizar(Long id, TipoContratoUpdateRequest request);
    TipoContratoResponse desactivar(Long id);
    TipoContratoResponse activar(Long id);
    java.util.List<TipoContratoResponse> listarActivos();
}
