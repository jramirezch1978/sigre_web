package pe.restaurant.core.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.core.entity.CreditoFiscal;
import pe.restaurant.core.repository.CreditoFiscalRepository;
import pe.restaurant.core.service.CreditoFiscalService;

import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CreditoFiscalServiceImpl implements CreditoFiscalService {

    private final CreditoFiscalRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "credito_fiscal", "operation", "findAll"})
    @Override
    public Page<CreditoFiscal> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "credito_fiscal", "operation", "findById"})
    @Override
    public CreditoFiscal findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("CreditoFiscal", id));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "credito_fiscal", "operation", "create"})
    @Override @Transactional
    public CreditoFiscal create(CreditoFiscal entity) {
        validateUniqueCodigo(entity.getCodigo(), null);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "credito_fiscal", "operation", "update"})
    @Override @Transactional
    public CreditoFiscal update(Long id, CreditoFiscal entity) {
        findById(id);
        validateUniqueCodigo(entity.getCodigo(), id);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "credito_fiscal", "operation", "delete"})
    @Override @Transactional
    public void delete(Long id) {
        findById(id);
        repository.deleteById(id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "credito_fiscal", "operation", "activate"})
    @Override @Transactional
    public CreditoFiscal activate(Long id) {
        CreditoFiscal existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "credito_fiscal", "operation", "deactivate"})
    @Override @Transactional
    public CreditoFiscal deactivate(Long id) {
        CreditoFiscal existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    private void validateUniqueCodigo(String codigo, Long excludeId) {
        repository.findByCodigo(codigo)
                .filter(e -> !e.getId().equals(excludeId))
                .ifPresent(e -> {
                    throw new BusinessException("Ya existe un credito fiscal con codigo: " + codigo, HttpStatus.CONFLICT, "BUSINESS_ERROR");
                });
    }
}
