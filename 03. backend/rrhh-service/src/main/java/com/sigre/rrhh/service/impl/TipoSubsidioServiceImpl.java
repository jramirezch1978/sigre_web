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
import com.sigre.rrhh.dto.request.TipoSubsidioCreateRequest;
import com.sigre.rrhh.dto.request.TipoSubsidioUpdateRequest;
import com.sigre.rrhh.dto.response.TipoSubsidioResponse;
import com.sigre.rrhh.entity.TipoSubsidio;
import com.sigre.rrhh.mapper.TipoSubsidioMapper;
import com.sigre.rrhh.repository.TipoSubsidioRepository;
import com.sigre.rrhh.specification.TipoSubsidioSpecification;
import java.time.Instant;
import com.sigre.rrhh.service.TipoSubsidioService;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TipoSubsidioServiceImpl implements TipoSubsidioService {

    private final TipoSubsidioRepository repository;
    private final TipoSubsidioMapper mapper;

    @Override @Timed("rrhh.tipo_subsidio.listar")
    public Page<TipoSubsidioResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable) {
        return repository.findAll(TipoSubsidioSpecification.filtros(codigo, nombre, flagEstado), pageable).map(mapper::toResponse);
    }

    @Override @Timed("rrhh.tipo_subsidio.obtener")
    public TipoSubsidioResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override @Transactional @Timed("rrhh.tipo_subsidio.crear")
    public TipoSubsidioResponse crear(TipoSubsidioCreateRequest request) {
        String codigo = request.getCodigo().trim().toUpperCase();
        request.setCodigo(codigo);
        validarCodigoUnico(codigo);
        var entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional @Timed("rrhh.tipo_subsidio.actualizar")
    public TipoSubsidioResponse actualizar(Long id, TipoSubsidioUpdateRequest request) {
        var existing = buscarOrThrow(id);
        mapper.updateEntity(existing, request);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Override @Transactional @Timed("rrhh.tipo_subsidio.desactivar")
    public TipoSubsidioResponse desactivar(Long id) {
        var entity = buscarOrThrow(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    public java.util.List<TipoSubsidioResponse> listarActivos() {
        return mapper.toResponseList(repository.findByFlagEstadoOrderByNombreAsc("1"));
    }

    @Override
    @Transactional
    @Timed("rrhh.tipoSubsidio.activar")
    public TipoSubsidioResponse activar(Long id) {
        TipoSubsidio tipoSubsidio = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("TipoSubsidio", id));
        tipoSubsidio.setFlagEstado("1");
        tipoSubsidio.setUpdatedBy(TenantContext.getUsuarioId());
        tipoSubsidio.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(tipoSubsidio));
    }

    private TipoSubsidio buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> {
            log.warn("TipoSubsidio no encontrado: {}", id);
            return new ResourceNotFoundException("TipoSubsidio", id);
        });
    }

    private void validarCodigoUnico(String codigo) {
        if (repository.existsByCodigo(codigo)) {
            log.warn("Código duplicado: {}", codigo);
            throw new BusinessException("Ya existe un tipo de subsidio con ese código.", HttpStatus.CONFLICT, "RH-TS-001");
        }
    }
}
