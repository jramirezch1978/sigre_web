package pe.restaurant.core.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.core.entity.CalendarioFeriado;
import pe.restaurant.core.repository.CalendarioFeriadoRepository;
import pe.restaurant.core.service.CalendarioFeriadoService;

import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CalendarioFeriadoServiceImpl implements CalendarioFeriadoService {

    private final CalendarioFeriadoRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "calendario_feriado", "operation", "findAll"})
    @Override
    public Page<CalendarioFeriado> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "calendario_feriado", "operation", "findById"})
    @Override
    public CalendarioFeriado findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("CalendarioFeriado", id));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "calendario_feriado", "operation", "create"})
    @Override @Transactional
    public CalendarioFeriado create(CalendarioFeriado entity) {
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "calendario_feriado", "operation", "update"})
    @Override @Transactional
    public CalendarioFeriado update(Long id, CalendarioFeriado entity) {
        findById(id);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "calendario_feriado", "operation", "delete"})
    @Override @Transactional
    public void delete(Long id) {
        findById(id);
        repository.deleteById(id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "calendario_feriado", "operation", "activate"})
    @Override @Transactional
    public CalendarioFeriado activate(Long id) {
        CalendarioFeriado existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "calendario_feriado", "operation", "deactivate"})
    @Override @Transactional
    public CalendarioFeriado deactivate(Long id) {
        CalendarioFeriado existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }
}
