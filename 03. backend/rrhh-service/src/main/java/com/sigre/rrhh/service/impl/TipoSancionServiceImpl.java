package com.sigre.rrhh.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.rrhh.dto.request.TipoSancionCreateRequest;
import com.sigre.rrhh.dto.request.TipoSancionUpdateRequest;
import com.sigre.rrhh.dto.response.TipoSancionResponse;
import com.sigre.rrhh.entity.TipoSancion;
import com.sigre.rrhh.mapper.TipoSancionMapper;
import com.sigre.rrhh.repository.TipoSancionRepository;
import com.sigre.rrhh.service.TipoSancionService;
import com.sigre.rrhh.specification.TipoSancionSpecification;
import com.sigre.rrhh.validation.TipoSancionValidator;
import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TipoSancionServiceImpl implements TipoSancionService {

    private final TipoSancionRepository repository;
    private final TipoSancionMapper mapper;
    private final TipoSancionValidator validator;

    @Override @Timed("rrhh.tipoSancion.listar")
    public Page<TipoSancionResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable) {
        return repository.findAll(TipoSancionSpecification.filtros(codigo, nombre, flagEstado), pageable).map(mapper::toResponse);
    }

    @Override @Timed("rrhh.tipoSancion.obtener")
    public TipoSancionResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override @Transactional @Timed("rrhh.tipoSancion.crear")
    public TipoSancionResponse crear(TipoSancionCreateRequest request) {
        String codigo = request.getCodigo().trim().toUpperCase();
        request.setCodigo(codigo);
        validator.validarCodigoUnico(codigo);
        var entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional @Timed("rrhh.tipoSancion.actualizar")
    public TipoSancionResponse actualizar(Long id, TipoSancionUpdateRequest request) {
        var existing = buscarOrThrow(id);
        mapper.updateEntity(existing, request);
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Override @Transactional @Timed("rrhh.tipoSancion.desactivar")
    public TipoSancionResponse desactivar(Long id) {
        var entity = buscarOrThrow(id);
        validator.validarNoEnUsoEnSanciones(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    public java.util.List<TipoSancionResponse> listarActivos() {
        return mapper.toResponseList(repository.findByFlagEstadoOrderByNombreAsc("1"));
    }

    @Override
    @Transactional
    @Timed("rrhh.tipoSancion.activar")
    public TipoSancionResponse activar(Long id) {
        TipoSancion tipoSancion = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("TipoSancion", id));
        tipoSancion.setFlagEstado("1");
        tipoSancion.setUpdatedBy(TenantContext.getUsuarioId());
        tipoSancion.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(tipoSancion));
    }

    private TipoSancion buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> {
            log.warn("Tipo sanción no encontrado: {}", id);
            return new ResourceNotFoundException("TipoSancion", id);
        });
    }
}
