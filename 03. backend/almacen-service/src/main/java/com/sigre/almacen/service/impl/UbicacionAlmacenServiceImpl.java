package com.sigre.almacen.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.almacen.entity.UbicacionAlmacen;
import com.sigre.almacen.repository.AlmacenRepository;
import com.sigre.almacen.repository.UbicacionAlmacenRepository;
import com.sigre.almacen.service.UbicacionAlmacenService;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.maestro.UniqueKeyPageables;

import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UbicacionAlmacenServiceImpl implements UbicacionAlmacenService {

    private final UbicacionAlmacenRepository repository;
    private final AlmacenRepository almacenRepository;

    @Timed(value = "app.db.query", extraTags = {"table", "ubicacion_almacen", "operation", "findByAlmacenId"})
    @Override
    public List<UbicacionAlmacen> findByAlmacenId(Long almacenId) {
        log.info("Listando ubicaciones para almacen id: {}", almacenId);
        List<UbicacionAlmacen> list = repository.findByAlmacenId(
                almacenId, UniqueKeyPageables.sortOf(UbicacionAlmacen.class));
        log.info("Ubicaciones encontradas: {}", list.size());
        return list;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "ubicacion_almacen", "operation", "findById"})
    @Override
    public UbicacionAlmacen findById(Long id) {
        log.info("Buscando ubicacion de almacen con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("UbicacionAlmacen no encontrada con id: {}", id);
                    return new ResourceNotFoundException("UbicacionAlmacen", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "ubicacion_almacen", "operation", "create"})
    @Override
    @Transactional
    public UbicacionAlmacen create(UbicacionAlmacen entity) {
        log.info("Creando ubicacion con codigo: {} para almacen: {}", entity.getCodigo(), entity.getAlmacenId());
        if (!almacenRepository.existsById(entity.getAlmacenId())) {
            throw new ResourceNotFoundException("Almacen", entity.getAlmacenId());
        }
        validateUniqueAlmacenCodigo(entity.getAlmacenId(), entity.getCodigo(), null);
        UbicacionAlmacen saved = repository.save(entity);
        log.info("UbicacionAlmacen creada exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "ubicacion_almacen", "operation", "update"})
    @Override
    @Transactional
    public UbicacionAlmacen update(Long id, UbicacionAlmacen entity) {
        log.info("Actualizando ubicacion de almacen con id: {}", id);
        UbicacionAlmacen existing = findById(id);
        validateUniqueAlmacenCodigo(existing.getAlmacenId(), entity.getCodigo(), id);
        existing.setCodigo(entity.getCodigo());
        existing.setNombre(entity.getNombre());
        existing.setPasillo(entity.getPasillo());
        existing.setEstante(entity.getEstante());
        existing.setNivel(entity.getNivel());
        UbicacionAlmacen updated = repository.save(existing);
        log.info("UbicacionAlmacen actualizada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "ubicacion_almacen", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando ubicacion de almacen con id: {}", id);
        UbicacionAlmacen existing = findById(id);
        repository.delete(existing);
        log.info("UbicacionAlmacen eliminada exitosamente con id: {}", id);
    }

    private void validateUniqueAlmacenCodigo(Long almacenId, String codigo, Long excludeId) {
        boolean exists = (excludeId == null)
                ? repository.existsByAlmacenIdAndCodigoIgnoreCase(almacenId, codigo)
                : repository.existsByAlmacenIdAndCodigoIgnoreCaseAndIdNot(almacenId, codigo, excludeId);
        if (exists) {
            log.warn("Intento de duplicar codigo de ubicacion: {} para almacen: {}", codigo, almacenId);
            throw new BusinessException(
                    "Ya existe una ubicacion con codigo: " + codigo + " para el almacen: " + almacenId,
                    HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
    }
}
