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
import com.sigre.rrhh.constants.TipoViaConstants;
import com.sigre.rrhh.dto.request.TipoViaCreateRequest;
import com.sigre.rrhh.dto.request.TipoViaUpdateRequest;
import com.sigre.rrhh.dto.response.TipoViaResponse;
import com.sigre.rrhh.entity.TipoVia;
import com.sigre.rrhh.mapper.TipoViaMapper;
import com.sigre.rrhh.repository.TipoViaRepository;
import com.sigre.rrhh.specification.TipoViaSpecification;
import com.sigre.rrhh.service.TipoViaService;
import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TipoViaServiceImpl implements TipoViaService {
    private final TipoViaRepository repository;
    private final TipoViaMapper mapper;

    @Override @Timed("rrhh.tipo_via.listar")
    public Page<TipoViaResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable) {
        return repository.findAll(TipoViaSpecification.filtros(codigo, nombre, flagEstado), pageable).map(mapper::toResponse);
    }

    @Override public TipoViaResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override @Transactional @Timed("rrhh.tipo_via.crear")
    public TipoViaResponse crear(TipoViaCreateRequest request) {
        String codigo = request.getCodigo().trim().toUpperCase();
        request.setCodigo(codigo);
        if (repository.existsByCodigo(codigo)) {
            throw new BusinessException(TipoViaConstants.MSG_CODIGO_DUPLICADO, HttpStatus.CONFLICT, TipoViaConstants.ERROR_CODIGO_DUPLICADO);
        }
        var entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional @Timed("rrhh.tipo_via.actualizar")
    public TipoViaResponse actualizar(Long id, TipoViaUpdateRequest request) {
        var existing = buscarOrThrow(id);
        mapper.updateEntity(existing, request);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Override @Transactional public TipoViaResponse desactivar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional public TipoViaResponse activar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("1");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override public java.util.List<TipoViaResponse> listarActivos() {
        return mapper.toResponseList(repository.findByFlagEstadoOrderByNombreAsc("1"));
    }

    private TipoVia buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> new BusinessException(
                TipoViaConstants.MSG_NO_ENCONTRADO, HttpStatus.NOT_FOUND, TipoViaConstants.ERROR_NO_ENCONTRADO));
    }
}
