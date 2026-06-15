package com.sigre.comercializacion.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.security.TenantContext;
import com.sigre.comercializacion.dto.request.ZonaVentaRequest;
import com.sigre.comercializacion.dto.response.ZonaVentaResponse;
import com.sigre.comercializacion.entity.ZonaVenta;
import com.sigre.comercializacion.mapper.ZonaVentaMapper;
import com.sigre.comercializacion.repository.ZonaVentaRepository;
import com.sigre.comercializacion.service.ZonaVentaService;
import com.sigre.comercializacion.service.VentasErrorCodes;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ZonaVentaServiceImpl implements ZonaVentaService {

    private final ZonaVentaRepository repository;
    private final ZonaVentaMapper mapper;

    @Timed(value = "app.db.query", extraTags = {"table", "vta_zona_venta", "operation", "findAll"})
    @Override
    public Page<ZonaVenta> findAll(Pageable pageable) {
        log.info("Listando zonas de venta - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<ZonaVenta> page = repository.findAll(pageable);
        log.info("Zonas de venta encontradas: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "vta_zona_venta", "operation", "findAllWithFilters"})
    @Override
    public Page<ZonaVenta> findAllWithFilters(String zonaVenta, String descZonaVenta, String ubigeo, String flagEstado, Pageable pageable) {
        log.info("Listando zonas de venta con filtros - zonaVenta: {}, descZonaVenta: {}, ubigeo: {}, flagEstado: {}",
                zonaVenta, descZonaVenta, ubigeo, flagEstado);
        Page<ZonaVenta> page = repository.findAllWithFilters(zonaVenta, descZonaVenta, ubigeo, flagEstado, pageable);
        log.info("Zonas de venta encontradas con filtros: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "vta_zona_venta", "operation", "findById"})
    @Override
    public ZonaVenta findById(Long id) {
        log.info("Buscando zona de venta con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Zona de venta no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Zona de venta", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "vta_zona_venta", "operation", "create"})
    @Override
    @Transactional
    public ZonaVenta create(ZonaVenta entity) {
        log.info("Creando zona de venta: {}", entity.getZonaVenta());
        validateUniqueZonaVenta(entity.getZonaVenta(), null);
        
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFlagEstado("1");
        
        ZonaVenta saved = repository.save(entity);
        log.info("Zona de venta creada exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "vta_zona_venta", "operation", "update"})
    @Override
    @Transactional
    public ZonaVenta update(Long id, ZonaVenta entity) {
        log.info("Actualizando zona de venta con id: {}", id);
        ZonaVenta existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Zona de venta no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Zona de venta", id);
                });
        
        validateUniqueZonaVenta(entity.getZonaVenta(), id);
        
        existing.setZonaVenta(entity.getZonaVenta());
        existing.setDescZonaVenta(entity.getDescZonaVenta());
        existing.setUbigeo(entity.getUbigeo());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        ZonaVenta updated = repository.save(existing);
        log.info("Zona de venta actualizada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "vta_zona_venta", "operation", "activate"})
    @Override
    @Transactional
    public ZonaVenta activate(Long id) {
        log.info("Activando zona de venta con id: {}", id);
        ZonaVenta existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Zona de venta no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Zona de venta", id);
                });
        
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        ZonaVenta activated = repository.save(existing);
        log.info("Zona de venta activada exitosamente con id: {}", id);
        return activated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "vta_zona_venta", "operation", "deactivate"})
    @Override
    @Transactional
    public ZonaVenta deactivate(Long id) {
        log.info("Desactivando zona de venta con id: {}", id);
        ZonaVenta existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Zona de venta no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Zona de venta", id);
                });
        
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        ZonaVenta deactivated = repository.save(existing);
        log.info("Zona de venta desactivada exitosamente con id: {}", id);
        return deactivated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "vta_zona_venta", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando zona de venta con id: {}", id);
        ZonaVenta existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Zona de venta no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Zona de venta", id);
                });
        
        repository.delete(existing);
        log.info("Zona de venta eliminada exitosamente con id: {}", id);
    }

    private void validateUniqueZonaVenta(String zonaVenta, Long excludeId) {
        boolean exists = (excludeId == null)
                ? repository.existsByZonaVentaAndFlagEstado(zonaVenta, "1")
                : repository.existsByZonaVentaAndFlagEstadoAndIdNot(zonaVenta, "1", excludeId);
        
        if (exists) {
            log.warn("Intento de duplicar zona de venta: {}", zonaVenta);
            throw new BusinessException(
                    "Ya existe una zona de venta con código: " + zonaVenta,
                    org.springframework.http.HttpStatus.CONFLICT,
                    VentasErrorCodes.ZONA_NOMBRE_DUPLICADO);
        }
    }
}
