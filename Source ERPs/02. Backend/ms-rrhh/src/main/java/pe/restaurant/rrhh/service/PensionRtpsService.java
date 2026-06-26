package pe.restaurant.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.rrhh.dto.request.PensionRtpsCreateRequest;
import pe.restaurant.rrhh.dto.request.PensionRtpsUpdateRequest;
import pe.restaurant.rrhh.dto.response.PensionRtpsResponse;
import java.util.List;

public interface PensionRtpsService {
    Page<PensionRtpsResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);
    PensionRtpsResponse obtenerPorId(Long id);
    PensionRtpsResponse crear(PensionRtpsCreateRequest request);
    PensionRtpsResponse actualizar(Long id, PensionRtpsUpdateRequest request);
    PensionRtpsResponse desactivar(Long id);
    PensionRtpsResponse activar(Long id);
    List<PensionRtpsResponse> listarActivos();
}
