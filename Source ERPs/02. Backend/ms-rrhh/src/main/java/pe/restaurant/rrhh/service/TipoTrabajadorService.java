package pe.restaurant.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.rrhh.dto.request.TipoTrabajadorCreateRequest;
import pe.restaurant.rrhh.dto.request.TipoTrabajadorUpdateRequest;
import pe.restaurant.rrhh.dto.response.TipoTrabajadorResponse;
import java.util.List;

public interface TipoTrabajadorService {
    Page<TipoTrabajadorResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);
    TipoTrabajadorResponse obtenerPorId(Long id);
    TipoTrabajadorResponse crear(TipoTrabajadorCreateRequest request);
    TipoTrabajadorResponse actualizar(Long id, TipoTrabajadorUpdateRequest request);
    TipoTrabajadorResponse desactivar(Long id);
    TipoTrabajadorResponse activar(Long id);
    List<TipoTrabajadorResponse> listarActivos();
}
