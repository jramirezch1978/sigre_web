package pe.restaurant.rrhh.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.rrhh.dto.request.EvaluacionDesempenoCreateRequest;
import pe.restaurant.rrhh.dto.request.EvaluacionDesempenoUpdateRequest;
import pe.restaurant.rrhh.dto.response.EvaluacionDesempenoResponse;
import pe.restaurant.rrhh.entity.EvaluacionDesempeno;
import pe.restaurant.rrhh.mapper.EvaluacionDesempenoMapper;
import pe.restaurant.rrhh.repository.EvaluacionDesempenoRepository;
import pe.restaurant.rrhh.service.EvaluacionDesempenoService;
import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class EvaluacionDesempenoServiceImpl implements EvaluacionDesempenoService {

    private final EvaluacionDesempenoRepository repository;
    private final EvaluacionDesempenoMapper mapper;

    @Override @Timed("rrhh.evaluacion.listar")
    public Page<EvaluacionDesempenoResponse> listar(Long trabajadorId, Integer periodoAnio, Integer periodoSemestre, Pageable pageable) {
        java.util.List<EvaluacionDesempeno> resultados;
        if (trabajadorId != null && periodoAnio != null) {
            resultados = repository.findByTrabajadorIdAndPeriodoAnio(trabajadorId, periodoAnio);
        } else if (trabajadorId != null) {
            resultados = repository.findByTrabajadorId(trabajadorId);
        } else if (periodoAnio != null) {
            resultados = repository.findByPeriodoAnio(periodoAnio);
        } else {
            resultados = repository.findAll();
        }
        var list = resultados.stream().map(mapper::toResponse).toList();
        return new PageImpl<>(list, pageable, list.size());
    }

    @Override @Timed("rrhh.evaluacion.obtener")
    public EvaluacionDesempenoResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override @Transactional @Timed("rrhh.evaluacion.crear")
    public EvaluacionDesempenoResponse crear(EvaluacionDesempenoCreateRequest request) {
        var entity = EvaluacionDesempeno.builder()
                .trabajadorId(request.getTrabajadorId())
                .periodoAnio(request.getPeriodoAnio())
                .periodoSemestre(request.getPeriodoSemestre())
                .calificacion(request.getCalificacion())
                .observaciones(request.getObservaciones())
                .evaluadorId(request.getEvaluadorId())
                .fechaEvaluacion(request.getFechaEvaluacion())
                .build();
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional @Timed("rrhh.evaluacion.actualizar")
    public EvaluacionDesempenoResponse actualizar(Long id, EvaluacionDesempenoUpdateRequest request) {
        var existing = buscarOrThrow(id);
        if (request.getCalificacion() != null) existing.setCalificacion(request.getCalificacion());
        if (request.getObservaciones() != null) existing.setObservaciones(request.getObservaciones());
        if (request.getFechaEvaluacion() != null) existing.setFechaEvaluacion(request.getFechaEvaluacion());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Override @Transactional @Timed("rrhh.evaluacion.eliminar")
    public void eliminar(Long id) {
        var entity = buscarOrThrow(id);
        repository.delete(entity);
    }

    private EvaluacionDesempeno buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> {
            log.warn("Evaluación no encontrada: {}", id);
            return new ResourceNotFoundException("EvaluacionDesempeno", id);
        });
    }
}
