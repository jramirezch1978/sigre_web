package com.sigre.core.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.core.dto.ConversionUnidadRequest;
import com.sigre.core.dto.ConversionUnidadResponse;
import com.sigre.core.entity.ConversionUnidad;
import com.sigre.core.mapper.ConversionUnidadMapper;
import com.sigre.core.repository.ConversionUnidadRepository;
import com.sigre.core.repository.UnidadMedidaRepository;
import com.sigre.common.security.TenantContext;
import java.time.Instant;
import com.sigre.core.service.ConversionUnidadService;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ConversionUnidadServiceImpl implements ConversionUnidadService {
    private final ConversionUnidadRepository repository;
    private final UnidadMedidaRepository unidadMedidaRepository;
    private final ConversionUnidadMapper mapper;

    @Override
    public Page<ConversionUnidad> list(Long articuloId, Long umOrigenId, Long umDestinoId, Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Override
    public ConversionUnidadResponse getById(Long id) {
        return mapper.toResponse(getEntity(id));
    }

    @Override
    @Transactional
    public ConversionUnidadResponse create(ConversionUnidadRequest request) {
        validateForeignKeys(request);
        ConversionUnidad entity = mapper.toEntity(request);
        entity.setArticuloId(request.getArticuloId());
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    @Transactional
    public ConversionUnidadResponse update(Long id, ConversionUnidadRequest request) {
        ConversionUnidad entity = getEntity(id);
        validateForeignKeys(request);
        mapper.updateEntity(request, entity);
        entity.setArticuloId(request.getArticuloId());
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando ConversionUnidad con id: {}", id);
        getEntity(id);
        repository.deleteById(id);
        log.info("ConversionUnidad eliminado exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "conversion_unidad", "operation", "activate"})
    @Override
    @Transactional
    public ConversionUnidad activate(Long id) {
        log.info("Activando ConversionUnidad con id: {}", id);
        ConversionUnidad existing = getEntity(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "conversion_unidad", "operation", "deactivate"})
    @Override
    @Transactional
    public ConversionUnidad deactivate(Long id) {
        log.info("Desactivando ConversionUnidad con id: {}", id);
        ConversionUnidad existing = getEntity(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    private ConversionUnidad getEntity(Long id) {
        return repository.findById(id).orElseThrow(() -> new ResourceNotFoundException("ConversionUnidad", id));
    }

    private void validateForeignKeys(ConversionUnidadRequest request) {
        if (!unidadMedidaRepository.existsById(request.getUmOrigenId())) {
            throw new ResourceNotFoundException("UnidadMedida", request.getUmOrigenId());
        }
        if (!unidadMedidaRepository.existsById(request.getUmDestinoId())) {
            throw new ResourceNotFoundException("UnidadMedida", request.getUmDestinoId());
        }
    }
}
