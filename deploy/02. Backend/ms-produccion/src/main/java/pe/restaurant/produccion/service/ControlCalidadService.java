package pe.restaurant.produccion.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.produccion.dto.response.ControlCalidadResponse;
import pe.restaurant.produccion.entity.ControlCalidad;

import java.time.LocalDate;
import java.util.List;

public interface ControlCalidadService {

    Page<ControlCalidad> findAll(Long ordenTrabajoId, String resultado, LocalDate fechaDesde,
                                 LocalDate fechaHasta, Long inspectorId, Pageable pageable);

    ControlCalidad findById(Long id);

    ControlCalidad create(ControlCalidad entity);

    ControlCalidad update(Long id, ControlCalidad entity);

    void delete(Long id);

    void enrich(List<ControlCalidadResponse> responses);
}
