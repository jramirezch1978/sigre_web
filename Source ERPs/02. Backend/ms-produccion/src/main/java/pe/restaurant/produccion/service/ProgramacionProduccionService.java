package pe.restaurant.produccion.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.produccion.dto.response.ProgramacionProduccionResponse;
import pe.restaurant.produccion.entity.ProgramacionProduccion;

import java.time.LocalDate;
import java.util.List;

public interface ProgramacionProduccionService {

    Page<ProgramacionProduccion> findAll(Long recetaId, Long sucursalId, String flagFrecuencia,
                                         LocalDate fechaDesde, LocalDate fechaHasta,
                                         String flagEstado, Pageable pageable);

    ProgramacionProduccion findById(Long id);

    ProgramacionProduccion create(ProgramacionProduccion entity);

    ProgramacionProduccion update(Long id, ProgramacionProduccion entity);

    ProgramacionProduccion activate(Long id);

    ProgramacionProduccion deactivate(Long id);

    void delete(Long id);

    void enrichResponses(List<ProgramacionProduccionResponse> responses);
}
