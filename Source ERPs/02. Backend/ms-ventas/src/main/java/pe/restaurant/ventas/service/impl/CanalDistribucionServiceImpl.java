package pe.restaurant.ventas.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.ventas.dto.request.CanalDistribucionRequest;
import pe.restaurant.ventas.dto.response.CanalDistribucionResponse;
import pe.restaurant.ventas.entity.CanalDistribucion;
import pe.restaurant.ventas.mapper.CanalDistribucionMapper;
import pe.restaurant.ventas.repository.CanalDistribucionRepository;
import pe.restaurant.ventas.service.CanalDistribucionService;
import pe.restaurant.ventas.service.VentasErrorCodes;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CanalDistribucionServiceImpl implements CanalDistribucionService {

    private final CanalDistribucionRepository repository;
    private final CanalDistribucionMapper mapper;

    @Timed(value = "app.db.query", extraTags = {"table", "canal_distribucion", "operation", "findAll"})
    @Override
    public Page<CanalDistribucion> findAll(Pageable pageable) {
        log.info("Listando canales de distribución - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<CanalDistribucion> page = repository.findAll(pageable);
        log.info("Canales de distribución encontrados: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "canal_distribucion", "operation", "findAllWithFilters"})
    @Override
    public Page<CanalDistribucion> findAllWithFilters(String codigo, String nombre, String flagEstado, Pageable pageable) {
        log.info("Listando canales de distribución con filtros - codigo: {}, nombre: {}, flagEstado: {}",
                codigo, nombre, flagEstado);
        Page<CanalDistribucion> page = repository.findAllWithFilters(codigo, nombre, flagEstado, pageable);
        log.info("Canales de distribución encontrados con filtros: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "canal_distribucion", "operation", "findById"})
    @Override
    public CanalDistribucion findById(Long id) {
        log.info("Buscando canal de distribución con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Canal de distribución no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Canal de distribución", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "canal_distribucion", "operation", "create"})
    @Override
    @Transactional
    public CanalDistribucion create(CanalDistribucion entity) {
        log.info("Creando canal de distribución con codigo: {}", entity.getCodigo());
        validateUniqueCodigo(entity.getCodigo(), null);
        
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFlagEstado("1");
        
        CanalDistribucion saved = repository.save(entity);
        log.info("Canal de distribución creado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "canal_distribucion", "operation", "update"})
    @Override
    @Transactional
    public CanalDistribucion update(Long id, CanalDistribucion entity) {
        log.info("Actualizando canal de distribución con id: {}", id);
        CanalDistribucion existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Canal de distribución no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Canal de distribución", id);
                });
        
        validateUniqueCodigo(entity.getCodigo(), id);
        
        existing.setCodigo(entity.getCodigo());
        existing.setNombre(entity.getNombre());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        CanalDistribucion updated = repository.save(existing);
        log.info("Canal de distribución actualizado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "canal_distribucion", "operation", "activate"})
    @Override
    @Transactional
    public CanalDistribucion activate(Long id) {
        log.info("Activando canal de distribución con id: {}", id);
        CanalDistribucion existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Canal de distribución no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Canal de distribución", id);
                });
        
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        CanalDistribucion activated = repository.save(existing);
        log.info("Canal de distribución activado exitosamente con id: {}", id);
        return activated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "canal_distribucion", "operation", "deactivate"})
    @Override
    @Transactional
    public CanalDistribucion deactivate(Long id) {
        log.info("Desactivando canal de distribución con id: {}", id);
        CanalDistribucion existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Canal de distribución no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Canal de distribución", id);
                });
        
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        CanalDistribucion deactivated = repository.save(existing);
        log.info("Canal de distribución desactivado exitosamente con id: {}", id);
        return deactivated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "canal_distribucion", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando canal de distribución con id: {}", id);
        CanalDistribucion existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Canal de distribución no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Canal de distribución", id);
                });
        
        repository.delete(existing);
        log.info("Canal de distribución eliminado exitosamente con id: {}", id);
    }

    private void validateUniqueCodigo(String codigo, Long excludeId) {
        boolean exists = (excludeId == null)
                ? repository.existsByCodigoAndFlagEstado(codigo, "1")
                : repository.existsByCodigoAndFlagEstadoAndIdNot(codigo, "1", excludeId);
        
        if (exists) {
            log.warn("Intento de duplicar codigo de canal de distribución: {}", codigo);
            throw new BusinessException(
                    "Ya existe un canal de distribución con código: " + codigo,
                    org.springframework.http.HttpStatus.CONFLICT, 
                    VentasErrorCodes.CANAL_DISTRIBUCION_CODIGO_DUPLICADO);
        }
    }
}
