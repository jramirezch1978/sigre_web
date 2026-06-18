package pe.restaurant.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.rrhh.dto.request.TipoMovAsistenciaCreateRequest;
import pe.restaurant.rrhh.dto.request.TipoMovAsistenciaUpdateRequest;
import pe.restaurant.rrhh.dto.response.TipoMovAsistenciaResponse;

public interface TipoMovAsistenciaService {
    Page<TipoMovAsistenciaResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);
    TipoMovAsistenciaResponse obtenerPorId(Long id);
    TipoMovAsistenciaResponse crear(TipoMovAsistenciaCreateRequest request);
    TipoMovAsistenciaResponse actualizar(Long id, TipoMovAsistenciaUpdateRequest request);
    TipoMovAsistenciaResponse desactivar(Long id);
    TipoMovAsistenciaResponse activar(Long id);
    java.util.List<TipoMovAsistenciaResponse> listarActivos();
}
