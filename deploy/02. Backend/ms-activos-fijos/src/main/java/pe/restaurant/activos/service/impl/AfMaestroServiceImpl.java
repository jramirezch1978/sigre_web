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
import pe.restaurant.activos.dto.EntidadContribuyenteResponse;
import pe.restaurant.activos.entity.AfClase;
import pe.restaurant.activos.entity.AfMaestro;
import pe.restaurant.activos.entity.AfSubClase;
import pe.restaurant.activos.entity.AfUbicacion;
import pe.restaurant.activos.integracion.ContabilidadAutoContabilizador;
import pe.restaurant.activos.repository.AfCalculoCntblRepository;
import pe.restaurant.activos.repository.AfClaseRepository;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.repository.AfSubClaseRepository;
import pe.restaurant.activos.repository.AfUbicacionRepository;
import pe.restaurant.activos.repository.AfVentaRepository;
import pe.restaurant.activos.service.AfMaestroService;
import pe.restaurant.activos.service.ContabilidadIntegracionService;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.activos.util.ActivosFlagEstado;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

import java.math.BigDecimal;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AfMaestroServiceImpl implements AfMaestroService {

    private final AfMaestroRepository repository;
    private final AfSubClaseRepository subClaseRepository;
    private final AfUbicacionRepository ubicacionRepository;
    private final AfClaseRepository afClaseRepository;
    private final AfCalculoCntblRepository calculoCntblRepository;
    private final CoreMaestrosClient coreMaestrosClient;
    private final AfVentaRepository ventaRepository;
    private final ContabilidadIntegracionService contabilidadIntegracionService;
    private final ContabilidadAutoContabilizador contabilidadAutoContabilizador;

    @Timed(value = "app.db.query", extraTags = {"table", "af_maestro", "operation", "findAll"})
    @Override
    public Page<AfMaestro> findAll(Pageable pageable) {
        log.info("Listando activos fijos - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<AfMaestro> page = repository.findAll(pageable);
        log.info("Activos fijos encontrados: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_maestro", "operation", "findById"})
    @Override
    public AfMaestro findById(Long id) {
        log.info("Buscando activo fijo con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Activo fijo no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Activo fijo", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_maestro", "operation", "create"})
    @Override
    @Transactional
    public AfMaestro create(AfMaestro entity) {
        log.info("Creando activo fijo con codigo: {}", entity.getCodigo());
        
        validarCodigoUnico(entity.getCodigo(), null);
        validarSubClaseExistente(entity.getAfSubClaseId());
        
        if (entity.getAfUbicacionId() != null) {
            validarUbicacionExistente(entity.getAfUbicacionId());
        }
        
        if (entity.getProveedorId() != null) {
            validarProveedorExistente(entity.getProveedorId());
        }
        
        validarValorResidual(entity.getValorAdquisicion(), entity.getValorResidual());
        
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        
        AfMaestro saved = repository.save(entity);
        log.info("Activo fijo creado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_maestro", "operation", "update"})
    @Override
    @Transactional
    public AfMaestro update(Long id, AfMaestro entity) {
        log.info("Actualizando activo fijo con id: {}", id);
        AfMaestro existing = findById(id);
        
        validarCodigoUnico(entity.getCodigo(), id);
        
        if (!entity.getAfSubClaseId().equals(existing.getAfSubClaseId())) {
            validarSubClaseExistente(entity.getAfSubClaseId());
        }
        
        if (entity.getAfUbicacionId() != null && 
            !entity.getAfUbicacionId().equals(existing.getAfUbicacionId())) {
            validarUbicacionExistente(entity.getAfUbicacionId());
        }
        
        if (entity.getProveedorId() != null && 
            !entity.getProveedorId().equals(existing.getProveedorId())) {
            validarProveedorExistente(entity.getProveedorId());
        }
        
        validarValorResidual(entity.getValorAdquisicion(), entity.getValorResidual());
        
        existing.setCodigo(entity.getCodigo());
        existing.setNombre(entity.getNombre());
        existing.setAfSubClaseId(entity.getAfSubClaseId());
        existing.setAfUbicacionId(entity.getAfUbicacionId());
        existing.setFechaAdquisicion(entity.getFechaAdquisicion());
        existing.setValorAdquisicion(entity.getValorAdquisicion());
        existing.setValorResidual(entity.getValorResidual());
        existing.setProveedorId(entity.getProveedorId());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        AfMaestro updated = repository.save(existing);
        log.info("Activo fijo actualizado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_maestro", "operation", "activate"})
    @Override
    @Transactional
    public AfMaestro activate(Long id) {
        log.info("Activando activo fijo con id: {}", id);
        AfMaestro entity = findById(id);
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
        AfMaestro updated = repository.save(entity);
        log.info("Activo fijo activado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_maestro", "operation", "deactivate"})
    @Override
    @Transactional
    public AfMaestro deactivate(Long id) {
        log.info("Desactivando activo fijo con id: {}", id);
        AfMaestro entity = findById(id);
        boolean estabaActivo = ActivosFlagEstado.ACTIVO.equals(entity.getFlagEstado());
        entity.setFlagEstado("0");
        AfMaestro updated = repository.save(entity);
        if (estabaActivo && !ventaRepository.existsByAfMaestroId(id)) {
            contabilidadAutoContabilizador.ejecutarSiAutomatico(
                    "baja-activo",
                    () -> contabilidadIntegracionService.contabilizarBajaActivo(id));
        }
        log.info("Activo fijo desactivado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_maestro", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando activo fijo con id: {}", id);
        AfMaestro existing = findById(id);
        if (calculoCntblRepository.existsByAfMaestroId(id)) {
            log.warn("Intento de eliminar activo fijo id {} con depreciación registrada", id);
            throw new BusinessException(
                    "No se puede eliminar el activo fijo porque existen registros de depreciación asociados.",
                    HttpStatus.CONFLICT,
                    ActivosErrorCodes.MAESTRO_CON_DEPRECIACION
            );
        }
        repository.delete(existing);
        log.info("Activo fijo eliminado exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_maestro", "operation", "findByAfSubClaseId"})
    @Override
    public Page<AfMaestro> findByAfSubClaseId(Long afSubClaseId, Pageable pageable) {
        log.info("Listando activos fijos por sub-clase: {}", afSubClaseId);
        Page<AfMaestro> page = repository.findByAfSubClaseId(afSubClaseId, pageable);
        log.info("Activos fijos encontrados para sub-clase {}: {}", afSubClaseId, page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_maestro", "operation", "findByAfUbicacionId"})
    @Override
    public Page<AfMaestro> findByAfUbicacionId(Long afUbicacionId, Pageable pageable) {
        log.info("Listando activos fijos por ubicación: {}", afUbicacionId);
        Page<AfMaestro> page = repository.findByAfUbicacionId(afUbicacionId, pageable);
        log.info("Activos fijos encontrados para ubicación {}: {}", afUbicacionId, page.getTotalElements());
        return page;
    }

    private void validarCodigoUnico(String codigo, Long excludeId) {
        boolean exists = (excludeId == null)
                ? repository.existsByCodigoIgnoreCase(codigo)
                : repository.existsByCodigoIgnoreCaseAndIdNot(codigo, excludeId);
        
        if (exists) {
            log.warn("Intento de duplicar codigo de activo fijo: {} (activo existente id: {})", 
                    codigo, excludeId);
            throw new BusinessException(
                    "Ya existe un activo fijo con el código: " + codigo,
                    HttpStatus.CONFLICT,
                    ActivosErrorCodes.MAESTRO_CODIGO_DUPLICADO
            );
        }
    }

    private void validarSubClaseExistente(Long afSubClaseId) {
        log.debug("Validando existencia de sub-clase con id: {}", afSubClaseId);
        AfSubClase subClase = subClaseRepository.findById(afSubClaseId)
                .orElseThrow(() -> {
                    log.warn("Sub-clase no encontrada con id: {}", afSubClaseId);
                    return new BusinessException(
                            "La sub-clase de activo con ID " + afSubClaseId + " no existe en el sistema",
                            HttpStatus.NOT_FOUND,
                            ActivosErrorCodes.SUB_CLASE_NO_ENCONTRADA
                    );
                });
        
        if (!ActivosFlagEstado.ACTIVO.equals(subClase.getFlagEstado())) {
            log.warn("Sub-clase inactiva con id: {}", afSubClaseId);
            throw new BusinessException(
                    "La sub-clase de activo está inactiva. Debe activarla antes de usarla",
                    HttpStatus.BAD_REQUEST,
                    ActivosErrorCodes.SUB_CLASE_INACTIVA
            );
        }

        AfClase clase = afClaseRepository.findById(subClase.getAfClaseId())
                .orElseThrow(() -> {
                    log.warn("Clase de activo no encontrada con id: {} (sub-clase {})", subClase.getAfClaseId(), afSubClaseId);
                    return new ResourceNotFoundException("Clase de activo", subClase.getAfClaseId());
                });
        if (!ActivosFlagEstado.ACTIVO.equals(clase.getFlagEstado())) {
            log.warn("Clase de activo inactiva con id: {} (sub-clase {})", subClase.getAfClaseId(), afSubClaseId);
            throw new BusinessException(
                    "La clase de activo está inactiva. Actívela antes de registrar o modificar activos con esta subclase.",
                    HttpStatus.BAD_REQUEST,
                    ActivosErrorCodes.CLASE_INACTIVA
            );
        }

        log.debug("Sub-clase validada exitosamente: {} - {}", subClase.getCodigo(), subClase.getNombre());
    }

    private void validarUbicacionExistente(Long afUbicacionId) {
        log.debug("Validando existencia de ubicación con id: {}", afUbicacionId);
        AfUbicacion ubicacion = ubicacionRepository.findById(afUbicacionId)
                .orElseThrow(() -> {
                    log.warn("Ubicación no encontrada con id: {}", afUbicacionId);
                    return new BusinessException(
                            "La ubicación de activo con ID " + afUbicacionId + " no existe en el sistema",
                            HttpStatus.NOT_FOUND,
                            ActivosErrorCodes.UBICACION_NO_ENCONTRADA
                    );
                });
        
        if (!ActivosFlagEstado.ACTIVO.equals(ubicacion.getFlagEstado())) {
            log.warn("Ubicación inactiva con id: {}", afUbicacionId);
            throw new BusinessException(
                    "La ubicación de activo '" + ubicacion.getNombre() + "' está inactiva. Debe activarla antes de usarla",
                    HttpStatus.BAD_REQUEST,
                    ActivosErrorCodes.UBICACION_INACTIVA
            );
        }
        
        log.debug("Ubicación validada exitosamente: {} - {}", ubicacion.getCodigo(), ubicacion.getNombre());
    }

    private void validarProveedorExistente(Long proveedorId) {
        try {
            log.debug("Validando existencia de proveedor con id: {}", proveedorId);
            ApiResponse<EntidadContribuyenteResponse> response = coreMaestrosClient.obtenerEntidadPorId(proveedorId);
            
            if (response == null || response.getData() == null) {
                log.warn("Proveedor no encontrado con id: {}", proveedorId);
                throw new BusinessException(
                    "El proveedor con ID " + proveedorId + " no existe en el sistema",
                    HttpStatus.NOT_FOUND,
                    ActivosErrorCodes.PROVEEDOR_NO_ENCONTRADO
                );
            }
            
            EntidadContribuyenteResponse proveedor = response.getData();
            if (!"1".equals(proveedor.getFlagEstado())) {
                log.warn("Proveedor inactivo con id: {}", proveedorId);
                throw new BusinessException(
                    "El proveedor '" + proveedor.getRazonSocial() + "' está inactivo. Debe activarlo antes de usarlo",
                    HttpStatus.BAD_REQUEST,
                    ActivosErrorCodes.PROVEEDOR_INACTIVO
                );
            }
            
            log.debug("Proveedor validado exitosamente: {} - {}", 
                    proveedor.getNumeroDocumento(), proveedor.getRazonSocial());
            
        } catch (FeignException.NotFound e) {
            log.warn("Proveedor no encontrado con id: {} - Error: {}", proveedorId, e.getMessage());
            throw new BusinessException(
                "El proveedor con ID " + proveedorId + " no existe en el sistema",
                HttpStatus.NOT_FOUND,
                ActivosErrorCodes.PROVEEDOR_NO_ENCONTRADO
            );
        } catch (FeignException e) {
            log.error("Error al comunicarse con ms-core-maestros para validar proveedor {}: {}", 
                    proveedorId, e.getMessage());
            throw new BusinessException(
                "Error al validar el proveedor. Por favor, intente nuevamente",
                HttpStatus.SERVICE_UNAVAILABLE,
                "ACT-999"
            );
        }
    }

    private void validarValorResidual(BigDecimal valorAdquisicion, BigDecimal valorResidual) {
        if (valorResidual.compareTo(valorAdquisicion) >= 0) {
            log.warn("Valor residual {} es mayor o igual al valor de adquisición {}", 
                    valorResidual, valorAdquisicion);
            throw new BusinessException(
                    "El valor residual debe ser menor al valor de adquisición",
                    HttpStatus.BAD_REQUEST,
                    ActivosErrorCodes.VALOR_RESIDUAL_INVALIDO
            );
        }
    }
}
