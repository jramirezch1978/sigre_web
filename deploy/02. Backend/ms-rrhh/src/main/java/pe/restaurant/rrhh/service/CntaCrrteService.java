package pe.restaurant.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.rrhh.dto.request.CntaCrrteCreateRequest;
import pe.restaurant.rrhh.dto.request.CntaCrrteMovimientoRequest;
import pe.restaurant.rrhh.dto.request.CntaCrrteMovimientoUpdateRequest;
import pe.restaurant.rrhh.dto.request.CntaCrrteUpdateRequest;
import pe.restaurant.rrhh.dto.response.CntaCrrteDetResponse;
import pe.restaurant.rrhh.dto.response.CntaCrrteResponse;
import java.util.List;

public interface CntaCrrteService {
    Page<CntaCrrteResponse> listar(Long trabajadorId, String flagEstado, Pageable pageable);
    CntaCrrteResponse obtenerPorId(Long id);
    CntaCrrteResponse crear(CntaCrrteCreateRequest request);
    CntaCrrteResponse actualizar(Long id, CntaCrrteUpdateRequest request);
    CntaCrrteResponse cambiarEstado(Long id);
    List<CntaCrrteDetResponse> listarMovimientos(Long id);
    CntaCrrteDetResponse obtenerMovimiento(Long id, Long movimientoId);
    CntaCrrteDetResponse crearMovimiento(Long id, CntaCrrteMovimientoRequest request);
    CntaCrrteDetResponse actualizarMovimiento(Long id, Long movimientoId, CntaCrrteMovimientoUpdateRequest request);
    void eliminarMovimiento(Long id, Long movimientoId);
}
