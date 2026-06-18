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
import pe.restaurant.core.entity.Sucursal;
import java.time.Instant;
import pe.restaurant.core.repository.DepartamentoRepository;
import pe.restaurant.core.repository.DistritoRepository;
import pe.restaurant.core.repository.PaisRepository;
import pe.restaurant.core.repository.ProvinciaRepository;
import pe.restaurant.core.repository.SucursalRepository;
import pe.restaurant.core.service.SucursalService;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class SucursalServiceImpl implements SucursalService {

    private final SucursalRepository repository;
    private final PaisRepository paisRepository;
    private final DepartamentoRepository departamentoRepository;
    private final ProvinciaRepository provinciaRepository;
    private final DistritoRepository distritoRepository;

    @Timed(value = "app.db.query", extraTags = {"table", "sucursal", "operation", "findAll"})
    @Override
    public Page<Sucursal> findAll(Pageable pageable) {
        log.info("Listando sucursales - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<Sucursal> page = repository.findAll(pageable);
        log.info("Sucursales encontradas: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "sucursal", "operation", "findById"})
    @Override
    public Sucursal findById(Long id) {
        log.info("Buscando sucursal con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Sucursal no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Sucursal", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "sucursal", "operation", "create"})
    @Override
    @Transactional
    public Sucursal create(Sucursal entity) {
        log.info("Creando sucursal: {}", entity.getNombre());
        validateGeografiaForeignKeys(entity);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        Sucursal saved = repository.save(entity);
        log.info("Sucursal creada exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "sucursal", "operation", "update"})
    @Override
    @Transactional
    public Sucursal update(Long id, Sucursal entity) {
        log.info("Actualizando sucursal con id: {}", id);
        Sucursal existing = findById(id);
        validateGeografiaForeignKeys(entity);
        existing.setCodigo(entity.getCodigo());
        existing.setNombre(entity.getNombre());
        existing.setDireccion(entity.getDireccion());
        existing.setCiudad(entity.getCiudad());
        existing.setPaisId(entity.getPaisId());
        existing.setDepartamentoId(entity.getDepartamentoId());
        existing.setProvinciaId(entity.getProvinciaId());
        existing.setDistritoId(entity.getDistritoId());
        existing.setUbigeo(entity.getUbigeo());
        existing.setFlagEstado(entity.getFlagEstado());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        Sucursal updated = repository.save(existing);
        log.info("Sucursal actualizada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "sucursal", "operation", "delete"})
    @Override @Transactional
    public void delete(Long id) {
        log.info("Eliminando sucursal con id: {}", id);
        findById(id);
        repository.deleteById(id);
        log.info("Sucursal eliminada exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "sucursal", "operation", "activate"})
    @Override @Transactional
    public Sucursal activate(Long id) {
        log.info("Activando sucursal con id: {}", id);
        Sucursal existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "sucursal", "operation", "deactivate"})
    @Override @Transactional
    public Sucursal deactivate(Long id) {
        log.info("Desactivando sucursal con id: {}", id);
        Sucursal existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    private void validateGeografiaForeignKeys(Sucursal entity) {
        if (entity.getPaisId() != null && !paisRepository.existsById(entity.getPaisId())) {
            throw new ResourceNotFoundException("Pais", entity.getPaisId());
        }
        if (entity.getDepartamentoId() != null && !departamentoRepository.existsById(entity.getDepartamentoId())) {
            throw new ResourceNotFoundException("Departamento", entity.getDepartamentoId());
        }
        if (entity.getProvinciaId() != null && !provinciaRepository.existsById(entity.getProvinciaId())) {
            throw new ResourceNotFoundException("Provincia", entity.getProvinciaId());
        }
        if (entity.getDistritoId() != null && !distritoRepository.existsById(entity.getDistritoId())) {
            throw new ResourceNotFoundException("Distrito", entity.getDistritoId());
        }
    }
}
