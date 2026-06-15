package com.sigre.rrhh.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.rrhh.dto.request.TipoNovedadRrhhCreateRequest;

import java.time.Instant;
import com.sigre.rrhh.dto.request.TipoNovedadRrhhUpdateRequest;
import com.sigre.rrhh.dto.response.TipoNovedadRrhhResponse;
import com.sigre.rrhh.entity.TipoNovedadRrhh;
import com.sigre.rrhh.mapper.TipoNovedadRrhhMapper;
import com.sigre.rrhh.repository.TipoNovedadRrhhRepository;
import com.sigre.rrhh.service.TipoNovedadRrhhService;
import com.sigre.rrhh.specification.TipoNovedadRrhhSpecification;
import com.sigre.rrhh.validation.TipoNovedadRrhhValidator;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TipoNovedadRrhhServiceImpl implements TipoNovedadRrhhService {

    private final TipoNovedadRrhhRepository repository;
    private final TipoNovedadRrhhMapper mapper;
    private final TipoNovedadRrhhValidator validator;

    @Override
    @Timed("rrhh.tipoNovedad.listar")
    public Page<TipoNovedadRrhhResponse> listar(String codigo, String nombre, String flagEstado, Pageable pageable) {
        Specification<TipoNovedadRrhh> spec = Specification.where(null);

        if (codigo != null && !codigo.isEmpty()) {
            spec = spec.and(TipoNovedadRrhhSpecification.codigoContains(codigo));
        }
        if (nombre != null && !nombre.isEmpty()) {
            spec = spec.and(TipoNovedadRrhhSpecification.nombreContains(nombre));
        }
        if (flagEstado != null && !flagEstado.isEmpty()) {
            spec = spec.and(TipoNovedadRrhhSpecification.flagEstadoEquals(flagEstado));
        }

        Page<TipoNovedadRrhh> page = repository.findAll(spec, pageable);
        return page.map(mapper::toResponse);
    }

    @Override
    @Timed("rrhh.tipoNovedad.obtener")
    public TipoNovedadRrhhResponse obtenerPorId(Long id) {
        TipoNovedadRrhh entity = repository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Tipo de novedad", id));
        return mapper.toResponse(entity);
    }

    @Override
    @Transactional
    @Timed("rrhh.tipoNovedad.crear")
    public TipoNovedadRrhhResponse crear(TipoNovedadRrhhCreateRequest request) {
        validator.validarCodigoUnico(request.getCodigo());
        TipoNovedadRrhh entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        TipoNovedadRrhh saved = repository.save(entity);
        return mapper.toResponse(saved);
    }

    @Override
    @Transactional
    @Timed("rrhh.tipoNovedad.actualizar")
    public TipoNovedadRrhhResponse actualizar(Long id, TipoNovedadRrhhUpdateRequest request) {
        TipoNovedadRrhh entity = repository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Tipo de novedad", id));

        mapper.updateEntity(entity, request);
        TipoNovedadRrhh saved = repository.save(entity);
        return mapper.toResponse(saved);
    }

    @Override
    @Transactional
    @Timed("rrhh.tipoNovedad.desactivar")
    public TipoNovedadRrhhResponse desactivar(Long id) {
        TipoNovedadRrhh entity = repository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Tipo de novedad", id));

        validator.validarNoEnUsoEnNovedadesActivas(id);

        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }
}
