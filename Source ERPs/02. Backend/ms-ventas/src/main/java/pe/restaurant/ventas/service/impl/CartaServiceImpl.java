package pe.restaurant.ventas.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.ventas.dto.request.CartaRequest;
import pe.restaurant.ventas.dto.response.CartaResponse;
import pe.restaurant.ventas.entity.Carta;
import pe.restaurant.ventas.entity.CartaDet;
import pe.restaurant.ventas.mapper.CartaMapper;

import java.math.BigDecimal;
import pe.restaurant.ventas.repository.CartaRepository;
import pe.restaurant.ventas.repository.CartaDetRepository;
import pe.restaurant.ventas.repository.ArticuloRepository;
import pe.restaurant.ventas.service.CartaService;
import pe.restaurant.ventas.service.VentasErrorCodes;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CartaServiceImpl implements CartaService {

    private final CartaRepository repository;
    private final CartaDetRepository detalleRepository;
    private final CartaMapper mapper;
    private final ArticuloRepository articuloRepository;

    @Timed(value = "app.db.query", extraTags = {"table", "carta", "operation", "findAll"})
    @Override
    public Page<Carta> findAll(Pageable pageable) {
        log.info("Listando cartas - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<Carta> page = repository.findAll(pageable);
        log.info("Cartas encontradas: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "carta", "operation", "findById"})
    @Override
    public Carta findById(Long id) {
        log.info("Buscando carta con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Carta no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Carta", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "carta", "operation", "create"})
    @Override
    @Transactional
    public Carta create(Carta entity) {
        log.info("Creando carta: {} en sucursal: {}", entity.getNombre(), entity.getSucursalId());
        validateUniqueNombre(entity.getNombre(), entity.getSucursalId(), null);
        
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFlagEstado("1");
        
        // Configurar detalles
        if (entity.getDetalles() != null) {
            entity.getDetalles().forEach(det -> {
                // Validar que el artículo exista y esté activo
                if (!articuloRepository.existsByIdAndFlagEstado(det.getArticulo().getId(), "1")) {
                    log.warn("Artículo no encontrado o inactivo: {}", det.getArticulo().getId());
                    throw new BusinessException(
                            "El artículo con ID " + det.getArticulo().getId() + " no existe o no está activo",
                            org.springframework.http.HttpStatus.BAD_REQUEST,
                            VentasErrorCodes.ARTICULO_NO_ENCONTRADO);
                }
                
                det.setCarta(entity);  // Establecer relación bidireccional
                det.setCreatedBy(TenantContext.getUsuarioId());
                det.setFlagEstado("1");
            });
        }
        
        Carta saved = repository.save(entity);
        log.info("Carta creada exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "carta", "operation", "update"})
    @Override
    @Transactional
    public Carta update(Long id, Carta entity) {
        log.info("Actualizando carta con id: {}", id);
        Carta existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Carta no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Carta", id);
                });
        
        validateUniqueNombre(entity.getNombre(), entity.getSucursalId(), id);
        
        existing.setSucursalId(entity.getSucursalId());
        existing.setNombre(entity.getNombre());
        existing.setDescripcion(entity.getDescripcion());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        // Actualizar detalles si se proporcionan
        if (entity.getDetalles() != null && !entity.getDetalles().isEmpty()) {
            log.info("Actualizando {} detalles para la carta {}", entity.getDetalles().size(), id);
            
            // Eliminar detalles existentes de la base de datos
            if (existing.getDetalles() != null && !existing.getDetalles().isEmpty()) {
                log.info("Eliminando {} detalles existentes", existing.getDetalles().size());
                existing.getDetalles().clear();
            }
            
            // Validar y agregar nuevos detalles
            entity.getDetalles().forEach(det -> {
                // Validar que el artículo exista y esté activo
                if (!articuloRepository.existsByIdAndFlagEstado(det.getArticulo().getId(), "1")) {
                    log.warn("Artículo no encontrado o inactivo: {}", det.getArticulo().getId());
                    throw new BusinessException(
                            "El artículo con ID " + det.getArticulo().getId() + " no existe o no está activo",
                            org.springframework.http.HttpStatus.BAD_REQUEST,
                            VentasErrorCodes.ARTICULO_NO_ENCONTRADO);
                }
                
                det.setCarta(existing);
                det.setCreatedBy(TenantContext.getUsuarioId());
                det.setFlagEstado("1");
                log.debug("Agregando detalle: articuloId={}, precio={}", det.getArticulo().getId(), det.getPrecio());
            });
            
            existing.setDetalles(entity.getDetalles());
        } else {
            log.info("No se proporcionaron detalles para actualizar");
        }
        
        Carta updated = repository.save(existing);
        log.info("Carta actualizada exitosamente con id: {}, detalles: {}", id, 
                updated.getDetalles() != null ? updated.getDetalles().size() : 0);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "carta", "operation", "activate"})
    @Override
    @Transactional
    public Carta activate(Long id) {
        log.info("Activando carta con id: {}", id);
        Carta existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Carta no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Carta", id);
                });
        
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        Carta activated = repository.save(existing);
        log.info("Carta activada exitosamente con id: {}", id);
        return activated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "carta", "operation", "deactivate"})
    @Override
    @Transactional
    public Carta deactivate(Long id) {
        log.info("Desactivando carta con id: {}", id);
        Carta existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Carta no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Carta", id);
                });
        
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        Carta deactivated = repository.save(existing);
        log.info("Carta desactivada exitosamente con id: {}", id);
        return deactivated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "carta", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando carta con id: {}", id);
        Carta existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Carta no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Carta", id);
                });
        
        repository.delete(existing);
        log.info("Carta eliminada exitosamente con id: {}", id);
    }

    @Override
    public List<Carta> findBySucursalId(Long sucursalId) {
        log.info("Buscando cartas activas para sucursal: {}", sucursalId);
        return repository.findBySucursalIdAndActivo(sucursalId);
    }

    private CartaResponse mapWithDetalles(Carta entity) {
        CartaResponse response = mapper.toResponse(entity);
        if (entity.getDetalles() != null) {
            response.setDetalles(mapper.toDetResponseList(entity.getDetalles()));
        }
        return response;
    }

    private void validateUniqueNombre(String nombre, Long sucursalId, Long excludeId) {
        boolean exists = (excludeId == null)
                ? repository.existsByNombreAndSucursalIdAndFlagEstado(nombre, sucursalId, "1")
                : repository.existsByNombreAndSucursalIdAndFlagEstadoAndIdNot(nombre, sucursalId, "1", excludeId);

        if (exists) {
            log.warn("Intento de duplicar nombre de carta: {} en sucursal: {}", nombre, sucursalId);
            throw new BusinessException(
                    "Ya existe una carta con nombre: " + nombre + " en esta sucursal",
                    org.springframework.http.HttpStatus.CONFLICT,
                    VentasErrorCodes.CARTA_SUCURSAL_INVALIDA);
        }
    }

    // ==================== MÉTODOS CON FILTROS (CONTRATO) ====================

    @Timed(value = "app.db.query", extraTags = {"table", "carta", "operation", "findAllWithFilters"})
    @Override
    public Page<Carta> findAllWithFilters(Long sucursalId, String nombre, String flagEstado, Pageable pageable) {
        log.info("Listando cartas con filtros - sucursalId: {}, nombre: {}, flagEstado: {}",
                sucursalId, nombre, flagEstado);
        
        // Normalizar parámetros para evitar problemas con NULL
        String nombreNormalizado = (nombre == null || nombre.trim().isEmpty()) ? null : nombre.trim();
        String flagEstadoNormalizado = (flagEstado == null || flagEstado.trim().isEmpty()) ? null : flagEstado.trim();
        
        Page<Carta> page = repository.findAllWithFilters(sucursalId, nombreNormalizado, flagEstadoNormalizado, pageable);
        log.info("Cartas encontradas con filtros: {}", page.getTotalElements());
        return page;
    }

    // ==================== MÉTODOS DE GESTIÓN DE ÍTEMS (CONTRATO) ====================

    @Timed(value = "app.db.query", extraTags = {"table", "carta_det", "operation", "findItemsByCartaId"})
    @Override
    public List<CartaDet> findItemsByCartaId(Long cartaId) {
        log.info("Buscando ítems de carta con id: {}", cartaId);
        // Verificar que la carta existe
        findById(cartaId);
        return detalleRepository.findByCartaIdAndActivo(cartaId);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "carta_det", "operation", "addItem"})
    @Override
    @Transactional
    public CartaDet addItem(Long cartaId, CartaDet item) {
        log.info("Agregando ítem a carta {}: articuloId={}, precio={}",
                cartaId, item.getArticulo().getId(), item.getPrecio());

        Carta carta = findById(cartaId);

        // Validar que el artículo exista y esté activo
        if (!articuloRepository.existsByIdAndFlagEstado(item.getArticulo().getId(), "1")) {
            throw new BusinessException(
                    "El artículo no existe o no está activo",
                    org.springframework.http.HttpStatus.BAD_REQUEST,
                    VentasErrorCodes.ARTICULO_NO_ENCONTRADO);
        }

        // Validar que el artículo no esté ya en la carta (según contrato)
        if (detalleRepository.existsByCartaIdAndArticuloIdAndActivo(cartaId, item.getArticulo().getId())) {
            throw new BusinessException(
                    "El artículo ya existe en esta carta",
                    org.springframework.http.HttpStatus.CONFLICT,
                    VentasErrorCodes.ARTICULO_DUPLICADO_CARTA);
        }

        // Validar precio >= 0 (según contrato)
        if (item.getPrecio() != null && item.getPrecio().compareTo(java.math.BigDecimal.ZERO) < 0) {
            throw new BusinessException(
                    "El precio no puede ser negativo",
                    org.springframework.http.HttpStatus.BAD_REQUEST,
                    VentasErrorCodes.PRECIO_INVALIDO);
        }

        item.setCarta(carta);
        item.setCreatedBy(TenantContext.getUsuarioId());
        item.setFlagEstado("1");

        CartaDet saved = detalleRepository.save(item);
        log.info("Ítem agregado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "carta_det", "operation", "updateItem"})
    @Override
    @Transactional
    public CartaDet updateItem(Long cartaId, Long itemId, CartaDet item) {
        log.info("Actualizando ítem {} de carta {}: precio={}, orden={}",
                itemId, cartaId, item.getPrecio(), item.getOrden());

        // Verificar que la carta existe
        findById(cartaId);

        CartaDet existing = detalleRepository.findById(itemId)
                .orElseThrow(() -> new ResourceNotFoundException("Ítem de carta", itemId));

        // Validar que el ítem pertenezca a la carta
        if (!existing.getCarta().getId().equals(cartaId)) {
            throw new BusinessException(
                    "El ítem no pertenece a esta carta",
                    org.springframework.http.HttpStatus.BAD_REQUEST,
                    VentasErrorCodes.ITEM_CARTA_INVALIDO);
        }

        // Validar precio >= 0 (según contrato)
        if (item.getPrecio() != null && item.getPrecio().compareTo(java.math.BigDecimal.ZERO) < 0) {
            throw new BusinessException(
                    "El precio no puede ser negativo",
                    org.springframework.http.HttpStatus.BAD_REQUEST,
                    VentasErrorCodes.PRECIO_INVALIDO);
        }

        existing.setPrecio(item.getPrecio());
        existing.setOrden(item.getOrden());
        existing.setUpdatedBy(TenantContext.getUsuarioId());

        CartaDet updated = detalleRepository.save(existing);
        log.info("Ítem actualizado exitosamente");
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "carta_det", "operation", "deleteItem"})
    @Override
    @Transactional
    public void deleteItem(Long cartaId, Long itemId) {
        log.info("Eliminando ítem {} de carta {}", itemId, cartaId);

        // Verificar que la carta existe
        findById(cartaId);

        CartaDet existing = detalleRepository.findById(itemId)
                .orElseThrow(() -> new ResourceNotFoundException("Ítem de carta", itemId));

        // Validar que el ítem pertenezca a la carta
        if (!existing.getCarta().getId().equals(cartaId)) {
            throw new BusinessException(
                    "El ítem no pertenece a esta carta",
                    org.springframework.http.HttpStatus.BAD_REQUEST,
                    VentasErrorCodes.ITEM_CARTA_INVALIDO);
        }

        // Baja lógica según contrato
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        detalleRepository.save(existing);

        log.info("Ítem eliminado exitosamente");
    }

    @Override
    @Transactional
    public CartaDet updateItemFields(Long cartaId, Long itemId, BigDecimal precio, Integer orden) {
        log.info("Actualizando campos de ítem: cartaId={}, itemId={}, precio={}, orden={}", 
                cartaId, itemId, precio, orden);

        CartaDet existing = detalleRepository.findById(itemId)
                .orElseThrow(() -> new BusinessException(
                        "Ítem no encontrado",
                        org.springframework.http.HttpStatus.NOT_FOUND,
                        VentasErrorCodes.ITEM_NO_ENCONTRADO));

        // Validar que el ítem pertenezca a la carta
        if (!existing.getCarta().getId().equals(cartaId)) {
            throw new BusinessException(
                    "El ítem no pertenece a esta carta",
                    org.springframework.http.HttpStatus.BAD_REQUEST,
                    VentasErrorCodes.ITEM_CARTA_INVALIDO);
        }

        // Validar precio si se proporciona
        if (precio != null && precio.compareTo(BigDecimal.ZERO) < 0) {
            throw new BusinessException(
                    "El precio debe ser mayor o igual a cero",
                    org.springframework.http.HttpStatus.BAD_REQUEST,
                    VentasErrorCodes.PRECIO_INVALIDO);
        }

        // Actualizar solo los campos permitidos según contrato
        if (precio != null) {
            existing.setPrecio(precio);
        }
        if (orden != null) {
            existing.setOrden(orden);
        }

        // Auditoría
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        CartaDet updated = detalleRepository.save(existing);

        log.info("Ítem actualizado exitosamente");
        return updated;
    }
}
