package com.sigre.core.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.core.entity.Color;
import com.sigre.core.repository.ColorRepository;
import com.sigre.core.service.ColorService;
import java.time.Instant;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ColorServiceImpl implements ColorService {

    private final ColorRepository repository;

    @Override
    public Page<Color> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Override
    public Color findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Color", id));
    }

    @Override
    @Transactional
    public Color create(Color entity) {
        if (repository.existsByCodigoIgnoreCase(entity.getCodigo())) {
            throw new BusinessException("Ya existe un color con codigo: " + entity.getCodigo(), HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return repository.save(entity);
    }

    @Override
    @Transactional
    public Color update(Long id, Color entity) {
        findById(id);
        if (repository.existsByCodigoIgnoreCaseAndIdNot(entity.getCodigo(), id)) {
            throw new BusinessException("Ya existe un color con codigo: " + entity.getCodigo(), HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
        entity.setId(id);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return repository.save(entity);
    }

    @Override
    @Transactional
    public Color activate(Long id) {
        Color e = findById(id);
        e.setFlagEstado("1");
        e.setUpdatedBy(TenantContext.getUsuarioId());
        e.setFecModificacion(Instant.now());
        return repository.save(e);
    }

    @Override
    @Transactional
    public Color deactivate(Long id) {
        Color e = findById(id);
        e.setFlagEstado("0");
        e.setUpdatedBy(TenantContext.getUsuarioId());
        e.setFecModificacion(Instant.now());
        return repository.save(e);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        findById(id);
        repository.deleteById(id);
    }
}
