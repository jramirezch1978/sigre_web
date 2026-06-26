package pe.restaurant.ventas.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.ventas.dto.request.ZonaRepartoRequest;
import pe.restaurant.ventas.dto.response.ZonaRepartoResponse;
import pe.restaurant.ventas.entity.ZonaReparto;
import pe.restaurant.ventas.mapper.ZonaRepartoMapper;
import pe.restaurant.ventas.repository.ZonaRepartoRepository;
import pe.restaurant.ventas.service.ZonaRepartoService;
import pe.restaurant.ventas.service.VentasErrorCodes;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ZonaRepartoServiceImpl implements ZonaRepartoService {

    private final ZonaRepartoRepository repository;
    private final ZonaRepartoMapper mapper;

    @Timed(value = "app.db.query", extraTags = {"table", "vta_zona_reparto", "operation", "findAll"})
    @Override
    public Page<ZonaReparto> findAll(Pageable pageable) {
        log.info("Listando zonas de reparto - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<ZonaReparto> page = repository.findAll(pageable);
        log.info("Zonas de reparto encontradas: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "vta_zona_reparto", "operation", "findAllWithFilters"})
    @Override
    public Page<ZonaReparto> findAllWithFilters(String zonaReparto, String descZonaReparto, String ubigeo, String flagEstado, Pageable pageable) {
        log.info("Listando zonas de reparto con filtros - zonaReparto: {}, descZonaReparto: {}, ubigeo: {}, flagEstado: {}",
                zonaReparto, descZonaReparto, ubigeo, flagEstado);
        Page<ZonaReparto> page = repository.findAllWithFilters(zonaReparto, descZonaReparto, ubigeo, flagEstado, pageable);
        log.info("Zonas de reparto encontradas con filtros: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "vta_zona_reparto", "operation", "findById"})
    @Override
    public ZonaReparto findById(Long id) {
        log.info("Buscando zona de reparto con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Zona de reparto no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Zona de reparto", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "vta_zona_reparto", "operation", "create"})
    @Override
    @Transactional
    public ZonaReparto create(ZonaReparto entity) {
        log.info("Creando zona de reparto: {}", entity.getZonaReparto());
        validateUniqueZonaReparto(entity.getZonaReparto(), null);
        
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFlagEstado("1");
        
        ZonaReparto saved = repository.save(entity);
        log.info("Zona de reparto creada exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "vta_zona_reparto", "operation", "update"})
    @Override
    @Transactional
    public ZonaReparto update(Long id, ZonaReparto entity) {
        log.info("Actualizando zona de reparto con id: {}", id);
        ZonaReparto existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Zona de reparto no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Zona de reparto", id);
                });
        
        validateUniqueZonaReparto(entity.getZonaReparto(), id);
        
        existing.setZonaReparto(entity.getZonaReparto());
        existing.setDescZonaReparto(entity.getDescZonaReparto());
        existing.setUbigeo(entity.getUbigeo());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        ZonaReparto updated = repository.save(existing);
        log.info("Zona de reparto actualizada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "vta_zona_reparto", "operation", "activate"})
    @Override
    @Transactional
    public ZonaReparto activate(Long id) {
        log.info("Activando zona de reparto con id: {}", id);
        ZonaReparto existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Zona de reparto no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Zona de reparto", id);
                });
        
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        ZonaReparto activated = repository.save(existing);
        log.info("Zona de reparto activada exitosamente con id: {}", id);
        return activated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "vta_zona_reparto", "operation", "deactivate"})
    @Override
    @Transactional
    public ZonaReparto deactivate(Long id) {
        log.info("Desactivando zona de reparto con id: {}", id);
        ZonaReparto existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Zona de reparto no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Zona de reparto", id);
                });
        
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        ZonaReparto deactivated = repository.save(existing);
        log.info("Zona de reparto desactivada exitosamente con id: {}", id);
        return deactivated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "vta_zona_reparto", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando zona de reparto con id: {}", id);
        ZonaReparto existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Zona de reparto no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Zona de reparto", id);
                });
        
        repository.delete(existing);
        log.info("Zona de reparto eliminada exitosamente con id: {}", id);
    }

    private void validateUniqueZonaReparto(String zonaReparto, Long excludeId) {
        boolean exists = (excludeId == null)
                ? repository.existsByZonaRepartoAndFlagEstado(zonaReparto, "1")
                : repository.existsByZonaRepartoAndFlagEstadoAndIdNot(zonaReparto, "1", excludeId);
        
        if (exists) {
            log.warn("Intento de duplicar zona de reparto: {}", zonaReparto);
            throw new BusinessException(
                    "Ya existe una zona de reparto con código: " + zonaReparto,
                    org.springframework.http.HttpStatus.CONFLICT,
                    VentasErrorCodes.ZONA_NOMBRE_DUPLICADO);
        }
    }
}
