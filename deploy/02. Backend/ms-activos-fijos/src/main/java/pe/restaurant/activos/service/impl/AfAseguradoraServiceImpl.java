package pe.restaurant.activos.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.activos.entity.AfAseguradora;
import pe.restaurant.activos.repository.AfAseguradoraRepository;
import pe.restaurant.activos.service.AfAseguradoraService;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.activos.util.ActivosFlagEstado;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AfAseguradoraServiceImpl implements AfAseguradoraService {

    private final AfAseguradoraRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "af_aseguradora", "operation", "findAll"})
    @Override
    public Page<AfAseguradora> findAll(Pageable pageable) {
        log.info("Listando aseguradoras de activos fijos - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<AfAseguradora> page = repository.findAll(pageable);
        log.info("Aseguradoras de activos encontradas: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_aseguradora", "operation", "findById"})
    @Override
    public AfAseguradora findById(Long id) {
        log.info("Buscando aseguradora de activo con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Aseguradora de activo no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Aseguradora de activo", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_aseguradora", "operation", "create"})
    @Override
    @Transactional
    public AfAseguradora create(AfAseguradora entity) {
        log.info("Creando aseguradora de activo con nombre: {}", entity.getNombre());
        
        validarNombreUnico(entity.getNombre(), null);
        validarRucUnico(entity.getRuc(), null);
        
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        AfAseguradora saved = repository.save(entity);
        log.info("Aseguradora de activo creada exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_aseguradora", "operation", "update"})
    @Override
    @Transactional
    public AfAseguradora update(Long id, AfAseguradora entity) {
        log.info("Actualizando aseguradora de activo con id: {}", id);
        AfAseguradora existing = findById(id);
        
        validarNombreUnico(entity.getNombre(), id);
        validarRucUnico(entity.getRuc(), id);
        
        existing.setNombre(entity.getNombre());
        existing.setRuc(entity.getRuc());
        existing.setContacto(entity.getContacto());
        
        AfAseguradora updated = repository.save(existing);
        log.info("Aseguradora de activo actualizada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_aseguradora", "operation", "activate"})
    @Override
    @Transactional
    public AfAseguradora activate(Long id) {
        log.info("Activando aseguradora de activo con id: {}", id);
        AfAseguradora entity = findById(id);
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
        AfAseguradora updated = repository.save(entity);
        log.info("Aseguradora de activo activada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_aseguradora", "operation", "deactivate"})
    @Override
    @Transactional
    public AfAseguradora deactivate(Long id) {
        log.info("Desactivando aseguradora de activo con id: {}", id);
        AfAseguradora entity = findById(id);
        entity.setFlagEstado("0");
        AfAseguradora updated = repository.save(entity);
        log.info("Aseguradora de activo desactivada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_aseguradora", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando aseguradora de activo con id: {}", id);
        AfAseguradora existing = findById(id);
        repository.delete(existing);
        log.info("Aseguradora de activo eliminada exitosamente con id: {}", id);
    }

    private void validarNombreUnico(String nombre, Long excludeId) {
        if (nombre == null || nombre.trim().isEmpty()) {
            return;
        }
        
        boolean exists = (excludeId == null)
                ? repository.existsByNombreIgnoreCase(nombre)
                : repository.existsByNombreIgnoreCaseAndIdNot(nombre, excludeId);
        
        if (exists) {
            log.warn("Intento de duplicar nombre de aseguradora: {} (aseguradora existente id: {})", nombre, excludeId);
            throw new BusinessException(
                    "Ya existe una aseguradora con el nombre: " + nombre,
                    HttpStatus.CONFLICT,
                    ActivosErrorCodes.ASEGURADORA_NOMBRE_DUPLICADO
            );
        }
    }

    private void validarRucUnico(String ruc, Long excludeId) {
        if (ruc == null || ruc.trim().isEmpty()) {
            return;
        }
        
        boolean exists = (excludeId == null)
                ? repository.existsByRucIgnoreCase(ruc)
                : repository.existsByRucIgnoreCaseAndIdNot(ruc, excludeId);
        
        if (exists) {
            log.warn("Intento de duplicar RUC de aseguradora: {} (aseguradora existente id: {})", ruc, excludeId);
            throw new BusinessException(
                    "Ya existe una aseguradora con el RUC: " + ruc,
                    HttpStatus.CONFLICT,
                    ActivosErrorCodes.ASEGURADORA_RUC_DUPLICADO
            );
        }
    }

}
