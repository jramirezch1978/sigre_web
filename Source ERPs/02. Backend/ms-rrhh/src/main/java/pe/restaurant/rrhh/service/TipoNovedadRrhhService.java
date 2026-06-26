package pe.restaurant.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.rrhh.dto.request.TipoNovedadRrhhCreateRequest;
import pe.restaurant.rrhh.dto.request.TipoNovedadRrhhUpdateRequest;
import pe.restaurant.rrhh.dto.response.TipoNovedadRrhhResponse;

public interface TipoNovedadRrhhService {

    Page<TipoNovedadRrhhResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable);

    TipoNovedadRrhhResponse obtenerPorId(Long id);

    TipoNovedadRrhhResponse crear(TipoNovedadRrhhCreateRequest request);

    TipoNovedadRrhhResponse actualizar(Long id, TipoNovedadRrhhUpdateRequest request);

    TipoNovedadRrhhResponse desactivar(Long id);
}
