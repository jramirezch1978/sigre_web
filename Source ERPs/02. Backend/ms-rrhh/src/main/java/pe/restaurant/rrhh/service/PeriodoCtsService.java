package pe.restaurant.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.rrhh.dto.request.PeriodoCtsCreateRequest;
import pe.restaurant.rrhh.dto.request.PeriodoCtsUpdateRequest;
import pe.restaurant.rrhh.dto.response.PeriodoCtsResponse;

public interface PeriodoCtsService {
    Page<PeriodoCtsResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);
    PeriodoCtsResponse obtenerPorId(Long id);
    PeriodoCtsResponse crear(PeriodoCtsCreateRequest request);
    PeriodoCtsResponse actualizar(Long id, PeriodoCtsUpdateRequest request);
    PeriodoCtsResponse desactivar(Long id);
    PeriodoCtsResponse activar(Long id);
    java.util.List<PeriodoCtsResponse> listarActivos();
}
