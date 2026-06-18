package pe.restaurant.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.rrhh.dto.request.SancionAmonestacionCreateRequest;
import pe.restaurant.rrhh.dto.request.SancionAmonestacionUpdateRequest;
import pe.restaurant.rrhh.dto.response.SancionAmonestacionResponse;
import java.time.LocalDate;

public interface SancionAmonestacionService {
    Page<SancionAmonestacionResponse> listar(Long trabajadorId, Long tipoSancionId, LocalDate fechaDesde,
                                             LocalDate fechaHasta, String flagEstado, Pageable pageable);
    SancionAmonestacionResponse obtenerPorId(Long id);
    SancionAmonestacionResponse crear(SancionAmonestacionCreateRequest request);
    SancionAmonestacionResponse actualizar(Long id, SancionAmonestacionUpdateRequest request);
    SancionAmonestacionResponse desactivar(Long id);
}
