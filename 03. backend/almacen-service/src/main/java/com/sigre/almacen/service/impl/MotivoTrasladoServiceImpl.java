package com.sigre.almacen.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.almacen.entity.MotivoTraslado;
import com.sigre.almacen.repository.MotivoTrasladoRepository;
import com.sigre.almacen.service.MotivoTrasladoService;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class MotivoTrasladoServiceImpl implements MotivoTrasladoService {

    private final MotivoTrasladoRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "motivo_traslado", "operation", "findAll"})
    @Override
    public Page<MotivoTraslado> findAll(Pageable pageable) {
        log.info("Listando motivos de traslado - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<MotivoTraslado> page = repository.findAll(pageable);
        log.info("Motivos de traslado encontrados: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "motivo_traslado", "operation", "findById"})
    @Override
    public MotivoTraslado findById(Long id) {
        log.info("Buscando motivo de traslado con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("MotivoTraslado no encontrado con id: {}", id);
                    return new ResourceNotFoundException("MotivoTraslado", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "motivo_traslado", "operation", "create"})
    @Override
    @Transactional
    public MotivoTraslado create(MotivoTraslado entity) {
        log.info("Creando motivo de traslado con codigo: {}", entity.getCodigo());
        validateUniqueCodigo(entity.getCodigo(), null);
        MotivoTraslado saved = repository.save(entity);
        log.info("MotivoTraslado creado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "motivo_traslado", "operation", "update"})
    @Override
    @Transactional
    public MotivoTraslado update(Long id, MotivoTraslado entity) {
        log.info("Actualizando motivo de traslado con id: {}", id);
        MotivoTraslado existing = findById(id);
        validateUniqueCodigo(entity.getCodigo(), id);
        existing.setCodigo(entity.getCodigo());
        existing.setNombre(entity.getNombre());
        if (entity.getFlagEstado() != null) {
            existing.setFlagEstado(entity.getFlagEstado());
        }
        MotivoTraslado updated = repository.save(existing);
        log.info("MotivoTraslado actualizado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "motivo_traslado", "operation", "activate"})
    @Override
    @Transactional
    public MotivoTraslado activate(Long id) {
        log.info("Activando motivo de traslado con id: {}", id);
        MotivoTraslado existing = findById(id);
        existing.setFlagEstado("1");
        MotivoTraslado activated = repository.save(existing);
        log.info("MotivoTraslado activado exitosamente con id: {}", id);
        return activated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "motivo_traslado", "operation", "deactivate"})
    @Override
    @Transactional
    public MotivoTraslado deactivate(Long id) {
        log.info("Desactivando motivo de traslado con id: {}", id);
        MotivoTraslado existing = findById(id);
        existing.setFlagEstado("0");
        MotivoTraslado deactivated = repository.save(existing);
        log.info("MotivoTraslado desactivado exitosamente con id: {}", id);
        return deactivated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "motivo_traslado", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando motivo de traslado con id: {}", id);
        MotivoTraslado existing = findById(id);
        repository.delete(existing);
        log.info("MotivoTraslado eliminado exitosamente con id: {}", id);
    }

    private void validateUniqueCodigo(String codigo, Long excludeId) {
        boolean exists = (excludeId == null)
                ? repository.existsByCodigoIgnoreCase(codigo)
                : repository.existsByCodigoIgnoreCaseAndIdNot(codigo, excludeId);
        if (exists) {
            log.warn("Intento de duplicar codigo de motivo de traslado: {}", codigo);
            throw new BusinessException("Ya existe un motivo de traslado con codigo: " + codigo, HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
    }
}
