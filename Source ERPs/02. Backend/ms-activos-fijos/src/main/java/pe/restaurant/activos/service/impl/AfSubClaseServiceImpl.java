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
import pe.restaurant.activos.entity.AfSubClase;
import pe.restaurant.activos.repository.AfClaseRepository;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.repository.AfSubClaseRepository;
import pe.restaurant.activos.service.AfSubClaseService;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.activos.util.ActivosFlagEstado;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AfSubClaseServiceImpl implements AfSubClaseService {

    private final AfSubClaseRepository repository;
    private final AfClaseRepository afClaseRepository;
    private final AfMaestroRepository maestroRepository;

    @Timed(value = "app.db.query", extraTags = {"table", "af_sub_clase", "operation", "findAll"})
    @Override
    public Page<AfSubClase> findAll(Pageable pageable) {
        log.info("Listando sub-clases de activos fijos - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<AfSubClase> page = repository.findAll(pageable);
        log.info("Sub-clases de activos encontradas: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_sub_clase", "operation", "findById"})
    @Override
    public AfSubClase findById(Long id) {
        log.info("Buscando sub-clase de activo con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Sub-clase de activo no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Sub-clase de activo", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_sub_clase", "operation", "create"})
    @Override
    @Transactional
    public AfSubClase create(AfSubClase entity) {
        log.info("Creando sub-clase de activo con codigo: {} para clase: {}", 
                entity.getCodigo(), entity.getAfClaseId());
        
        validarAfClaseExistente(entity.getAfClaseId());
        validarCodigoUnico(entity.getCodigo(), entity.getAfClaseId(), null);
        
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        AfSubClase saved = repository.save(entity);
        log.info("Sub-clase de activo creada exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_sub_clase", "operation", "update"})
    @Override
    @Transactional
    public AfSubClase update(Long id, AfSubClase entity) {
        log.info("Actualizando sub-clase de activo con id: {}", id);
        AfSubClase existing = findById(id);
        
        validarAfClaseExistente(entity.getAfClaseId());
        validarCodigoUnico(entity.getCodigo(), entity.getAfClaseId(), id);
        
        existing.setAfClaseId(entity.getAfClaseId());
        existing.setCodigo(entity.getCodigo());
        existing.setNombre(entity.getNombre());
        existing.setVidaUtilMeses(entity.getVidaUtilMeses());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        AfSubClase updated = repository.save(existing);
        log.info("Sub-clase de activo actualizada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_sub_clase", "operation", "activate"})
    @Override
    @Transactional
    public AfSubClase activate(Long id) {
        log.info("Activando sub-clase de activo con id: {}", id);
        AfSubClase entity = findById(id);
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
        AfSubClase updated = repository.save(entity);
        log.info("Sub-clase de activo activada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_sub_clase", "operation", "deactivate"})
    @Override
    @Transactional
    public AfSubClase deactivate(Long id) {
        log.info("Desactivando sub-clase de activo con id: {}", id);
        AfSubClase entity = findById(id);
        entity.setFlagEstado("0");
        AfSubClase updated = repository.save(entity);
        log.info("Sub-clase de activo desactivada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_sub_clase", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando sub-clase de activo con id: {}", id);
        AfSubClase existing = findById(id);
        
        validarSinDependencias(id, existing.getCodigo());
        
        repository.delete(existing);
        log.info("Sub-clase de activo eliminada exitosamente con id: {}", id);
    }

    private void validarAfClaseExistente(Long afClaseId) {
        AfClase clase = afClaseRepository.findById(afClaseId)
                .orElseThrow(() -> {
                    log.warn("Clase de activo no encontrada con id: {}", afClaseId);
                    return new ResourceNotFoundException("Clase de activo", afClaseId);
                });
        if (!ActivosFlagEstado.ACTIVO.equals(clase.getFlagEstado())) {
            log.warn("Clase de activo inactiva con id: {}", afClaseId);
            throw new BusinessException(
                    "La clase de activo está inactiva. Actívela antes de usar esta subclase.",
                    HttpStatus.BAD_REQUEST,
                    ActivosErrorCodes.CLASE_INACTIVA
            );
        }
    }

    private void validarCodigoUnico(String codigo, Long afClaseId, Long excludeId) {
        boolean exists = (excludeId == null)
                ? repository.existsByAfClaseIdAndCodigoIgnoreCase(afClaseId, codigo)
                : repository.existsByAfClaseIdAndCodigoIgnoreCaseAndIdNot(afClaseId, codigo, excludeId);
        
        if (exists) {
            log.warn("Intento de duplicar codigo de sub-clase de activo: {} para clase: {} (sub-clase existente id: {})", 
                    codigo, afClaseId, excludeId);
            throw new BusinessException(
                    "Ya existe una sub-clase de activo con el código: " + codigo + " para la clase seleccionada",
                    HttpStatus.CONFLICT,
                    ActivosErrorCodes.SUB_CLASE_CODIGO_DUPLICADO
            );
        }
    }

    private void validarSinDependencias(Long afSubClaseId, String codigo) {
        if (maestroRepository.existsByAfSubClaseId(afSubClaseId)) {
            log.warn("Intento de eliminar sub-clase {} (id: {}) con activos maestro asociados", codigo, afSubClaseId);
            throw new BusinessException(
                    "No se puede eliminar la sub-clase porque existen activos fijos que la utilizan.",
                    HttpStatus.CONFLICT,
                    ActivosErrorCodes.SUB_CLASE_CON_MAESTROS
            );
        }
    }
}
