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
import com.sigre.core.entity.CatalogoSunatDet;
import com.sigre.core.repository.CatalogoSunatDetRepository;
import com.sigre.core.service.CatalogoSunatDetService;

import java.time.Instant;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CatalogoSunatDetServiceImpl implements CatalogoSunatDetService {

    private final CatalogoSunatDetRepository repository;

    @Override
    public Page<CatalogoSunatDet> findAll(Long catalogoSunatId, String codigoItem, String nombreItem, String flagEstado, Pageable pageable) {
        return repository.findWithFilters(catalogoSunatId, codigoItem, nombreItem, flagEstado, pageable);
    }

    @Override
    public CatalogoSunatDet findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("CatalogoSunatDet", id));
    }

    @Override
    public List<CatalogoSunatDet> findActivosByCatalogoId(Long catalogoSunatId) {
        return repository.findActivosByCatalogoId(catalogoSunatId);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "catalogo_sunat_det", "operation", "create"})
    public CatalogoSunatDet create(CatalogoSunatDet entity) {
        log.info("Creando detalle SUNAT: catalogoId={}, codigoItem={}", entity.getCatalogoSunatId(), entity.getCodigoItem());
        validateUniqueCodigo(entity.getCatalogoSunatId(), entity.getCodigoItem(), null);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        CatalogoSunatDet saved = repository.save(entity);
        log.info("Detalle SUNAT creado con id: {}", saved.getId());
        return saved;
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "catalogo_sunat_det", "operation", "update"})
    public CatalogoSunatDet update(Long id, CatalogoSunatDet entity) {
        log.info("Actualizando detalle SUNAT con id: {}", id);
        CatalogoSunatDet existing = findById(id);
        validateUniqueCodigo(entity.getCatalogoSunatId(), entity.getCodigoItem(), id);
        existing.setCatalogoSunatId(entity.getCatalogoSunatId());
        existing.setCodigoItem(entity.getCodigoItem());
        existing.setNombreItem(entity.getNombreItem());
        existing.setDescripcionItem(entity.getDescripcionItem());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        CatalogoSunatDet updated = repository.save(existing);
        log.info("Detalle SUNAT actualizado con id: {}", id);
        return updated;
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "catalogo_sunat_det", "operation", "activate"})
    public CatalogoSunatDet activate(Long id) {
        CatalogoSunatDet entity = findById(id);
        entity.setFlagEstado("1");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return repository.save(entity);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "catalogo_sunat_det", "operation", "deactivate"})
    public CatalogoSunatDet deactivate(Long id) {
        CatalogoSunatDet entity = findById(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return repository.save(entity);
    }

    private void validateUniqueCodigo(Long catalogoSunatId, String codigoItem, Long excludeId) {
        repository.findByCatalogoSunatIdAndCodigoItem(catalogoSunatId, codigoItem)
                .filter(e -> !e.getId().equals(excludeId))
                .ifPresent(e -> {
                    throw new BusinessException("Ya existe un detalle con código '" + codigoItem + "' en el catálogo " + catalogoSunatId,
                            HttpStatus.CONFLICT, "BUSINESS_ERROR");
                });
    }
}
