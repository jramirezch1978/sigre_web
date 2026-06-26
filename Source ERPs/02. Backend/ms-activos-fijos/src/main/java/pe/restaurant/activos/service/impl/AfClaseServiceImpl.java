package pe.restaurant.activos.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.activos.entity.AfClase;
import pe.restaurant.activos.repository.AfClaseRepository;
import pe.restaurant.activos.service.AfClaseService;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.activos.util.ActivosFlagEstado;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AfClaseServiceImpl implements AfClaseService {

    private final AfClaseRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "af_clase", "operation", "findAll"})
    @Override
    public Page<AfClase> findAll(Pageable pageable) {
        log.info("Listando clases de activos fijos - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<AfClase> page = repository.findAll(pageable);
        log.info("Clases de activos encontradas: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_clase", "operation", "findById"})
    @Override
    public AfClase findById(Long id) {
        log.info("Buscando clase de activo con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Clase de activo no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Clase de activo", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_clase", "operation", "create"})
    @Override
    @Transactional
    public AfClase create(AfClase entity) {
        log.info("Creando clase de activo con codigo: {}", entity.getCodigo());
        validarCodigoUnico(entity.getCodigo(), null);
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        AfClase saved = repository.save(entity);
        log.info("Clase de activo creada exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_clase", "operation", "update"})
    @Override
    @Transactional
    public AfClase update(Long id, AfClase entity) {
        log.info("Actualizando clase de activo con id: {}", id);
        AfClase existing = findById(id);
        validarCodigoUnico(entity.getCodigo(), id);
        
        existing.setCodigo(entity.getCodigo());
        existing.setNombre(entity.getNombre());
        existing.setMetodoDepreciacion(entity.getMetodoDepreciacion());
        existing.setVidaUtilMeses(entity.getVidaUtilMeses());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        AfClase updated = repository.save(existing);
        log.info("Clase de activo actualizada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_clase", "operation", "activate"})
    @Override
    @Transactional
    public AfClase activate(Long id) {
        log.info("Activando clase de activo con id: {}", id);
        AfClase entity = findById(id);
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
        AfClase updated = repository.save(entity);
        log.info("Clase de activo activada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_clase", "operation", "deactivate"})
    @Override
    @Transactional
    public AfClase deactivate(Long id) {
        log.info("Desactivando clase de activo con id: {}", id);
        AfClase entity = findById(id);
        entity.setFlagEstado("0");
        AfClase updated = repository.save(entity);
        log.info("Clase de activo desactivada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_clase", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando clase de activo con id: {}", id);
        AfClase existing = findById(id);
        
        // Validar que no existan sub-clases asociadas
        validarSinDependencias(id, existing.getCodigo());
        
        repository.delete(existing);
        log.info("Clase de activo eliminada exitosamente con id: {}", id);
    }

    private void validarSinDependencias(Long afClaseId, String codigo) {
        if (repository.existsSubClasesByAfClaseId(afClaseId)) {
            log.warn("Intento de eliminar clase de activo con sub-clases asociadas: {} (id: {})", codigo, afClaseId);
            throw new BusinessException(
                    "No se puede eliminar la clase de activo porque tiene sub-clases asociadas. Elimine primero las sub-clases.",
                    HttpStatus.CONFLICT,
                    ActivosErrorCodes.CLASE_CON_DEPENDENCIAS
            );
        }
    }

    private void validarCodigoUnico(String codigo, Long excludeId) {
        boolean duplicado = excludeId == null
                ? repository.existsByCodigoIgnoreCase(codigo)
                : repository.existsByCodigoIgnoreCaseAndIdNot(codigo, excludeId);
        if (duplicado) {
            log.warn("Intento de duplicar codigo de clase de activo: {} (excludeId: {})", codigo, excludeId);
            throw new BusinessException(
                    "Ya existe una clase de activo con el código: " + codigo,
                    HttpStatus.CONFLICT,
                    ActivosErrorCodes.CLASE_CODIGO_DUPLICADO
            );
        }
    }
}
