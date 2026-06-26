package pe.restaurant.rrhh.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.rrhh.dto.request.ControlSubsidioCreateRequest;
import pe.restaurant.rrhh.dto.request.ControlSubsidioUpdateRequest;
import pe.restaurant.rrhh.dto.response.ControlSubsidioResponse;
import pe.restaurant.rrhh.entity.ControlSubsidio;
import pe.restaurant.rrhh.mapper.ControlSubsidioMapper;
import pe.restaurant.rrhh.repository.ControlSubsidioRepository;
import pe.restaurant.rrhh.service.ControlSubsidioService;
import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ControlSubsidioServiceImpl implements ControlSubsidioService {

    private final ControlSubsidioRepository repository;
    private final ControlSubsidioMapper mapper;

    @Override @Timed("rrhh.controlSubsidio.listar")
    public Page<ControlSubsidioResponse> listar(Pageable pageable) {
        return repository.findAll(pageable).map(mapper::toResponse);
    }

    @Override @Timed("rrhh.controlSubsidio.obtener")
    public ControlSubsidioResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override @Transactional @Timed("rrhh.controlSubsidio.crear")
    public ControlSubsidioResponse crear(ControlSubsidioCreateRequest request) {
        var entity = mapper.toEntity(request);
        entity.setFlagEstado("1");
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional @Timed("rrhh.controlSubsidio.actualizar")
    public ControlSubsidioResponse actualizar(Long id, ControlSubsidioUpdateRequest request) {
        var existing = buscarOrThrow(id);
        mapper.updateEntity(existing, request);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Override @Transactional @Timed("rrhh.controlSubsidio.desactivar")
    public ControlSubsidioResponse desactivar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    private ControlSubsidio buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> {
            log.warn("Control de subsidio no encontrado: {}", id);
            return new ResourceNotFoundException("ControlSubsidio", id);
        });
    }
}
