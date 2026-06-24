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
import com.sigre.rrhh.constants.TipoZonaConstants;
import com.sigre.rrhh.dto.request.TipoZonaCreateRequest;
import com.sigre.rrhh.dto.request.TipoZonaUpdateRequest;
import com.sigre.rrhh.dto.response.TipoZonaResponse;
import com.sigre.rrhh.entity.TipoZona;
import com.sigre.rrhh.mapper.TipoZonaMapper;
import com.sigre.rrhh.repository.TipoZonaRepository;
import com.sigre.rrhh.specification.TipoZonaSpecification;
import com.sigre.rrhh.service.TipoZonaService;
import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TipoZonaServiceImpl implements TipoZonaService {
    private final TipoZonaRepository repository;
    private final TipoZonaMapper mapper;

    @Override @Timed("rrhh.tipo_zona.listar")
    public Page<TipoZonaResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable) {
        return repository.findAll(TipoZonaSpecification.filtros(codigo, nombre, flagEstado), pageable).map(mapper::toResponse);
    }

    @Override public TipoZonaResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override @Transactional @Timed("rrhh.tipo_zona.crear")
    public TipoZonaResponse crear(TipoZonaCreateRequest request) {
        String codigo = request.getCodigo().trim().toUpperCase();
        request.setCodigo(codigo);
        if (repository.existsByCodigo(codigo)) {
            throw new BusinessException(TipoZonaConstants.MSG_CODIGO_DUPLICADO, HttpStatus.CONFLICT, TipoZonaConstants.ERROR_CODIGO_DUPLICADO);
        }
        var entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional @Timed("rrhh.tipo_zona.actualizar")
    public TipoZonaResponse actualizar(Long id, TipoZonaUpdateRequest request) {
        var existing = buscarOrThrow(id);
        mapper.updateEntity(existing, request);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Override @Transactional public TipoZonaResponse desactivar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional public TipoZonaResponse activar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("1");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override public java.util.List<TipoZonaResponse> listarActivos() {
        return mapper.toResponseList(repository.findByFlagEstadoOrderByNombreAsc("1"));
    }

    private TipoZona buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> new BusinessException(
                TipoZonaConstants.MSG_NO_ENCONTRADO, HttpStatus.NOT_FOUND, TipoZonaConstants.ERROR_NO_ENCONTRADO));
    }
}
