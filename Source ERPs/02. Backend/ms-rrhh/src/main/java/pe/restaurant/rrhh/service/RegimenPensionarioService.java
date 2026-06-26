package pe.restaurant.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.rrhh.dto.request.RegimenPensionarioCreateRequest;
import pe.restaurant.rrhh.dto.request.RegimenPensionarioUpdateRequest;
import pe.restaurant.rrhh.dto.response.RegimenPensionarioResponse;
import java.util.List;

public interface RegimenPensionarioService {
    Page<RegimenPensionarioResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);
    RegimenPensionarioResponse obtenerPorId(Long id);
    RegimenPensionarioResponse crear(RegimenPensionarioCreateRequest request);
    RegimenPensionarioResponse actualizar(Long id, RegimenPensionarioUpdateRequest request);
    RegimenPensionarioResponse desactivar(Long id);
    RegimenPensionarioResponse activar(Long id);
    List<RegimenPensionarioResponse> listarActivos();
}
