package pe.restaurant.produccion.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.produccion.dto.response.OperacionDetResponse;
import pe.restaurant.produccion.dto.response.OperacionResponse;
import pe.restaurant.produccion.entity.Operacion;
import pe.restaurant.produccion.entity.OperacionesDet;

import java.time.LocalDate;
import java.util.List;

public interface OperacionService {

    Page<Operacion> findAll(Long ordenTrabajoId, LocalDate fechaDesde, LocalDate fechaHasta,
                            String flagEstado, Pageable pageable);

    Operacion findById(Long id);

    Operacion create(Operacion entity, List<OperacionesDet> detalles);

    Operacion update(Long id, Operacion entity, List<OperacionesDet> detalles);

    Operacion activate(Long id);

    Operacion deactivate(Long id);

    void delete(Long id);

    // sub-recurso

    List<OperacionesDet> findDetalles(Long operacionId);

    List<OperacionesDet> addDetalles(Long operacionId, List<OperacionesDet> detalles);

    void enrich(OperacionResponse response);

    void enrich(List<OperacionResponse> responses);

    void enrichDetalles(List<OperacionDetResponse> detalles);
}
