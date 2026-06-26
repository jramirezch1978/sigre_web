package pe.restaurant.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.rrhh.dto.request.TipoTrabajadorRtpsCreateRequest;
import pe.restaurant.rrhh.dto.request.TipoTrabajadorRtpsUpdateRequest;
import pe.restaurant.rrhh.dto.response.TipoTrabajadorRtpsResponse;
import java.util.List;

public interface TipoTrabajadorRtpsService {
    Page<TipoTrabajadorRtpsResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);
    TipoTrabajadorRtpsResponse obtenerPorId(Long id);
    TipoTrabajadorRtpsResponse crear(TipoTrabajadorRtpsCreateRequest request);
    TipoTrabajadorRtpsResponse actualizar(Long id, TipoTrabajadorRtpsUpdateRequest request);
    TipoTrabajadorRtpsResponse desactivar(Long id);
    TipoTrabajadorRtpsResponse activar(Long id);
    List<TipoTrabajadorRtpsResponse> listarActivos();
}
