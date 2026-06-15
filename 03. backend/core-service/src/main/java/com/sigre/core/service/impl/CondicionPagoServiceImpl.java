package com.sigre.core.service.impl;

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
import com.sigre.core.dto.CondicionPagoRequest;
import java.time.Instant;
import com.sigre.core.dto.CondicionPagoResponse;
import com.sigre.core.entity.CondicionPago;
import com.sigre.core.mapper.CondicionPagoMapper;
import com.sigre.core.repository.CondicionPagoRepository;
import com.sigre.core.service.CondicionPagoService;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CondicionPagoServiceImpl implements CondicionPagoService {
    private final CondicionPagoRepository repository;
    private final CondicionPagoMapper mapper;

    @Override
    public Page<CondicionPago> list(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Override
    public CondicionPagoResponse getById(Long id) {
        return mapper.toResponse(getEntity(id));
    }

    @Override
    @Transactional
    public CondicionPagoResponse create(CondicionPagoRequest request) {
        if (repository.existsByCodigoIgnoreCase(request.getCodigo())) {
            throw new BusinessException("Ya existe una condicion de pago con el mismo codigo", HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
        CondicionPago entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    @Transactional
    public CondicionPagoResponse update(Long id, CondicionPagoRequest request) {
        CondicionPago entity = getEntity(id);
        if (repository.existsByCodigoIgnoreCaseAndIdNot(request.getCodigo(), id)) {
            throw new BusinessException("Ya existe una condicion de pago con el mismo codigo", HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
        mapper.updateEntity(request, entity);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando CondicionPago con id: {}", id);
        getEntity(id);
        repository.deleteById(id);
        log.info("CondicionPago eliminado exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "condicion_pago", "operation", "activate"})
    @Override
    @Transactional
    public CondicionPago activate(Long id) {
        log.info("Activando CondicionPago con id: {}", id);
        CondicionPago existing = getEntity(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "condicion_pago", "operation", "deactivate"})
    @Override
    @Transactional
    public CondicionPago deactivate(Long id) {
        log.info("Desactivando CondicionPago con id: {}", id);
        CondicionPago existing = getEntity(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    private CondicionPago getEntity(Long id) {
        return repository.findById(id).orElseThrow(() -> new ResourceNotFoundException("CondicionPago", id));
    }
}
