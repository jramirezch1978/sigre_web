package pe.restaurant.ventas.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.ventas.dto.request.ZonaDespachoRequest;
import pe.restaurant.ventas.dto.response.ZonaDespachoResponse;
import pe.restaurant.ventas.entity.ZonaDespacho;
import pe.restaurant.ventas.mapper.ZonaDespachoMapper;
import pe.restaurant.ventas.repository.ZonaDespachoRepository;
import pe.restaurant.ventas.service.ZonaDespachoService;
import pe.restaurant.ventas.service.VentasErrorCodes;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ZonaDespachoServiceImpl implements ZonaDespachoService {

    private final ZonaDespachoRepository repository;
    private final ZonaDespachoMapper mapper;

    @Timed(value = "app.db.query", extraTags = {"table", "vta_zona_despacho", "operation", "findAll"})
    @Override
    public Page<ZonaDespacho> findAll(Pageable pageable) {
        log.info("Listando zonas de despacho - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<ZonaDespacho> page = repository.findAll(pageable);
        log.info("Zonas de despacho encontradas: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "vta_zona_despacho", "operation", "findAllWithFilters"})
    @Override
    public Page<ZonaDespacho> findAllWithFilters(String zonaDespacho, String descZonaDespacho, String ubigeo, String flagEstado, Pageable pageable) {
        log.info("Listando zonas de despacho con filtros - zonaDespacho: {}, descZonaDespacho: {}, ubigeo: {}, flagEstado: {}",
                zonaDespacho, descZonaDespacho, ubigeo, flagEstado);
        Page<ZonaDespacho> page = repository.findAllWithFilters(zonaDespacho, descZonaDespacho, ubigeo, flagEstado, pageable);
        log.info("Zonas de despacho encontradas con filtros: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "vta_zona_despacho", "operation", "findById"})
    @Override
    public ZonaDespacho findById(Long id) {
        log.info("Buscando zona de despacho con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Zona de despacho no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Zona de despacho", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "vta_zona_despacho", "operation", "create"})
    @Override
    @Transactional
    public ZonaDespacho create(ZonaDespacho entity) {
        log.info("Creando zona de despacho: {}", entity.getZonaDespacho());
        validateUniqueZonaDespacho(entity.getZonaDespacho(), null);
        
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFlagEstado("1");
        
        ZonaDespacho saved = repository.save(entity);
        log.info("Zona de despacho creada exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "vta_zona_despacho", "operation", "update"})
    @Override
    @Transactional
    public ZonaDespacho update(Long id, ZonaDespacho entity) {
        log.info("Actualizando zona de despacho con id: {}", id);
        ZonaDespacho existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Zona de despacho no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Zona de despacho", id);
                });
        
        validateUniqueZonaDespacho(entity.getZonaDespacho(), id);
        
        existing.setZonaDespacho(entity.getZonaDespacho());
        existing.setDescZonaDespacho(entity.getDescZonaDespacho());
        existing.setUbigeo(entity.getUbigeo());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        ZonaDespacho updated = repository.save(existing);
        log.info("Zona de despacho actualizada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "vta_zona_despacho", "operation", "activate"})
    @Override
    @Transactional
    public ZonaDespacho activate(Long id) {
        log.info("Activando zona de despacho con id: {}", id);
        ZonaDespacho existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Zona de despacho no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Zona de despacho", id);
                });
        
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        ZonaDespacho activated = repository.save(existing);
        log.info("Zona de despacho activada exitosamente con id: {}", id);
        return activated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "vta_zona_despacho", "operation", "deactivate"})
    @Override
    @Transactional
    public ZonaDespacho deactivate(Long id) {
        log.info("Desactivando zona de despacho con id: {}", id);
        ZonaDespacho existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Zona de despacho no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Zona de despacho", id);
                });
        
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        ZonaDespacho deactivated = repository.save(existing);
        log.info("Zona de despacho desactivada exitosamente con id: {}", id);
        return deactivated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "vta_zona_despacho", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando zona de despacho con id: {}", id);
        ZonaDespacho existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Zona de despacho no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Zona de despacho", id);
                });
        
        repository.delete(existing);
        log.info("Zona de despacho eliminada exitosamente con id: {}", id);
    }

    private void validateUniqueZonaDespacho(String zonaDespacho, Long excludeId) {
        boolean exists = (excludeId == null)
                ? repository.existsByZonaDespachoAndFlagEstado(zonaDespacho, "1")
                : repository.existsByZonaDespachoAndFlagEstadoAndIdNot(zonaDespacho, "1", excludeId);
        
        if (exists) {
            log.warn("Intento de duplicar zona de despacho: {}", zonaDespacho);
            throw new BusinessException(
                    "Ya existe una zona de despacho con código: " + zonaDespacho,
                    org.springframework.http.HttpStatus.CONFLICT,
                    VentasErrorCodes.ZONA_NOMBRE_DUPLICADO);
        }
    }
}
