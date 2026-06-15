package com.sigre.finanzas.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.security.TenantContext;
import com.sigre.finanzas.entity.Banco;
import com.sigre.finanzas.repository.BancoRepository;
import com.sigre.finanzas.service.BancoService;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class BancoServiceImpl implements BancoService {

    private final BancoRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "banco", "operation", "findAll"})
    @Override
    public Page<Banco> findAll(Pageable pageable) {
        log.info("Listando bancos - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<Banco> page = repository.findAll(pageable);
        log.info("Bancos encontrados: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "banco", "operation", "findById"})
    @Override
    public Banco findById(Long id) {
        log.info("Buscando banco con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Banco no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Banco", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "banco", "operation", "create"})
    @Override
    @Transactional
    public Banco create(Banco entity) {
        log.info("Creando banco con codigo: {}", entity.getCodBanco());
        validateUniqueCodigo(entity.getCodBanco(), null);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        Banco saved = repository.save(entity);
        log.info("Banco creado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "banco", "operation", "update"})
    @Override
    @Transactional
    public Banco update(Long id, Banco entity) {
        log.info("Actualizando banco con id: {}", id);
        Banco existing = findById(id);
        validateUniqueCodigo(entity.getCodBanco(), id);
        
        existing.setCodBanco(entity.getCodBanco());
        existing.setNomBanco(entity.getNomBanco());
        existing.setProveedor(entity.getProveedor());
        existing.setCodBancoRtps(entity.getCodBancoRtps());
        existing.setDireccion(entity.getDireccion());
        existing.setSwift(entity.getSwift());
        existing.setCodBancoSunat(entity.getCodBancoSunat());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        Banco updated = repository.save(existing);
        log.info("Banco actualizado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "banco", "operation", "activate"})
    @Override
    @Transactional
    public Banco activate(Long id) {
        log.info("Activando banco con id: {}", id);
        Banco existing = findById(id);
        existing.setFlagEstado("1");
        Banco activated = repository.save(existing);
        log.info("Banco activado exitosamente con id: {}", id);
        return activated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "banco", "operation", "deactivate"})
    @Override
    @Transactional
    public Banco deactivate(Long id) {
        log.info("Desactivando banco con id: {}", id);
        Banco existing = findById(id);
        existing.setFlagEstado("0");
        Banco deactivated = repository.save(existing);
        log.info("Banco desactivado exitosamente con id: {}", id);
        return deactivated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "banco", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando banco con id: {}", id);
        Banco existing = findById(id);
        repository.delete(existing);
        log.info("Banco eliminado exitosamente con id: {}", id);
    }

    private void validateUniqueCodigo(String codigo, Long excludeId) {
        boolean exists = (excludeId == null)
                ? repository.existsByCodBancoIgnoreCase(codigo)
                : repository.existsByCodBancoIgnoreCaseAndIdNot(codigo, excludeId);
        if (exists) {
            log.warn("Intento de duplicar codigo de banco: {}", codigo);
            throw new BusinessException(
                    "Ya existe un banco con código: " + codigo,
                    org.springframework.http.HttpStatus.CONFLICT, "FIN-004");
        }
    }
}
