package com.sigre.almacen.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.almacen.entity.AlmacenTipo;
import com.sigre.almacen.repository.AlmacenTipoRepository;
import com.sigre.almacen.service.AlmacenTipoService;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AlmacenTipoServiceImpl implements AlmacenTipoService {

    private final AlmacenTipoRepository repository;

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "almacen_tipo", "operation", "findAll"})
    public Page<AlmacenTipo> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "almacen_tipo", "operation", "findById"})
    public AlmacenTipo findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("AlmacenTipo", id));
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "almacen_tipo", "operation", "create"})
    public AlmacenTipo create(AlmacenTipo entity) {
        validateUnicoCodigo(entity.getCodigo(), null);
        if (entity.getFlagEstado() == null) {
            entity.setFlagEstado("1");
        }
        return repository.save(entity);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "almacen_tipo", "operation", "update"})
    public AlmacenTipo update(Long id, AlmacenTipo entity) {
        AlmacenTipo existing = findById(id);
        validateUnicoCodigo(entity.getCodigo(), id);
        existing.setCodigo(entity.getCodigo());
        existing.setNombre(entity.getNombre());
        return repository.save(existing);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "almacen_tipo", "operation", "activate"})
    public AlmacenTipo activate(Long id) {
        AlmacenTipo e = findById(id);
        e.setFlagEstado("1");
        return repository.save(e);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "almacen_tipo", "operation", "deactivate"})
    public AlmacenTipo deactivate(Long id) {
        AlmacenTipo e = findById(id);
        e.setFlagEstado("0");
        return repository.save(e);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "almacen_tipo", "operation", "delete"})
    public void delete(Long id) {
        if (!repository.existsById(id)) {
            throw new ResourceNotFoundException("AlmacenTipo", id);
        }
        repository.deleteById(id);
    }

    private void validateUnicoCodigo(String codigo, Long excludeId) {
        boolean duplicado = excludeId == null
                ? repository.existsByCodigoIgnoreCase(codigo)
                : repository.existsByCodigoIgnoreCaseAndIdNot(codigo, excludeId);
        if (duplicado) {
            throw new BusinessException(
                    "Ya existe un tipo de almacén con código: " + codigo,
                    HttpStatus.CONFLICT,
                    "ALMACEN_TIPO_DUPLICADO");
        }
    }
}
