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
import pe.restaurant.core.entity.NumTablas;
import pe.restaurant.core.repository.NumTablasRepository;
import pe.restaurant.core.service.NumTablasService;

import java.time.Instant;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class NumTablasServiceImpl implements NumTablasService {

    private final NumTablasRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "num_tablas", "operation", "findAll"})
    @Override
    public Page<NumTablas> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "num_tablas", "operation", "findById"})
    @Override
    public NumTablas findById(NumTablas.NumTablasId id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("NumTablas", "clave", id.getNombreTabla() + "/" + id.getCodOrigen()));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "num_tablas", "operation", "create"})
    @Override @Transactional
    public NumTablas create(NumTablas entity) {
        NumTablas.NumTablasId id = new NumTablas.NumTablasId();
        id.setNombreTabla(entity.getNombreTabla());
        id.setCodOrigen(entity.getCodOrigen());
        repository.findById(id).ifPresent(e -> {
            throw new BusinessException("Ya existe num_tablas para: " + entity.getNombreTabla() + "/" + entity.getCodOrigen(), HttpStatus.CONFLICT, "BUSINESS_ERROR");
        });
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "num_tablas", "operation", "update"})
    @Override @Transactional
    public NumTablas update(NumTablas entity) {
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "num_tablas", "operation", "delete"})
    @Override @Transactional
    public void delete(NumTablas.NumTablasId id) {
        findById(id);
        repository.deleteById(id);
    }
}
