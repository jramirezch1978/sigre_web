package pe.restaurant.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.rrhh.dto.request.MotivoCeseCreateRequest;
import pe.restaurant.rrhh.dto.request.MotivoCeseUpdateRequest;
import pe.restaurant.rrhh.dto.response.MotivoCeseResponse;
import java.util.List;

public interface MotivoCeseService {
    Page<MotivoCeseResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);
    MotivoCeseResponse obtenerPorId(Long id);
    MotivoCeseResponse crear(MotivoCeseCreateRequest request);
    MotivoCeseResponse actualizar(Long id, MotivoCeseUpdateRequest request);
    MotivoCeseResponse desactivar(Long id);
    MotivoCeseResponse activar(Long id);
    List<MotivoCeseResponse> listarActivos();
}
