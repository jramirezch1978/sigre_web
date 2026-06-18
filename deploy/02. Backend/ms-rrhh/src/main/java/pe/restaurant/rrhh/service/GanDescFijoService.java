package pe.restaurant.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.rrhh.dto.request.GanDescFijoEstadoRequest;
import pe.restaurant.rrhh.dto.request.GanDescFijoRequest;
import pe.restaurant.rrhh.entity.GanDescFijo;

public interface GanDescFijoService {

    Page<GanDescFijo> listar(Long trabajadorId, Long conceptoId, String flagEstado, Pageable pageable);

    GanDescFijo obtenerPorId(Long id);

    GanDescFijo crear(GanDescFijoRequest request);

    GanDescFijo actualizar(Long id, GanDescFijoRequest request);

    GanDescFijo cambiarEstado(Long id, GanDescFijoEstadoRequest request);
}
