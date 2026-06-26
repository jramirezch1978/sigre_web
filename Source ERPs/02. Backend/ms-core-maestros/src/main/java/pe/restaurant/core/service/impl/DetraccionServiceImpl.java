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
import pe.restaurant.core.dto.DetraccionRequest;
import pe.restaurant.core.dto.DetraccionResponse;
import pe.restaurant.core.entity.Detraccion;
import pe.restaurant.core.mapper.DetraccionMapper;
import pe.restaurant.core.repository.DetraccionRepository;
import pe.restaurant.core.service.DetraccionService;

import java.math.BigDecimal;
import pe.restaurant.common.security.TenantContext;
import java.time.Instant;
import java.util.Locale;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class DetraccionServiceImpl implements DetraccionService {
    private final DetraccionRepository repository;
    private final DetraccionMapper mapper;

    @Override
    public Page<Detraccion> list(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Override
    public DetraccionResponse getById(String bienServ) {
        return mapper.toResponse(getEntity(bienServ));
    }

    @Override
    @Transactional
    public DetraccionResponse create(DetraccionRequest request) {
        String bienServ = normalizeBienServ(request.getBienServ());
        if (repository.existsByBienServ(bienServ)) {
            throw new BusinessException("Ya existe una detraccion para bien/servicio: " + bienServ, HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }

        Detraccion entity = mapper.toEntity(request);
        entity.setBienServ(bienServ);
        applyDefaults(entity);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    @Transactional
    public DetraccionResponse update(String bienServ, DetraccionRequest request) {
        String normalized = normalizeBienServ(bienServ);
        Detraccion entity = getEntity(normalized);

        if (request.getBienServ() != null && !normalized.equals(normalizeBienServ(request.getBienServ()))) {
            throw new BusinessException("No se permite cambiar bienServ del registro", HttpStatus.BAD_REQUEST, "VALIDATION_ERROR");
        }

        mapper.updateEntity(request, entity);
        entity.setBienServ(normalized);
        applyDefaults(entity);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    @Transactional
    public void delete(String bienServ) {
        String normalized = normalizeBienServ(bienServ);
        log.info("Eliminando Detraccion con bienServ: {}", normalized);
        Detraccion entity = getEntity(normalized);
        repository.delete(entity);
        log.info("Detraccion eliminada exitosamente con bienServ: {}", normalized);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "detraccion", "operation", "activate"})
    @Override
    @Transactional
    public Detraccion activate(String bienServ) {
        String normalized = normalizeBienServ(bienServ);
        log.info("Activando Detraccion con bienServ: {}", normalized);
        Detraccion existing = getEntity(normalized);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "detraccion", "operation", "deactivate"})
    @Override
    @Transactional
    public Detraccion deactivate(String bienServ) {
        String normalized = normalizeBienServ(bienServ);
        log.info("Desactivando Detraccion con bienServ: {}", normalized);
        Detraccion existing = getEntity(normalized);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    private Detraccion getEntity(String bienServ) {
        return repository.findByBienServ(normalizeBienServ(bienServ))
                .orElseThrow(() -> new ResourceNotFoundException("Detraccion", "bienServ", bienServ));
    }

    private String normalizeBienServ(String bienServ) {
        if (bienServ == null || bienServ.trim().isEmpty()) {
            throw new BusinessException("El campo bienServ es obligatorio", HttpStatus.BAD_REQUEST, "VALIDATION_ERROR");
        }
        return bienServ.trim().toUpperCase(Locale.ROOT);
    }

    private void applyDefaults(Detraccion entity) {
        if (entity.getFlagEstado() == null || entity.getFlagEstado().isBlank()) {
            entity.setFlagEstado("1");
        }
        if (entity.getMontoMinDepre() == null) {
            entity.setMontoMinDepre(BigDecimal.ZERO);
        }
        if (entity.getTasaPdbe() == null) {
            entity.setTasaPdbe(BigDecimal.ZERO);
        }
    }
}
