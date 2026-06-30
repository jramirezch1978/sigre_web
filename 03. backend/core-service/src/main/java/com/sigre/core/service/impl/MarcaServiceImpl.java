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
import com.sigre.core.entity.Marca;
import com.sigre.core.repository.MarcaRepository;
import com.sigre.core.service.MarcaService;
import java.time.Instant;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class MarcaServiceImpl implements MarcaService {

    private final MarcaRepository repository;

    @Override
    public Page<Marca> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Override
    public Marca findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Marca", id));
    }

    @Override
    @Transactional
    public Marca create(Marca entity) {
        if (repository.existsByCodigoIgnoreCase(entity.getCodigo())) {
            throw new BusinessException("Ya existe una marca con codigo: " + entity.getCodigo(), HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return repository.save(entity);
    }

    @Override
    @Transactional
    public Marca update(Long id, Marca entity) {
        findById(id);
        if (repository.existsByCodigoIgnoreCaseAndIdNot(entity.getCodigo(), id)) {
            throw new BusinessException("Ya existe una marca con codigo: " + entity.getCodigo(), HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
        entity.setId(id);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return repository.save(entity);
    }

    @Override
    @Transactional
    public Marca activate(Long id) {
        Marca e = findById(id);
        e.setFlagEstado("1");
        e.setUpdatedBy(TenantContext.getUsuarioId());
        e.setFecModificacion(Instant.now());
        return repository.save(e);
    }

    @Override
    @Transactional
    public Marca deactivate(Long id) {
        Marca e = findById(id);
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
