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
import com.sigre.common.security.TenantContext;
import com.sigre.rrhh.constants.SeccionConstants;
import com.sigre.rrhh.dto.request.SeccionCreateRequest;
import com.sigre.rrhh.dto.request.SeccionUpdateRequest;
import com.sigre.rrhh.dto.response.SeccionResponse;
import com.sigre.rrhh.entity.Seccion;
import com.sigre.rrhh.mapper.SeccionMapper;
import com.sigre.rrhh.repository.SeccionRepository;
import com.sigre.rrhh.specification.SeccionSpecification;
import com.sigre.rrhh.service.SeccionService;
import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class SeccionServiceImpl implements SeccionService {
    private final SeccionRepository repository;
    private final SeccionMapper mapper;

    @Override @Timed("rrhh.seccion.listar")
    public Page<SeccionResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable) {
        return repository.findAll(SeccionSpecification.filtros(codigo, nombre, flagEstado), pageable).map(mapper::toResponse);
    }

    @Override public SeccionResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override @Transactional @Timed("rrhh.seccion.crear")
    public SeccionResponse crear(SeccionCreateRequest request) {
        String codigo = request.getCodigo().trim().toUpperCase();
        request.setCodigo(codigo);
        if (repository.existsByCodigo(codigo)) {
            throw new BusinessException(SeccionConstants.MSG_CODIGO_DUPLICADO, HttpStatus.CONFLICT, SeccionConstants.ERROR_CODIGO_DUPLICADO);
        }
        var entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional @Timed("rrhh.seccion.actualizar")
    public SeccionResponse actualizar(Long id, SeccionUpdateRequest request) {
        var existing = buscarOrThrow(id);
        mapper.updateEntity(existing, request);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Override @Transactional public SeccionResponse desactivar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional public SeccionResponse activar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("1");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override public java.util.List<SeccionResponse> listarActivos() {
        return mapper.toResponseList(repository.findByFlagEstadoOrderByNombreAsc("1"));
    }

    private Seccion buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> new BusinessException(
                SeccionConstants.MSG_NO_ENCONTRADO, HttpStatus.NOT_FOUND, SeccionConstants.ERROR_NO_ENCONTRADO));
    }
}
