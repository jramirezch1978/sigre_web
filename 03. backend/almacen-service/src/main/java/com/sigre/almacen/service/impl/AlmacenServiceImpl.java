package com.sigre.almacen.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.almacen.entity.Almacen;
import com.sigre.almacen.repository.AlmacenRepository;
import com.sigre.almacen.repository.AlmacenTipoRepository;
import com.sigre.almacen.service.AlmacenService;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AlmacenServiceImpl implements AlmacenService {

    private final AlmacenRepository repository;
    private final AlmacenTipoRepository almacenTipoRepository;

    @Timed(value = "app.db.query", extraTags = {"table", "almacen", "operation", "findAll"})
    @Override
    public Page<Almacen> findAll(Pageable pageable) {
        log.info("Listando almacenes - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<Almacen> page = repository.findAll(pageable);
        log.info("Almacenes encontrados: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "almacen", "operation", "findById"})
    @Override
    public Almacen findById(Long id) {
        log.info("Buscando almacen con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Almacen no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Almacen", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "almacen", "operation", "create"})
    @Override
    @Transactional
    public Almacen create(Almacen entity) {
        log.info("Creando almacen con codigo: {} para sucursal: {}", entity.getCodigo(), entity.getSucursalId());
        validateForeignKeys(entity);
        validateUniqueSucursalCodigo(entity.getSucursalId(), entity.getCodigo(), null);
        Almacen saved = repository.save(entity);
        log.info("Almacen creado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "almacen", "operation", "update"})
    @Override
    @Transactional
    public Almacen update(Long id, Almacen entity) {
        log.info("Actualizando almacen con id: {}", id);
        Almacen existing = findById(id);
        validateForeignKeys(entity);
        validateUniqueSucursalCodigo(entity.getSucursalId(), entity.getCodigo(), id);
        existing.setSucursalId(entity.getSucursalId());
        existing.setAlmacenTipoId(entity.getAlmacenTipoId());
        existing.setCodigo(entity.getCodigo());
        existing.setNombre(entity.getNombre());
        Almacen updated = repository.save(existing);
        log.info("Almacen actualizado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "almacen", "operation", "activate"})
    @Override
    @Transactional
    public Almacen activate(Long id) {
        log.info("Activando almacen con id: {}", id);
        Almacen existing = findById(id);
        existing.setFlagEstado("1");
        Almacen activated = repository.save(existing);
        log.info("Almacen activado exitosamente con id: {}", id);
        return activated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "almacen", "operation", "deactivate"})
    @Override
    @Transactional
    public Almacen deactivate(Long id) {
        log.info("Desactivando almacen con id: {}", id);
        Almacen existing = findById(id);
        existing.setFlagEstado("0");
        Almacen deactivated = repository.save(existing);
        log.info("Almacen desactivado exitosamente con id: {}", id);
        return deactivated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "almacen", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando almacen con id: {}", id);
        Almacen existing = findById(id);
        repository.delete(existing);
        log.info("Almacen eliminado exitosamente con id: {}", id);
    }

    private void validateForeignKeys(Almacen entity) {
        // La sucursalId NO se valida contra auth.sucursal: en el modelo multi-tenant
        // el esquema `auth` es central y no existe en la BD de cada tenant (consultarlo
        // desde el datasource del tenant rompe la transacción —"relation auth.sucursal
        // does not exist"—). La sucursal ya viene validada por el JWT/contexto autenticado.
        // Se valida con el repositorio JPA (datasource del TENANT), no con jdbcTemplate:
        // el JdbcTemplate apunta al datasource central/seguridad y ahí no existe
        // `almacen.almacen_tipo` ("relation does not exist"), lo que rompía el create
        // cuando se enviaba un almacenTipoId. El repositorio JPA enruta al tenant correcto.
        if (entity.getAlmacenTipoId() != null
                && !almacenTipoRepository.existsById(entity.getAlmacenTipoId())) {
            throw new ResourceNotFoundException("AlmacenTipo", entity.getAlmacenTipoId());
        }
    }

    private void validateUniqueSucursalCodigo(Long sucursalId, String codigo, Long excludeId) {
        boolean exists = (excludeId == null)
                ? repository.existsBySucursalIdAndCodigoIgnoreCase(sucursalId, codigo)
                : repository.existsBySucursalIdAndCodigoIgnoreCaseAndIdNot(sucursalId, codigo, excludeId);
        if (exists) {
            log.warn("Intento de duplicar codigo de almacen: {} para sucursal: {}", codigo, sucursalId);
            throw new BusinessException(
                    "Ya existe un almacen con codigo: " + codigo + " para la sucursal: " + sucursalId,
                    HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
    }
}
