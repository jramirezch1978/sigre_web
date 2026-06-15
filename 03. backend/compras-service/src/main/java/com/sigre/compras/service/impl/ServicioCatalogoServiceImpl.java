package com.sigre.compras.service.impl;

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
import com.sigre.compras.entity.ServicioCatalogo;
import com.sigre.compras.repository.ServicioCatalogoRepository;
import com.sigre.common.security.TenantContext;
import com.sigre.compras.service.ServicioCatalogoService;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ServicioCatalogoServiceImpl implements ServicioCatalogoService {

    private final ServicioCatalogoRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "servicios", "operation", "findAll"})
    @Override
    public Page<ServicioCatalogo> findAll(Pageable pageable) {
        log.info("Listando servicios catálogo - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<ServicioCatalogo> page = repository.findAll(pageable);
        log.info("Servicios catálogo encontrados: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "servicios", "operation", "findById"})
    @Override
    public ServicioCatalogo findById(Long id) {
        log.info("Buscando servicio catálogo con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Servicio catálogo no encontrado con id: {}", id);
                    return new ResourceNotFoundException("ServicioCatalogo", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "servicios", "operation", "create"})
    @Override
    @Transactional
    public ServicioCatalogo create(ServicioCatalogo entity) {
        log.info("Creando servicio catálogo: {}", entity.getServicio());
        validateUniqueServicio(entity.getServicio(), null);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(java.time.OffsetDateTime.now());
        ServicioCatalogo saved = repository.save(entity);
        log.info("Servicio catálogo creado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "servicios", "operation", "update"})
    @Override
    @Transactional
    public ServicioCatalogo update(Long id, ServicioCatalogo entity) {
        log.info("Actualizando servicio catálogo con id: {}", id);
        findById(id);
        validateUniqueServicio(entity.getServicio(), id);
        entity.setId(id);
        ServicioCatalogo updated = repository.save(entity);
        log.info("Servicio catálogo actualizado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "servicios", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando servicio catálogo con id: {}", id);
        findById(id);
        repository.deleteById(id);
        log.info("Servicio catálogo eliminado exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "servicios", "operation", "activate"})
    @Override
    @Transactional
    public ServicioCatalogo activate(Long id) {
        log.info("Activando servicio catálogo con id: {}", id);
        ServicioCatalogo existing = findById(id);
        existing.setFlagEstado("1");
        ServicioCatalogo activated = repository.save(existing);
        log.info("Servicio catálogo activado exitosamente con id: {}", id);
        return activated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "servicio", "operation", "deactivate"})
    @Override
    @Transactional
    public ServicioCatalogo deactivate(Long id) {
        log.info("Desactivando servicio catálogo con id: {}", id);
        ServicioCatalogo existing = findById(id);
        existing.setFlagEstado("0");
        ServicioCatalogo deactivated = repository.save(existing);
        log.info("Servicio catálogo desactivado exitosamente con id: {}", id);
        return deactivated;
    }

    private void validateUniqueServicio(String servicio, Long excludeId) {
        boolean exists = excludeId == null
                ? repository.existsByServicioIgnoreCase(servicio)
                : repository.existsByServicioIgnoreCaseAndIdNot(servicio, excludeId);
        if (exists) {
            throw new BusinessException(
                    "Ya existe un servicio con el código: " + servicio,
                    HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
    }
}
