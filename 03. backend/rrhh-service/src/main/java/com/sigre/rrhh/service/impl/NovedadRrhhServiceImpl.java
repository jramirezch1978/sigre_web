package com.sigre.rrhh.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.rrhh.dto.request.NovedadRrhhCreateRequest;
import com.sigre.rrhh.dto.request.NovedadRrhhDetRequest;
import com.sigre.rrhh.dto.request.NovedadRrhhUpdateRequest;
import com.sigre.rrhh.dto.response.NovedadRrhhDetResponse;
import com.sigre.rrhh.dto.response.NovedadRrhhResponse;
import com.sigre.rrhh.entity.NovedadRrhh;
import com.sigre.rrhh.entity.NovedadRrhhDet;
import com.sigre.rrhh.mapper.NovedadRrhhDetMapper;
import com.sigre.rrhh.mapper.NovedadRrhhMapper;
import com.sigre.rrhh.repository.NovedadRrhhDetRepository;
import com.sigre.rrhh.repository.NovedadRrhhRepository;
import com.sigre.rrhh.service.NovedadRrhhService;
import com.sigre.rrhh.specification.NovedadRrhhSpecification;

import java.time.Instant;
import java.time.LocalDate;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class NovedadRrhhServiceImpl implements NovedadRrhhService {

    private final NovedadRrhhRepository repository;
    private final NovedadRrhhDetRepository detRepository;
    private final NovedadRrhhMapper mapper;
    private final NovedadRrhhDetMapper detMapper;

    @Override @Timed("rrhh.novedad.listar")
    public Page<NovedadRrhhResponse> listar(Long trabajadorId, Long tipoNovedadRrhhId,
                                             LocalDate fechaDesde, LocalDate fechaHasta,
                                             String flagEstado, Pageable pageable) {
        var spec = NovedadRrhhSpecification.filtros(trabajadorId, tipoNovedadRrhhId, fechaDesde, fechaHasta, flagEstado);
        return repository.findAll(spec, pageable).map(mapper::toResponse);
    }

    @Override @Timed("rrhh.novedad.obtener")
    public NovedadRrhhResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override @Transactional @Timed("rrhh.novedad.crear")
    public NovedadRrhhResponse crear(NovedadRrhhCreateRequest request) {
        var entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional @Timed("rrhh.novedad.actualizar")
    public NovedadRrhhResponse actualizar(Long id, NovedadRrhhUpdateRequest request) {
        var existing = buscarOrThrow(id);
        mapper.updateEntity(existing, request);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Override @Transactional @Timed("rrhh.novedad.desactivar")
    public NovedadRrhhResponse desactivar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Timed("rrhh.novedad.listarDetalles")
    public List<NovedadRrhhDetResponse> listarDetalles(Long novedadId) {
        return detRepository.findByNovedadRrhhId(novedadId).stream()
                .map(detMapper::toResponse).toList();
    }

    @Override @Transactional @Timed("rrhh.novedad.crearDetalle")
    public NovedadRrhhDetResponse crearDetalle(Long novedadId, NovedadRrhhDetRequest request) {
        buscarOrThrow(novedadId);
        var det = detMapper.toEntity(request);
        det.setNovedadRrhhId(novedadId);
        return detMapper.toResponse(detRepository.save(det));
    }

    @Override @Transactional @Timed("rrhh.novedad.eliminarDetalle")
    public void eliminarDetalle(Long novedadId, Long detalleId) {
        NovedadRrhhDet detalle = detRepository.findById(detalleId)
                .orElseThrow(() -> new ResourceNotFoundException("Detalle de novedad", detalleId));
        if (!detalle.getNovedadRrhhId().equals(novedadId)) {
            throw new BusinessException("El detalle no pertenece a la novedad especificada",
                    HttpStatus.BAD_REQUEST, "RH-NV-006");
        }
        detRepository.delete(detalle);
    }

    private NovedadRrhh buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> {
            log.warn("Novedad no encontrada: {}", id);
            return new ResourceNotFoundException("NovedadRrhh", id);
        });
    }
}
