package pe.restaurant.almacen.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.almacen.entity.AlmacenTacito;
import pe.restaurant.almacen.repository.AlmacenTacitoRepository;
import pe.restaurant.almacen.service.AlmacenTacitoService;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AlmacenTacitoServiceImpl implements AlmacenTacitoService {

    private final AlmacenTacitoRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "almacen_tacito", "operation", "buscar"})
    @Override
    public Page<AlmacenTacito> buscar(String codClase, Long sucursalId, Long almacenId, Pageable pageable) {
        log.info("Listando almacen tacito - codClase: {}, sucursalId: {}, almacenId: {}", codClase, sucursalId, almacenId);
        return repository.buscar(codClase, sucursalId, almacenId, pageable);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "almacen_tacito", "operation", "findById"})
    @Override
    public AlmacenTacito findById(Long id) {
        log.info("Buscando almacen tacito con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("AlmacenTacito no encontrado con id: {}", id);
                    return new ResourceNotFoundException("AlmacenTacito", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "almacen_tacito", "operation", "create"})
    @Override
    @Transactional
    public AlmacenTacito create(AlmacenTacito entity) {
        log.info("Creando almacen tacito clase: {} sucursal: {}", entity.getCodClase(), entity.getSucursalId());
        validateUnico(entity.getCodClase(), entity.getSucursalId(), null);
        AlmacenTacito saved = repository.save(entity);
        log.info("AlmacenTacito creado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "almacen_tacito", "operation", "update"})
    @Override
    @Transactional
    public AlmacenTacito update(Long id, AlmacenTacito entity) {
        log.info("Actualizando almacen tacito con id: {}", id);
        AlmacenTacito existing = findById(id);
        validateUnico(entity.getCodClase(), entity.getSucursalId(), id);
        existing.setCodClase(entity.getCodClase());
        existing.setSucursalId(entity.getSucursalId());
        existing.setAlmacenId(entity.getAlmacenId());
        AlmacenTacito updated = repository.save(existing);
        log.info("AlmacenTacito actualizado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "almacen_tacito", "operation", "activate"})
    @Override
    @Transactional
    public AlmacenTacito activate(Long id) {
        log.info("Activando almacen tacito con id: {}", id);
        AlmacenTacito existing = findById(id);
        existing.setFlagEstado("1");
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "almacen_tacito", "operation", "deactivate"})
    @Override
    @Transactional
    public AlmacenTacito deactivate(Long id) {
        log.info("Desactivando almacen tacito con id: {}", id);
        AlmacenTacito existing = findById(id);
        existing.setFlagEstado("0");
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "almacen_tacito", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando almacen tacito con id: {}", id);
        AlmacenTacito existing = findById(id);
        repository.delete(existing);
        log.info("AlmacenTacito eliminado exitosamente con id: {}", id);
    }

    private void validateUnico(String codClase, Long sucursalId, Long excludeId) {
        boolean exists = (excludeId == null)
                ? repository.existsByCodClaseIgnoreCaseAndSucursalId(codClase, sucursalId)
                : repository.existsByCodClaseIgnoreCaseAndSucursalIdAndIdNot(codClase, sucursalId, excludeId);
        if (exists) {
            log.warn("Intento de duplicar almacen tacito clase: {} sucursal: {}", codClase, sucursalId);
            throw new BusinessException(
                    "Ya existe un almacén tácito para la clase " + codClase + " y sucursal " + sucursalId,
                    HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
    }
}
