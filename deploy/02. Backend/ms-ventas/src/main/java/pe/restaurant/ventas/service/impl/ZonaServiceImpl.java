package pe.restaurant.ventas.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.ventas.dto.response.ZonaResponse;
import pe.restaurant.ventas.entity.Zona;
import pe.restaurant.ventas.mapper.ZonaMapper;
import pe.restaurant.ventas.repository.ZonaRepository;
import pe.restaurant.ventas.service.VentasErrorCodes;
import pe.restaurant.ventas.service.ZonaService;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ZonaServiceImpl implements ZonaService {
    
    private final ZonaRepository repository;
    private final ZonaMapper mapper;
    
    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "zona", "operation", "findAll"})
    public Page<Zona> findAll(Pageable pageable) {
        log.debug("Obteniendo todas las zonas paginadas");
        return repository.findAll(pageable);
    }
    
    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "zona", "operation", "findAllWithFilters"})
    public Page<Zona> findAllWithFilters(Long sucursalId, String nombre, String flagEstado, Pageable pageable) {
        log.debug("Obteniendo zonas con filtros: sucursalId={}, nombre={}, flagEstado={}", sucursalId, nombre, flagEstado);
        
        if (sucursalId != null || nombre != null || flagEstado != null) {
            return repository.findByFilters(sucursalId, nombre, flagEstado, pageable);
        } else {
            return repository.findAll(pageable);
        }
    }
    
    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "zona", "operation", "findById"})
    public ZonaResponse findById(Long id) {
        log.debug("Buscando zona por id: {}", id);
        Zona entity = repository.findByIdAndFlagEstado(id, "1")
                .orElseThrow(() -> {
                    log.warn("Zona no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Zona", id);
                });
        return mapper.toResponse(entity);
    }
    
    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "zona", "operation", "findBySucursalId"})
    public List<ZonaResponse> findBySucursalId(Long sucursalId) {
        log.debug("Buscando zonas por sucursalId: {}", sucursalId);
        List<Zona> entities = repository.findBySucursalIdAndActivo(sucursalId);
        return mapper.toResponseList(entities);
    }
    
    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "zona", "operation", "findAllActivas"})
    public List<ZonaResponse> findAllActivas() {
        log.debug("Buscando todas las zonas activas");
        List<Zona> entities = repository.findAllActivas();
        return mapper.toResponseList(entities);
    }
    
    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "zona", "operation", "create"})
    @Transactional
    public Zona create(Zona entity) {
        log.info("Creando nueva zona: {}", entity.getNombre());
        
        validateUniqueNombre(entity.getNombre(), entity.getSucursal().getId(), null);
        
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFlagEstado("1");
        
        Zona saved = repository.save(entity);
        log.info("Zona creada exitosamente con id: {}", saved.getId());
        return saved;
    }
    
    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "zona", "operation", "update"})
    @Transactional
    public Zona update(Long id, Zona entity) {
        log.info("Actualizando zona con id: {}", id);
        Zona existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Zona no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Zona", id);
                });
        
        validateUniqueNombre(entity.getNombre(), entity.getSucursal().getId(), id);
        
        existing.setSucursal(entity.getSucursal());
        existing.setNombre(entity.getNombre());
        existing.setCapacidad(entity.getCapacidad());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        Zona updated = repository.save(existing);
        log.info("Zona actualizada exitosamente con id: {}", id);
        return updated;
    }
    
    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "zona", "operation", "activate"})
    @Transactional
    public Zona activate(Long id) {
        log.info("Activando zona con id: {}", id);
        Zona existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Zona no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Zona", id);
                });
        
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        Zona activated = repository.save(existing);
        log.info("Zona activada exitosamente con id: {}", id);
        return activated;
    }
    
    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "zona", "operation", "deactivate"})
    @Transactional
    public Zona deactivate(Long id) {
        log.info("Desactivando zona con id: {}", id);
        Zona existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Zona no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Zona", id);
                });
        
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        Zona deactivated = repository.save(existing);
        log.info("Zona desactivada exitosamente con id: {}", id);
        return deactivated;
    }
    
    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "zona", "operation", "delete"})
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando zona con id: {}", id);
        Zona existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Zona no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Zona", id);
                });
        
        repository.delete(existing);
        log.info("Zona eliminada exitosamente con id: {}", id);
    }
    
    private void validateUniqueNombre(String nombre, Long sucursalId, Long excludeId) {
        boolean exists;
        if (excludeId != null) {
            exists = repository.existsBySucursalIdAndNombreAndFlagEstadoAndIdNot(sucursalId, nombre, "1", excludeId);
        } else {
            exists = repository.existsBySucursalIdAndNombreAndFlagEstado(sucursalId, nombre, "1");
        }
        
        if (exists) {
            log.warn("Nombre de zona duplicado: {} para sucursal: {}", nombre, sucursalId);
            throw new BusinessException(
                    "Ya existe una zona con el nombre '" + nombre + "' en esta sucursal",
                    org.springframework.http.HttpStatus.CONFLICT,
                    VentasErrorCodes.ZONA_NOMBRE_DUPLICADO);
        }
    }
}
