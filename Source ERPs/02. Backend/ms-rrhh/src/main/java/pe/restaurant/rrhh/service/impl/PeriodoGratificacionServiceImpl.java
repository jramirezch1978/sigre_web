package pe.restaurant.rrhh.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.rrhh.dto.request.PeriodoGratificacionCreateRequest;
import pe.restaurant.rrhh.dto.request.PeriodoGratificacionUpdateRequest;
import pe.restaurant.rrhh.dto.response.PeriodoGratificacionResponse;
import pe.restaurant.rrhh.entity.PeriodoGratificacion;
import pe.restaurant.rrhh.mapper.PeriodoGratificacionMapper;
import pe.restaurant.rrhh.repository.PeriodoGratificacionRepository;
import pe.restaurant.rrhh.specification.PeriodoGratificacionSpecification;
import java.time.Instant;
import pe.restaurant.rrhh.service.PeriodoGratificacionService;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class PeriodoGratificacionServiceImpl implements PeriodoGratificacionService {

    private final PeriodoGratificacionRepository repository;
    private final PeriodoGratificacionMapper mapper;

    @Override @Timed("rrhh.periodo_gratificacion.listar")
    public Page<PeriodoGratificacionResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable) {
        return repository.findAll(PeriodoGratificacionSpecification.filtros(codigo, nombre, flagEstado), pageable).map(mapper::toResponse);
    }

    @Override @Timed("rrhh.periodo_gratificacion.obtener")
    public PeriodoGratificacionResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override @Transactional @Timed("rrhh.periodo_gratificacion.crear")
    public PeriodoGratificacionResponse crear(PeriodoGratificacionCreateRequest request) {
        String codigo = request.getCodigo().trim().toUpperCase();
        request.setCodigo(codigo);
        validarCodigoUnico(codigo);
        var entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional @Timed("rrhh.periodo_gratificacion.actualizar")
    public PeriodoGratificacionResponse actualizar(Long id, PeriodoGratificacionUpdateRequest request) {
        var existing = buscarOrThrow(id);
        mapper.updateEntity(existing, request);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Override @Transactional @Timed("rrhh.periodo_gratificacion.desactivar")
    public PeriodoGratificacionResponse desactivar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    public java.util.List<PeriodoGratificacionResponse> listarActivos() {
        return mapper.toResponseList(repository.findByFlagEstadoOrderByNombreAsc("1"));
    }

    @Override
    @Transactional
    @Timed("rrhh.periodoGratificacion.activar")
    public PeriodoGratificacionResponse activar(Long id) {
        PeriodoGratificacion periodoGratificacion = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("PeriodoGratificacion", id));
        periodoGratificacion.setFlagEstado("1");
        periodoGratificacion.setUpdatedBy(TenantContext.getUsuarioId());
        periodoGratificacion.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(periodoGratificacion));
    }

    private PeriodoGratificacion buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> {
            log.warn("PeriodoGratificacion no encontrado: {}", id);
            return new ResourceNotFoundException("PeriodoGratificacion", id);
        });
    }

    private void validarCodigoUnico(String codigo) {
        if (repository.existsByCodigo(codigo)) {
            log.warn("Código duplicado: {}", codigo);
            throw new BusinessException("Ya existe un período de gratificación con ese código.", HttpStatus.CONFLICT, "RH-PG-001");
        }
    }
}
