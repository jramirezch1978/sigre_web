package pe.restaurant.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.rrhh.dto.request.InasistenciaCreateRequest;
import pe.restaurant.rrhh.dto.request.InasistenciaRegularizarRequest;
import pe.restaurant.rrhh.dto.request.InasistenciaUpdateRequest;
import pe.restaurant.rrhh.dto.response.InasistenciaResponse;

import java.time.LocalDate;

public interface InasistenciaService {

    Page<InasistenciaResponse> listar(Long trabajadorId, LocalDate fechaDesde, LocalDate fechaHasta,
                                      String flagEstado, Pageable pageable);

    InasistenciaResponse obtenerPorId(Long id);

    InasistenciaResponse crear(InasistenciaCreateRequest request);

    InasistenciaResponse actualizar(Long id, InasistenciaUpdateRequest request);

    InasistenciaResponse aprobar(Long id);

    InasistenciaResponse rechazar(Long id);

    InasistenciaResponse anular(Long id);

    InasistenciaResponse regularizar(Long id, InasistenciaRegularizarRequest request);

    InasistenciaResponse desactivar(Long id);
}
