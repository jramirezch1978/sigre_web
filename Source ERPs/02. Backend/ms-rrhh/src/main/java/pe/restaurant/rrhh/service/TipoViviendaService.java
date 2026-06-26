package pe.restaurant.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.rrhh.dto.request.TipoViviendaCreateRequest;
import pe.restaurant.rrhh.dto.request.TipoViviendaUpdateRequest;
import pe.restaurant.rrhh.dto.response.TipoViviendaResponse;
import java.util.List;

public interface TipoViviendaService {
    Page<TipoViviendaResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);
    TipoViviendaResponse obtenerPorId(Long id);
    TipoViviendaResponse crear(TipoViviendaCreateRequest request);
    TipoViviendaResponse actualizar(Long id, TipoViviendaUpdateRequest request);
    TipoViviendaResponse desactivar(Long id);
    TipoViviendaResponse activar(Long id);
    List<TipoViviendaResponse> listarActivos();
}
