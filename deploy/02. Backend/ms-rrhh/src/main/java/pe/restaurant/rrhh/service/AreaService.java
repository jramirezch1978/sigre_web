package pe.restaurant.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.rrhh.dto.request.AreaRequest;
import pe.restaurant.rrhh.dto.response.AreaResponse;
import pe.restaurant.rrhh.dto.response.AreaTreeResponse;

import java.util.List;

public interface AreaService {

    Page<AreaResponse> listar(Pageable pageable, String nombre, Long padreId, String flagEstado);

    AreaResponse obtener(Long id);

    AreaResponse crear(AreaRequest request);

    AreaResponse actualizar(Long id, AreaRequest request);

    AreaResponse desactivar(Long id);

    AreaResponse activar(Long id);

    List<AreaTreeResponse> obtenerArbolJerarquico();
}
