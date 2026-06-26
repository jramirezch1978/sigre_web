package pe.restaurant.activos.service.impl;

import feign.FeignException;
import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.activos.client.CoreMaestrosClient;
import pe.restaurant.activos.dto.SucursalResponse;
import pe.restaurant.activos.entity.AfUbicacion;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.repository.AfUbicacionRepository;
import pe.restaurant.activos.service.AfUbicacionService;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.activos.util.ActivosFlagEstado;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AfUbicacionServiceImpl implements AfUbicacionService {

    private final AfUbicacionRepository repository;
    private final AfMaestroRepository maestroRepository;
    private final CoreMaestrosClient coreMaestrosClient;

    @Timed(value = "app.db.query", extraTags = {"table", "af_ubicacion", "operation", "findAll"})
    @Override
    public Page<AfUbicacion> findAll(Pageable pageable) {
        log.info("Listando ubicaciones de activos fijos - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<AfUbicacion> page = repository.findAll(pageable);
        log.info("Ubicaciones de activos encontradas: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_ubicacion", "operation", "findById"})
    @Override
    public AfUbicacion findById(Long id) {
        log.info("Buscando ubicación de activo con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Ubicación de activo no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Ubicación de activo", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_ubicacion", "operation", "create"})
    @Override
    @Transactional
    public AfUbicacion create(AfUbicacion entity) {
        log.info("Creando ubicación de activo con codigo: {} para sucursal: {}", 
                entity.getCodigo(), entity.getSucursalId());
        
        validarSucursalExistente(entity.getSucursalId());
        validarCodigoUnico(entity.getCodigo(), entity.getSucursalId(), null);
        
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        AfUbicacion saved = repository.save(entity);
        log.info("Ubicación de activo creada exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_ubicacion", "operation", "update"})
    @Override
    @Transactional
    public AfUbicacion update(Long id, AfUbicacion entity) {
        log.info("Actualizando ubicación de activo con id: {}", id);
        AfUbicacion existing = findById(id);
        
        if (!entity.getSucursalId().equals(existing.getSucursalId())) {
            validarSucursalExistente(entity.getSucursalId());
        }
        validarCodigoUnico(entity.getCodigo(), entity.getSucursalId(), id);
        
        existing.setSucursalId(entity.getSucursalId());
        existing.setCodigo(entity.getCodigo());
        existing.setNombre(entity.getNombre());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        AfUbicacion updated = repository.save(existing);
        log.info("Ubicación de activo actualizada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_ubicacion", "operation", "activate"})
    @Override
    @Transactional
    public AfUbicacion activate(Long id) {
        log.info("Activando ubicación de activo con id: {}", id);
        AfUbicacion entity = findById(id);
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        AfUbicacion updated = repository.save(entity);
        log.info("Ubicación de activo activada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_ubicacion", "operation", "deactivate"})
    @Override
    @Transactional
    public AfUbicacion deactivate(Long id) {
        log.info("Desactivando ubicación de activo con id: {}", id);
        AfUbicacion entity = findById(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        AfUbicacion updated = repository.save(entity);
        log.info("Ubicación de activo desactivada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_ubicacion", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando ubicación de activo con id: {}", id);
        AfUbicacion existing = findById(id);
        if (maestroRepository.existsByAfUbicacionId(id)) {
            log.warn("Intento de eliminar ubicación id {} con activos fijos asociados", id);
            throw new BusinessException(
                    "No se puede eliminar la ubicación porque existen activos fijos que la utilizan.",
                    HttpStatus.CONFLICT,
                    ActivosErrorCodes.UBICACION_CON_MAESTROS
            );
        }
        repository.delete(existing);
        log.info("Ubicación de activo eliminada exitosamente con id: {}", id);
    }

    private void validarSucursalExistente(Long sucursalId) {
        try {
            log.debug("Validando existencia de sucursal con id: {}", sucursalId);
            ApiResponse<SucursalResponse> response = coreMaestrosClient.obtenerSucursalPorId(sucursalId);
            
            if (response == null || response.getData() == null) {
                log.warn("Sucursal no encontrada con id: {}", sucursalId);
                throw new BusinessException(
                    "La sucursal con ID " + sucursalId + " no existe en el sistema",
                    HttpStatus.NOT_FOUND,
                    ActivosErrorCodes.SUCURSAL_NO_ENCONTRADA
                );
            }
            
            SucursalResponse sucursal = response.getData();
            if (!"1".equals(sucursal.getFlagEstado())) {
                log.warn("Sucursal inactiva con id: {}", sucursalId);
                throw new BusinessException(
                    "La sucursal '" + sucursal.getNombre() + "' está inactiva. Debe activarla antes de usarla",
                    HttpStatus.BAD_REQUEST,
                    ActivosErrorCodes.SUCURSAL_INACTIVA
                );
            }
            
            log.debug("Sucursal validada exitosamente: {} - {}", sucursal.getCodigo(), sucursal.getNombre());
            
        } catch (FeignException.NotFound e) {
            log.warn("Sucursal no encontrada con id: {} - Error: {}", sucursalId, e.getMessage());
            throw new BusinessException(
                "La sucursal con ID " + sucursalId + " no existe en el sistema",
                HttpStatus.NOT_FOUND,
                ActivosErrorCodes.SUCURSAL_NO_ENCONTRADA
            );
        } catch (FeignException e) {
            log.error("Error al comunicarse con ms-core-maestros para validar sucursal {}: {}", 
                    sucursalId, e.getMessage());
            throw new BusinessException(
                "Error al validar la sucursal. Por favor, intente nuevamente",
                HttpStatus.SERVICE_UNAVAILABLE,
                "ACT-999"
            );
        }
    }

    private void validarCodigoUnico(String codigo, Long sucursalId, Long excludeId) {
        boolean exists = (excludeId == null)
                ? repository.existsBySucursalIdAndCodigoIgnoreCase(sucursalId, codigo)
                : repository.existsBySucursalIdAndCodigoIgnoreCaseAndIdNot(sucursalId, codigo, excludeId);
        
        if (exists) {
            log.warn("Intento de duplicar codigo de ubicación: {} para sucursal: {} (ubicación existente id: {})", 
                    codigo, sucursalId, excludeId);
            throw new BusinessException(
                    "Ya existe una ubicación con el código: " + codigo + " para la sucursal seleccionada",
                    HttpStatus.CONFLICT,
                    ActivosErrorCodes.UBICACION_CODIGO_DUPLICADO
            );
        }
    }
    
}
