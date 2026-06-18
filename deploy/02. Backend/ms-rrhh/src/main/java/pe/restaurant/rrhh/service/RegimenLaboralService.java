package pe.restaurant.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.rrhh.dto.request.RegimenLaboralCreateRequest;
import pe.restaurant.rrhh.dto.request.RegimenLaboralUpdateRequest;
import pe.restaurant.rrhh.dto.response.RegimenLaboralResponse;

public interface RegimenLaboralService {
    Page<RegimenLaboralResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);
    RegimenLaboralResponse obtenerPorId(Long id);
    RegimenLaboralResponse crear(RegimenLaboralCreateRequest request);
    RegimenLaboralResponse actualizar(Long id, RegimenLaboralUpdateRequest request);
    RegimenLaboralResponse desactivar(Long id);
    RegimenLaboralResponse activar(Long id);
    java.util.List<RegimenLaboralResponse> listarActivos();
}
