package pe.restaurant.core.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.core.dto.ConversionUnidadRequest;
import pe.restaurant.core.dto.ConversionUnidadResponse;
import pe.restaurant.core.entity.ConversionUnidad;
import pe.restaurant.core.mapper.ConversionUnidadMapper;
import pe.restaurant.core.repository.ConversionUnidadRepository;
import pe.restaurant.core.repository.UnidadMedidaRepository;
import pe.restaurant.common.security.TenantContext;
import java.time.Instant;
import pe.restaurant.core.service.ConversionUnidadService;

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
