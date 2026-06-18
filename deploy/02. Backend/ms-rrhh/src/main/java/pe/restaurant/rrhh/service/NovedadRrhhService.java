package pe.restaurant.rrhh.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.rrhh.dto.request.NovedadRrhhCreateRequest;
import pe.restaurant.rrhh.dto.request.NovedadRrhhDetRequest;
import pe.restaurant.rrhh.dto.request.NovedadRrhhUpdateRequest;
import pe.restaurant.rrhh.dto.response.NovedadRrhhDetResponse;
import pe.restaurant.rrhh.dto.response.NovedadRrhhResponse;
import java.time.LocalDate;
import java.util.List;

public interface NovedadRrhhService {
    Page<NovedadRrhhResponse> listar(Long trabajadorId, Long tipoNovedadRrhhId, LocalDate fechaDesde,
                                      LocalDate fechaHasta, String flagEstado, Pageable pageable);
    NovedadRrhhResponse obtenerPorId(Long id);
    NovedadRrhhResponse crear(NovedadRrhhCreateRequest request);
    NovedadRrhhResponse actualizar(Long id, NovedadRrhhUpdateRequest request);
    NovedadRrhhResponse desactivar(Long id);
    List<NovedadRrhhDetResponse> listarDetalles(Long novedadId);
    NovedadRrhhDetResponse crearDetalle(Long novedadId, NovedadRrhhDetRequest request);
    void eliminarDetalle(Long novedadId, Long detalleId);
}
