package pe.restaurant.core.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.core.entity.Numerador;
import java.time.Instant;
import pe.restaurant.core.repository.NumeradorRepository;
import pe.restaurant.core.service.NumeradorService;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class NumeradorServiceImpl implements NumeradorService {

    private final NumeradorRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "numerador", "operation", "findAll"})
    @Override
    public Page<Numerador> findAll(Pageable pageable) {
        log.info("Listando numeradores - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<Numerador> page = repository.findAll(pageable);
        log.info("Numeradores encontrados: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "numerador", "operation", "findById"})
    @Override
    public Numerador findById(Long id) {
        log.info("Buscando numerador con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Numerador no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Numerador", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "numerador", "operation", "create"})
    @Override @Transactional
    public Numerador create(Numerador entity) {
        log.info("Creando numerador con codigo: {}", entity.getCodigo());
        validateUniqueCodigo(entity.getCodigo(), null);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        Numerador saved = repository.save(entity);
        log.info("Numerador creado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "numerador", "operation", "update"})
    @Override @Transactional
    public Numerador update(Long id, Numerador entity) {
        log.info("Actualizando numerador con id: {}", id);
        Numerador existing = findById(id);
        validateUniqueCodigo(entity.getCodigo(), id);
        existing.setCodigo(entity.getCodigo());
        existing.setNombre(entity.getNombre());
        existing.setSerie(entity.getSerie());
        existing.setUltimoNumero(entity.getUltimoNumero());
        existing.setLongitud(entity.getLongitud());
        existing.setFlagEstado(entity.getFlagEstado());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        Numerador updated = repository.save(existing);
        log.info("Numerador actualizado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "numerador", "operation", "delete"})
    @Override @Transactional
    public void delete(Long id) {
        log.info("Eliminando numerador con id: {}", id);
        findById(id);
        repository.deleteById(id);
        log.info("Numerador eliminado exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "numerador", "operation", "activate"})
    @Override @Transactional
    public Numerador activate(Long id) {
        log.info("Activando numerador con id: {}", id);
        Numerador existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "numerador", "operation", "deactivate"})
    @Override @Transactional
    public Numerador deactivate(Long id) {
        log.info("Desactivando numerador con id: {}", id);
        Numerador existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "numerador", "operation", "siguiente"})
    @Override @Transactional
    public Long siguiente(String codigoNumerador) {
        log.info("Obteniendo siguiente numero para numerador: {}", codigoNumerador);
        Numerador numerador = repository.findByCodigoForUpdate(codigoNumerador)
                .orElseThrow(() -> {
                    log.warn("Numerador no encontrado con codigo: {}", codigoNumerador);
                    return new ResourceNotFoundException("Numerador", "codigo", codigoNumerador);
                });
        if ("0".equals(numerador.getFlagEstado())) {
            log.warn("Intento de obtener siguiente numero de numerador inactivo: {}", codigoNumerador);
            throw new BusinessException("El numerador esta inactivo: " + codigoNumerador, HttpStatus.UNPROCESSABLE_ENTITY, "BUSINESS_ERROR");
        }
        long next = numerador.getUltimoNumero() + 1;
        numerador.setUltimoNumero(next);
        repository.save(numerador);
        log.info("Siguiente numero generado: {} para numerador: {}", next, codigoNumerador);
        return next;
    }

    private void validateUniqueCodigo(String codigo, Long excludeId) {
        repository.findByCodigo(codigo)
                .filter(e -> !e.getId().equals(excludeId))
                .ifPresent(e -> {
                    log.warn("Intento de duplicar codigo de numerador: {} (numerador existente id: {})", codigo, e.getId());
                    throw new BusinessException("Ya existe un numerador con codigo: " + codigo, HttpStatus.CONFLICT, "BUSINESS_ERROR");
                });
    }
}
