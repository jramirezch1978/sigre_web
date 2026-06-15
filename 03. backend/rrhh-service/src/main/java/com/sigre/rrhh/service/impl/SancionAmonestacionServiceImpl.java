package com.sigre.rrhh.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.rrhh.dto.request.SancionAmonestacionCreateRequest;
import com.sigre.rrhh.dto.request.SancionAmonestacionUpdateRequest;
import com.sigre.rrhh.dto.response.SancionAmonestacionResponse;
import com.sigre.rrhh.entity.SancionAmonestacion;
import com.sigre.rrhh.mapper.SancionAmonestacionMapper;
import com.sigre.rrhh.repository.SancionAmonestacionRepository;
import com.sigre.rrhh.service.SancionAmonestacionService;
import com.sigre.rrhh.specification.SancionAmonestacionSpecification;
import com.sigre.rrhh.validation.SancionAmonestacionValidator;
import java.time.Instant;
import java.time.LocalDate;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class SancionAmonestacionServiceImpl implements SancionAmonestacionService {

    private final SancionAmonestacionRepository repository;
    private final SancionAmonestacionMapper mapper;
    private final SancionAmonestacionValidator validator;

    @Override @Timed("rrhh.sancion.listar")
    public Page<SancionAmonestacionResponse> listar(Long trabajadorId, Long tipoSancionId, LocalDate fechaDesde,
                                                     LocalDate fechaHasta, String flagEstado, Pageable pageable) {
        var spec = SancionAmonestacionSpecification.filtros(trabajadorId, tipoSancionId, fechaDesde, fechaHasta, flagEstado);
        return repository.findAll(spec, pageable).map(mapper::toResponse);
    }

    @Override @Timed("rrhh.sancion.obtener")
    public SancionAmonestacionResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override @Transactional @Timed("rrhh.sancion.crear")
    public SancionAmonestacionResponse crear(SancionAmonestacionCreateRequest request) {
        validator.validarTrabajador(request.getTrabajadorId());
        validator.validarTipoSancion(request.getTipoSancionId());
        validator.validarFechaNoFutura(request.getFecha());
        var entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional @Timed("rrhh.sancion.actualizar")
    public SancionAmonestacionResponse actualizar(Long id, SancionAmonestacionUpdateRequest request) {
        var existing = buscarOrThrow(id);
        if (request.getTipoSancionId() != null) validator.validarTipoSancion(request.getTipoSancionId());
        if (request.getFecha() != null) validator.validarFechaNoFutura(request.getFecha());
        mapper.updateEntity(existing, request);
        return mapper.toResponse(repository.save(existing));
    }

    @Override @Transactional @Timed("rrhh.sancion.desactivar")
    public SancionAmonestacionResponse desactivar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    private SancionAmonestacion buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> {
            log.warn("Sanción no encontrada: {}", id);
            return new ResourceNotFoundException("SancionAmonestacion", id);
        });
    }
}
