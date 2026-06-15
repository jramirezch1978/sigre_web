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

import java.time.Instant;
import com.sigre.rrhh.constants.TipoPlanillaConstants;
import com.sigre.rrhh.dto.request.TipoPlanillaCreateRequest;
import com.sigre.rrhh.dto.request.TipoPlanillaUpdateRequest;
import com.sigre.rrhh.dto.response.TipoPlanillaResponse;
import com.sigre.rrhh.entity.TipoPlanilla;
import com.sigre.rrhh.mapper.TipoPlanillaMapper;
import com.sigre.rrhh.repository.TipoPlanillaRepository;
import com.sigre.rrhh.specification.TipoPlanillaSpecification;
import com.sigre.rrhh.service.TipoPlanillaService;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TipoPlanillaServiceImpl implements TipoPlanillaService {

    private final TipoPlanillaRepository repository;
    private final TipoPlanillaMapper mapper;

    @Override @Timed("rrhh.tipo_planilla.listar")
    public Page<TipoPlanillaResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable) {
        return repository.findAll(TipoPlanillaSpecification.filtros(codigo, nombre, flagEstado), pageable).map(mapper::toResponse);
    }

    @Override @Timed("rrhh.tipo_planilla.obtener")
    public TipoPlanillaResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override @Transactional @Timed("rrhh.tipo_planilla.crear")
    public TipoPlanillaResponse crear(TipoPlanillaCreateRequest request) {
        String codigo = request.getCodigo().trim().toUpperCase();
        request.setCodigo(codigo);
        validarCodigoUnico(codigo);
        var entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional @Timed("rrhh.tipo_planilla.actualizar")
    public TipoPlanillaResponse actualizar(Long id, TipoPlanillaUpdateRequest request) {
        var existing = buscarOrThrow(id);
        mapper.updateEntity(existing, request);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Override @Transactional @Timed("rrhh.tipoPlanilla.desactivar")
    public TipoPlanillaResponse desactivar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    public java.util.List<TipoPlanillaResponse> listarActivos() {
        return mapper.toResponseList(repository.findByFlagEstadoOrderByNombreAsc("1"));
    }

    @Override @Transactional @Timed("rrhh.tipoPlanilla.activar")
    public TipoPlanillaResponse activar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("1");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    private TipoPlanilla buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> {
            log.warn("TipoPlanilla no encontrado: {}", id);
            return new BusinessException(TipoPlanillaConstants.MSG_NO_ENCONTRADO, HttpStatus.NOT_FOUND, TipoPlanillaConstants.ERROR_NO_ENCONTRADO);
        });
    }

    private void validarCodigoUnico(String codigo) {
        if (repository.existsByCodigo(codigo)) {
            log.warn("Código duplicado: {}", codigo);
            throw new BusinessException(TipoPlanillaConstants.MSG_CODIGO_DUPLICADO, HttpStatus.CONFLICT, TipoPlanillaConstants.ERROR_CODIGO_DUPLICADO);
        }
    }
}
