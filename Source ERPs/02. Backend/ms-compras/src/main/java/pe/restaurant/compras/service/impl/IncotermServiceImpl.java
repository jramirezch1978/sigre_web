package pe.restaurant.compras.service.impl;

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
import pe.restaurant.compras.entity.Incoterm;
import pe.restaurant.compras.repository.IncotermRepository;
import pe.restaurant.compras.service.IncotermService;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class IncotermServiceImpl implements IncotermService {

    private final IncotermRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "incoterm", "operation", "findAll"})
    @Override
    public Page<Incoterm> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "incoterm", "operation", "findById"})
    @Override
    public Incoterm findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Incoterm", id));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "incoterm", "operation", "create"})
    @Override @Transactional
    public Incoterm create(Incoterm entity) {
        validateUniqueCodigo(entity.getCodigo(), null);
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "incoterm", "operation", "update"})
    @Override @Transactional
    public Incoterm update(Long id, Incoterm entity) {
        findById(id);
        validateUniqueCodigo(entity.getCodigo(), id);
        entity.setId(id);
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "incoterm", "operation", "delete"})
    @Override @Transactional
    public void delete(Long id) {
        findById(id);
        repository.deleteById(id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "incoterm", "operation", "activate"})
    @Override @Transactional
    public Incoterm activate(Long id) {
        Incoterm existing = findById(id);
        existing.setFlagEstado("1");
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "incoterm", "operation", "deactivate"})
    @Override @Transactional
    public Incoterm deactivate(Long id) {
        Incoterm existing = findById(id);
        existing.setFlagEstado("0");
        return repository.save(existing);
    }

    private void validateUniqueCodigo(String codigo, Long excludeId) {
        repository.findByCodigo(codigo)
                .filter(e -> !e.getId().equals(excludeId))
                .ifPresent(e -> {
                    throw new BusinessException("Ya existe un incoterm con codigo: " + codigo, HttpStatus.CONFLICT, "BUSINESS_ERROR");
                });
    }
}
