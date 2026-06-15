package com.sigre.comercializacion.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.security.TenantContext;
import com.sigre.comercializacion.dto.request.PuntoVentaRequest;
import com.sigre.comercializacion.dto.response.PuntoVentaResponse;
import com.sigre.comercializacion.entity.PuntoVenta;
import com.sigre.comercializacion.mapper.PuntoVentaMapper;
import com.sigre.comercializacion.repository.PuntoVentaRepository;
import com.sigre.comercializacion.service.PuntoVentaService;
import com.sigre.comercializacion.service.VentasErrorCodes;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class PuntoVentaServiceImpl implements PuntoVentaService {

    private final PuntoVentaRepository repository;
    private final PuntoVentaMapper mapper;

    @Timed(value = "app.db.query", extraTags = {"table", "punto_venta", "operation", "findAll"})
    @Override
    public Page<PuntoVenta> findAll(Pageable pageable) {
        log.info("Listando puntos de venta - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<PuntoVenta> page = repository.findAll(pageable);
        log.info("Puntos de venta encontrados: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "punto_venta", "operation", "findAllWithFilters"})
    @Override
    public Page<PuntoVenta> findAllWithFilters(Long sucursalId, String codigo, String nombre, String flagEstado, Pageable pageable) {
        log.info("Listando puntos de venta con filtros - sucursalId: {}, codigo: {}, nombre: {}, flagEstado: {}",
                sucursalId, codigo, nombre, flagEstado);
        Page<PuntoVenta> page = repository.findAllWithFilters(sucursalId, codigo, nombre, flagEstado, pageable);
        log.info("Puntos de venta encontrados con filtros: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "punto_venta", "operation", "findById"})
    @Override
    public PuntoVenta findById(Long id) {
        log.info("Buscando punto de venta con id: {}", id);
        return repository.findByIdWithRelations(id)
                .orElseThrow(() -> {
                    log.warn("Punto de venta no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Punto de venta", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "punto_venta", "operation", "create"})
    @Override
    @Transactional
    public PuntoVenta create(PuntoVenta entity) {
        log.info("Creando punto de venta con codigo: {} en sucursal: {}", entity.getCodigo(), entity.getSucursalId());
        
        // Normalizar código a mayúsculas
        entity.setCodigo(normalizarCodigo(entity.getCodigo()));
        
        validateUniqueCodigo(entity.getSucursalId(), entity.getCodigo(), null);
        validateUniqueSeries(entity.getSucursalId(), entity.getSerieBoleta(), entity.getSerieFactura(), null);
        validateAlmacenFk(entity.getAlmacenId(), entity.getSucursalId());
        
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFlagEstado("1");
        
        PuntoVenta saved = repository.save(entity);
        log.info("Punto de venta creado exitosamente con id: {}", saved.getId());

        // Recargar con relaciones para el response
        return repository.findByIdWithRelations(saved.getId())
                .orElse(saved);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "punto_venta", "operation", "update"})
    @Override
    @Transactional
    public PuntoVenta update(Long id, PuntoVenta entity) {
        log.info("Actualizando punto de venta con id: {}", id);
        PuntoVenta existing = repository.findByIdWithRelations(id)
                .orElseThrow(() -> {
                    log.warn("Punto de venta no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Punto de venta", id);
                });
        
        // Normalizar código a mayúsculas
        entity.setCodigo(normalizarCodigo(entity.getCodigo()));
        
        validateUniqueCodigo(entity.getSucursalId(), entity.getCodigo(), id);
        validateUniqueSeries(entity.getSucursalId(), entity.getSerieBoleta(), entity.getSerieFactura(), id);
        validateAlmacenFk(entity.getAlmacenId(), entity.getSucursalId());
        
        existing.setSucursalId(entity.getSucursalId());
        existing.setAlmacenId(entity.getAlmacenId());
        existing.setCodigo(entity.getCodigo());
        existing.setNombre(entity.getNombre());
        existing.setSerieBoleta(entity.getSerieBoleta());
        existing.setSerieFactura(entity.getSerieFactura());
        existing.setTipoImpresora(entity.getTipoImpresora());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        PuntoVenta updated = repository.save(existing);
        log.info("Punto de venta actualizado exitosamente con id: {}", id);

        // Recargar con relaciones para el response (en caso de cambio de sucursal/almacen)
        return repository.findByIdWithRelations(updated.getId())
                .orElse(updated);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "punto_venta", "operation", "activate"})
    @Override
    @Transactional
    public PuntoVenta activate(Long id) {
        log.info("Activando punto de venta con id: {}", id);
        PuntoVenta existing = repository.findByIdWithRelations(id)
                .orElseThrow(() -> {
                    log.warn("Punto de venta no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Punto de venta", id);
                });
        
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        PuntoVenta activated = repository.save(existing);
        log.info("Punto de venta activado exitosamente con id: {}", id);
        return activated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "punto_venta", "operation", "deactivate"})
    @Override
    @Transactional
    public PuntoVenta deactivate(Long id) {
        log.info("Desactivando punto de venta con id: {}", id);
        PuntoVenta existing = repository.findByIdWithRelations(id)
                .orElseThrow(() -> {
                    log.warn("Punto de venta no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Punto de venta", id);
                });
        
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        PuntoVenta deactivated = repository.save(existing);
        log.info("Punto de venta desactivado exitosamente con id: {}", id);
        return deactivated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "punto_venta", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando punto de venta con id: {}", id);
        PuntoVenta existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Punto de venta no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Punto de venta", id);
                });
        
        repository.delete(existing);
        log.info("Punto de venta eliminado exitosamente con id: {}", id);
    }

    @Override
    public List<PuntoVenta> findBySucursalId(Long sucursalId) {
        log.info("Buscando puntos de venta activos para sucursal: {}", sucursalId);
        return repository.findBySucursalIdAndActivo(sucursalId);
    }

    private void validateUniqueCodigo(Long sucursalId, String codigo, Long excludeId) {
        boolean exists = (excludeId == null)
                ? repository.existsBySucursalIdAndCodigoAndFlagEstado(sucursalId, codigo, "1")
                : repository.existsBySucursalIdAndCodigoAndFlagEstadoAndIdNot(sucursalId, codigo, "1", excludeId);
        
        if (exists) {
            log.warn("Intento de duplicar codigo de punto de venta: {} en sucursal: {}", codigo, sucursalId);
            throw new BusinessException(
                    "Ya existe un punto de venta con código: " + codigo + " en esta sucursal",
                    org.springframework.http.HttpStatus.CONFLICT, 
                    VentasErrorCodes.PUNTO_VENTA_CODIGO_DUPLICADO);
        }
    }

    private void validateUniqueSeries(Long sucursalId, String serieBoleta, String serieFactura, Long excludeId) {
        // Validar serie de boleta si no está vacía
        if (serieBoleta != null && !serieBoleta.trim().isEmpty()) {
            boolean existsBoleta = (excludeId == null)
                    ? repository.existsBySucursalIdAndSerieBoletaAndFlagEstado(sucursalId, serieBoleta, "1")
                    : repository.existsBySucursalIdAndSerieBoletaAndFlagEstadoAndIdNot(sucursalId, serieBoleta, "1", excludeId);
            
            if (existsBoleta) {
                log.warn("Intento de duplicar serie de boleta: {} en sucursal: {}", serieBoleta, sucursalId);
                throw new BusinessException(
                        "Ya existe un punto de venta con la serie de boleta: " + serieBoleta + " en esta sucursal",
                        org.springframework.http.HttpStatus.CONFLICT,
                        VentasErrorCodes.PUNTO_VENTA_SERIE_BOLETA_DUPLICADA);
            }
        }

        // Validar serie de factura si no está vacía
        if (serieFactura != null && !serieFactura.trim().isEmpty()) {
            boolean existsFactura = (excludeId == null)
                    ? repository.existsBySucursalIdAndSerieFacturaAndFlagEstado(sucursalId, serieFactura, "1")
                    : repository.existsBySucursalIdAndSerieFacturaAndFlagEstadoAndIdNot(sucursalId, serieFactura, "1", excludeId);
            
            if (existsFactura) {
                log.warn("Intento de duplicar serie de factura: {} en sucursal: {}", serieFactura, sucursalId);
                throw new BusinessException(
                        "Ya existe un punto de venta con la serie de factura: " + serieFactura + " en esta sucursal",
                        org.springframework.http.HttpStatus.CONFLICT,
                        VentasErrorCodes.PUNTO_VENTA_SERIE_FACTURA_DUPLICADA);
            }
        }
    }

    private String normalizarCodigo(String codigo) {
        return codigo != null ? codigo.toUpperCase().trim() : null;
    }

    private void validateAlmacenFk(Long almacenId, Long sucursalId) {
        if (almacenId == null) {
            return;
        }

        // Validar que almacén existe y está activo
        if (!repository.existsAlmacenActivo(almacenId)) {
            log.warn("Almacén no existe o está inactivo: {}", almacenId);
            throw new BusinessException(
                    "El almacén indicado no existe o no está activo",
                    org.springframework.http.HttpStatus.UNPROCESSABLE_ENTITY,
                    VentasErrorCodes.PUNTO_VENTA_ALMACEN_INVALIDO);
        }

        // Validar que almacén pertenece a la sucursal
        if (!repository.existsAlmacenByIdAndSucursalId(almacenId, sucursalId)) {
            log.warn("Almacén {} no pertenece a la sucursal {}", almacenId, sucursalId);
            throw new BusinessException(
                    "El almacén indicado no pertenece a la sucursal del punto de venta",
                    org.springframework.http.HttpStatus.UNPROCESSABLE_ENTITY,
                    VentasErrorCodes.PUNTO_VENTA_ALMACEN_SUCURSAL_INVALIDA);
        }
    }
}
