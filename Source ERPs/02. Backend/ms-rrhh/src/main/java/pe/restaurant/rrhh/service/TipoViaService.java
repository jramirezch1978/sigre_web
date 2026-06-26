package pe.restaurant.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.rrhh.dto.request.TipoViaCreateRequest;
import pe.restaurant.rrhh.dto.request.TipoViaUpdateRequest;
import pe.restaurant.rrhh.dto.response.TipoViaResponse;
import java.util.List;

public interface TipoViaService {
    Page<TipoViaResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);
    TipoViaResponse obtenerPorId(Long id);
    TipoViaResponse crear(TipoViaCreateRequest request);
    TipoViaResponse actualizar(Long id, TipoViaUpdateRequest request);
    TipoViaResponse desactivar(Long id);
    TipoViaResponse activar(Long id);
    List<TipoViaResponse> listarActivos();
}
