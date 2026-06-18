package pe.restaurant.ventas.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.ventas.dto.request.MesaRequest;
import pe.restaurant.ventas.dto.response.MesaResponse;
import pe.restaurant.ventas.entity.Mesa;
import pe.restaurant.ventas.mapper.MesaMapper;
import pe.restaurant.ventas.repository.MesaRepository;
import pe.restaurant.ventas.service.MesaService;
import pe.restaurant.ventas.service.VentasErrorCodes;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class MesaServiceImpl implements MesaService {

    private final MesaRepository repository;
    private final MesaMapper mapper;

    @Timed(value = "app.db.query", extraTags = {"table", "mesa", "operation", "findAll"})
    @Override
    public Page<Mesa> findAll(Pageable pageable) {
        log.info("Listando mesas - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<Mesa> page = repository.findAll(pageable);
        log.info("Mesas encontradas: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "mesa", "operation", "findAllWithFilters"})
    @Override
    public Page<Mesa> findAllWithFilters(Long zonaId, String numero, String flagEstado, Pageable pageable) {
        log.info("Listando mesas con filtros - zonaId: {}, numero: {}, flagEstado: {}",
                zonaId, numero, flagEstado);
        Page<Mesa> page = repository.findAllWithFilters(zonaId, numero, flagEstado, pageable);
        log.info("Mesas encontradas con filtros: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "mesa", "operation", "findById"})
    @Override
    public Mesa findById(Long id) {
        log.info("Buscando mesa con id: {}", id);
        return repository.findByIdWithRelations(id)
                .orElseThrow(() -> {
                    log.warn("Mesa no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Mesa", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "mesa", "operation", "create"})
    @Override
    @Transactional
    public Mesa create(Mesa entity) {
        log.info("Creando mesa con numero: {} en zona: {}", entity.getNumero(), entity.getZona());
        validateUniqueNumero(entity.getNumero(), null);
        
        // Validar que la zona pertenece a la sucursal del contexto
        validateZonaFk(entity.getZona());

        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFlagEstado("1");
        
        Mesa saved = repository.save(entity);
        log.info("Mesa creada exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "mesa", "operation", "update"})
    @Override
    @Transactional
    public Mesa update(Long id, Mesa entity) {
        log.info("Actualizando mesa con id: {}", id);
        Mesa existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Mesa no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Mesa", id);
                });
        
        validateUniqueNumero(entity.getNumero(), id);

        // Validar que la zona pertenece a la sucursal del contexto
        validateZonaFk(entity.getZona());

        existing.setZona(entity.getZona());
        existing.setNumero(entity.getNumero());
        existing.setCapacidad(entity.getCapacidad());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        Mesa updated = repository.save(existing);
        log.info("Mesa actualizada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "mesa", "operation", "activate"})
    @Override
    @Transactional
    public Mesa activate(Long id) {
        log.info("Activando mesa con id: {}", id);
        Mesa existing = repository.findByIdWithRelations(id)
                .orElseThrow(() -> {
                    log.warn("Mesa no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Mesa", id);
                });
        
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        Mesa activated = repository.save(existing);
        log.info("Mesa activada exitosamente con id: {}", id);
        return activated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "mesa", "operation", "deactivate"})
    @Override
    @Transactional
    public Mesa deactivate(Long id) {
        log.info("Desactivando mesa con id: {}", id);
        Mesa existing = repository.findByIdWithRelations(id)
                .orElseThrow(() -> {
                    log.warn("Mesa no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Mesa", id);
                });

        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());

        Mesa deactivated = repository.save(existing);
        log.info("Mesa desactivada exitosamente con id: {}", id);
        return deactivated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "mesa", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando mesa con id: {}", id);
        Mesa existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Mesa no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Mesa", id);
                });

        repository.delete(existing);
        log.info("Mesa eliminada exitosamente con id: {}", id);
    }

    @Override
    public List<Mesa> findByZonaId(Long zonaId) {
        log.info("Buscando mesas activas para zona: {}", zonaId);
        return repository.findByZonaIdAndActivo(zonaId);
    }

    @Override
    public List<Mesa> findBySucursalId(Long sucursalId) {
        log.info("Buscando mesas activas para sucursal: {}", sucursalId);
        return repository.findBySucursalIdAndActivo(sucursalId);
    }

    private void validateUniqueNumero(String numero, Long excludeId) {
        boolean exists = (excludeId == null)
                ? repository.existsByNumeroAndFlagEstado(numero, "1")
                : repository.existsByNumeroAndFlagEstadoAndIdNot(numero, "1", excludeId);

        if (exists) {
            log.warn("Intento de duplicar numero de mesa: {}", numero);
            throw new BusinessException(
                    "Ya existe una mesa con número: " + numero,
                    org.springframework.http.HttpStatus.CONFLICT,
                    VentasErrorCodes.MESA_NUMERO_DUPLICADO);
        }
    }

    private void validateZonaFk(Mesa.Zona zona) {
        if (zona == null || zona.getId() == null) {
            log.warn("Zona no especificada para la mesa");
            throw new BusinessException(
                    "La zona es obligatoria para la mesa",
                    org.springframework.http.HttpStatus.BAD_REQUEST,
                    VentasErrorCodes.MESA_ZONA_INVALIDA);
        }

        Long zonaId = zona.getId();
        Long sucursalId = TenantContext.getSucursalId();

        // Validar que zona existe y pertenece a la sucursal del contexto
        if (!repository.existsZonaByIdAndSucursalId(zonaId, sucursalId)) {
            log.warn("Zona {} no existe o no pertenece a la sucursal {}", zonaId, sucursalId);
            throw new BusinessException(
                    "La zona indicada no existe o no pertenece a la sucursal del contexto",
                    org.springframework.http.HttpStatus.UNPROCESSABLE_ENTITY,
                    VentasErrorCodes.MESA_ZONA_SUCURSAL_INVALIDA);
        }
    }
}
