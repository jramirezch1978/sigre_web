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
import com.sigre.rrhh.dto.request.SexoCreateRequest;
import com.sigre.rrhh.dto.request.SexoUpdateRequest;
import com.sigre.rrhh.dto.response.SexoResponse;
import com.sigre.rrhh.entity.Sexo;
import com.sigre.rrhh.mapper.SexoMapper;
import com.sigre.rrhh.repository.SexoRepository;
import com.sigre.rrhh.specification.SexoSpecification;
import java.time.Instant;
import com.sigre.rrhh.service.SexoService;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class SexoServiceImpl implements SexoService {

    private final SexoRepository repository;
    private final SexoMapper mapper;

    @Override @Timed("rrhh.sexo.listar")
    public Page<SexoResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable) {
        return repository.findAll(SexoSpecification.filtros(codigo, nombre, flagEstado), pageable).map(mapper::toResponse);
    }

    @Override @Timed("rrhh.sexo.obtener")
    public SexoResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override @Transactional @Timed("rrhh.sexo.crear")
    public SexoResponse crear(SexoCreateRequest request) {
        String codigo = request.getCodigo().trim().toUpperCase();
        request.setCodigo(codigo);
        validarCodigoUnico(codigo);
        var entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional @Timed("rrhh.sexo.actualizar")
    public SexoResponse actualizar(Long id, SexoUpdateRequest request) {
        var existing = buscarOrThrow(id);
        mapper.updateEntity(existing, request);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Override @Transactional @Timed("rrhh.sexo.desactivar")
    public SexoResponse desactivar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    public java.util.List<SexoResponse> listarActivos() {
        return mapper.toResponseList(repository.findByFlagEstadoOrderByNombreAsc("1"));
    }

    @Override
    @Transactional
    @Timed("rrhh.sexo.activar")
    public SexoResponse activar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("1");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    private Sexo buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> {
            log.warn("Sexo no encontrado: {}", id);
            return new ResourceNotFoundException("Sexo", id);
        });
    }

    private void validarCodigoUnico(String codigo) {
        if (repository.existsByCodigo(codigo)) {
            log.warn("Código duplicado: {}", codigo);
            throw new BusinessException("Ya existe un sexo con ese código.", HttpStatus.CONFLICT, "RH-SX-001");
        }
    }
}
