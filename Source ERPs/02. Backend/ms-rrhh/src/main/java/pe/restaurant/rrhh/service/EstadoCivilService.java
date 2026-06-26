package pe.restaurant.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.rrhh.dto.request.EstadoCivilCreateRequest;
import pe.restaurant.rrhh.dto.request.EstadoCivilUpdateRequest;
import pe.restaurant.rrhh.dto.response.EstadoCivilResponse;

public interface EstadoCivilService {
    Page<EstadoCivilResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);
    EstadoCivilResponse obtenerPorId(Long id);
    EstadoCivilResponse crear(EstadoCivilCreateRequest request);
    EstadoCivilResponse actualizar(Long id, EstadoCivilUpdateRequest request);
    EstadoCivilResponse desactivar(Long id);
    EstadoCivilResponse activar(Long id);
    java.util.List<EstadoCivilResponse> listarActivos();
}
