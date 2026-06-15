package com.sigre.core.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.core.entity.Departamento;
import java.time.Instant;
import com.sigre.core.entity.Distrito;
import com.sigre.core.entity.Pais;
import com.sigre.core.entity.Provincia;
import com.sigre.core.repository.DepartamentoRepository;
import com.sigre.core.repository.DistritoRepository;
import com.sigre.core.repository.PaisRepository;
import com.sigre.core.repository.ProvinciaRepository;
import com.sigre.core.service.GeografiaService;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class GeografiaServiceImpl implements GeografiaService {

    private final PaisRepository paisRepository;
    private final DepartamentoRepository departamentoRepository;
    private final ProvinciaRepository provinciaRepository;
    private final DistritoRepository distritoRepository;

    // ── Pais ──────────────────────────────────────────────────────────────

    @Timed(value = "app.db.query", extraTags = {"table", "pais", "operation", "findAll"})
    @Override
    public Page<Pais> findAllPaises(Pageable pageable) {
        log.info("Listando paises - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<Pais> page = paisRepository.findAll(pageable);
        log.info("Paises encontrados: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "pais", "operation", "findById"})
    @Override
    public Pais findPaisById(Long id) {
        log.info("Buscando pais con id: {}", id);
        return paisRepository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Pais no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Pais", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "pais", "operation", "create"})
    @Override
    @Transactional
    public Pais createPais(Pais entity) {
        log.info("Creando pais con codigo: {}", entity.getCodigo());
        validateUniquePaisCodigo(entity.getCodigo(), null);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        Pais saved = paisRepository.save(entity);
        log.info("Pais creado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "pais", "operation", "update"})
    @Override
    @Transactional
    public Pais updatePais(Long id, Pais entity) {
        log.info("Actualizando pais con id: {}", id);
        findPaisById(id);
        validateUniquePaisCodigo(entity.getCodigo(), id);
        entity.setId(id);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        Pais updated = paisRepository.save(entity);
        log.info("Pais actualizado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "pais", "operation", "activate"})
    @Override
    @Transactional
    public Pais activatePais(Long id) {
        log.info("Activando pais con id: {}", id);
        Pais entity = findPaisById(id);
        entity.setFlagEstado("1");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        Pais updated = paisRepository.save(entity);
        log.info("Pais activado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "pais", "operation", "deactivate"})
    @Override
    @Transactional
    public Pais deactivatePais(Long id) {
        log.info("Desactivando pais con id: {}", id);
        Pais entity = findPaisById(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        Pais updated = paisRepository.save(entity);
        log.info("Pais desactivado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "pais", "operation", "delete"})
    @Override
    @Transactional
    public void deletePais(Long id) {
        log.info("Eliminando pais con id: {}", id);
        findPaisById(id);
        paisRepository.deleteById(id);
        log.info("Pais eliminado exitosamente con id: {}", id);
    }

    private void validateUniquePaisCodigo(String codigo, Long excludeId) {
        boolean exists = excludeId == null
                ? paisRepository.existsByCodigoIgnoreCase(codigo)
                : paisRepository.existsByCodigoIgnoreCaseAndIdNot(codigo, excludeId);
        if (exists) {
            log.warn("Intento de duplicar codigo de pais: {}", codigo);
            throw new BusinessException("Ya existe un pais con codigo: " + codigo, HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
    }

    // ── Departamento ──────────────────────────────────────────────────────

    @Timed(value = "app.db.query", extraTags = {"table", "departamento", "operation", "findAll"})
    @Override
    public Page<Departamento> findAllDepartamentos(Long paisId, Pageable pageable) {
        if (paisId != null) {
            log.info("Listando departamentos para paisId: {} - page: {}, size: {}", paisId, pageable.getPageNumber(), pageable.getPageSize());
            Page<Departamento> result = departamentoRepository.findByPaisId(paisId, pageable);
            log.info("Departamentos encontrados: {} para paisId: {}", result.getTotalElements(), paisId);
            return result;
        }
        log.info("Listando todos los departamentos - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<Departamento> result = departamentoRepository.findAll(pageable);
        log.info("Departamentos encontrados: {}", result.getTotalElements());
        return result;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "departamento", "operation", "findById"})
    @Override
    public Departamento findDepartamentoById(Long id) {
        log.info("Buscando departamento con id: {}", id);
        return departamentoRepository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Departamento no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Departamento", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "departamento", "operation", "create"})
    @Override
    @Transactional
    public Departamento createDepartamento(Departamento entity) {
        log.info("Creando departamento con codigo: {}", entity.getCodigo());
        if (entity.getPaisId() != null && !paisRepository.existsById(entity.getPaisId())) {
            throw new ResourceNotFoundException("Pais", entity.getPaisId());
        }
        validateUniqueDepartamentoCodigo(entity.getCodigo(), null);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        Departamento saved = departamentoRepository.save(entity);
        log.info("Departamento creado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "departamento", "operation", "update"})
    @Override
    @Transactional
    public Departamento updateDepartamento(Long id, Departamento entity) {
        log.info("Actualizando departamento con id: {}", id);
        findDepartamentoById(id);
        if (entity.getPaisId() != null && !paisRepository.existsById(entity.getPaisId())) {
            throw new ResourceNotFoundException("Pais", entity.getPaisId());
        }
        validateUniqueDepartamentoCodigo(entity.getCodigo(), id);
        entity.setId(id);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        Departamento updated = departamentoRepository.save(entity);
        log.info("Departamento actualizado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "departamento", "operation", "activate"})
    @Override
    @Transactional
    public Departamento activateDepartamento(Long id) {
        log.info("Activando departamento con id: {}", id);
        Departamento entity = findDepartamentoById(id);
        entity.setFlagEstado("1");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        Departamento updated = departamentoRepository.save(entity);
        log.info("Departamento activado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "departamento", "operation", "deactivate"})
    @Override
    @Transactional
    public Departamento deactivateDepartamento(Long id) {
        log.info("Desactivando departamento con id: {}", id);
        Departamento entity = findDepartamentoById(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        Departamento updated = departamentoRepository.save(entity);
        log.info("Departamento desactivado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "departamento", "operation", "delete"})
    @Override
    @Transactional
    public void deleteDepartamento(Long id) {
        log.info("Eliminando departamento con id: {}", id);
        findDepartamentoById(id);
        departamentoRepository.deleteById(id);
        log.info("Departamento eliminado exitosamente con id: {}", id);
    }

    private void validateUniqueDepartamentoCodigo(String codigo, Long excludeId) {
        boolean exists = excludeId == null
                ? departamentoRepository.existsByCodigoIgnoreCase(codigo)
                : departamentoRepository.existsByCodigoIgnoreCaseAndIdNot(codigo, excludeId);
        if (exists) {
            log.warn("Intento de duplicar codigo de departamento: {}", codigo);
            throw new BusinessException("Ya existe un departamento con codigo: " + codigo, HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
    }

    // ── Provincia ─────────────────────────────────────────────────────────

    @Timed(value = "app.db.query", extraTags = {"table", "provincia", "operation", "findAll"})
    @Override
    public Page<Provincia> findAllProvincias(Long departamentoId, Pageable pageable) {
        if (departamentoId != null) {
            log.info("Listando provincias para departamentoId: {} - page: {}, size: {}", departamentoId, pageable.getPageNumber(), pageable.getPageSize());
            Page<Provincia> result = provinciaRepository.findByDepartamentoId(departamentoId, pageable);
            log.info("Provincias encontradas: {} para departamentoId: {}", result.getTotalElements(), departamentoId);
            return result;
        }
        log.info("Listando todas las provincias - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<Provincia> result = provinciaRepository.findAll(pageable);
        log.info("Provincias encontradas: {}", result.getTotalElements());
        return result;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "provincia", "operation", "findById"})
    @Override
    public Provincia findProvinciaById(Long id) {
        log.info("Buscando provincia con id: {}", id);
        return provinciaRepository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Provincia no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Provincia", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "provincia", "operation", "create"})
    @Override
    @Transactional
    public Provincia createProvincia(Provincia entity) {
        log.info("Creando provincia con codigo: {}", entity.getCodigo());
        if (entity.getDepartamentoId() != null && !departamentoRepository.existsById(entity.getDepartamentoId())) {
            throw new ResourceNotFoundException("Departamento", entity.getDepartamentoId());
        }
        validateUniqueProvinciaCodigo(entity.getCodigo(), null);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        Provincia saved = provinciaRepository.save(entity);
        log.info("Provincia creada exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "provincia", "operation", "update"})
    @Override
    @Transactional
    public Provincia updateProvincia(Long id, Provincia entity) {
        log.info("Actualizando provincia con id: {}", id);
        findProvinciaById(id);
        if (entity.getDepartamentoId() != null && !departamentoRepository.existsById(entity.getDepartamentoId())) {
            throw new ResourceNotFoundException("Departamento", entity.getDepartamentoId());
        }
        validateUniqueProvinciaCodigo(entity.getCodigo(), id);
        entity.setId(id);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        Provincia updated = provinciaRepository.save(entity);
        log.info("Provincia actualizada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "provincia", "operation", "activate"})
    @Override
    @Transactional
    public Provincia activateProvincia(Long id) {
        log.info("Activando provincia con id: {}", id);
        Provincia entity = findProvinciaById(id);
        entity.setFlagEstado("1");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        Provincia updated = provinciaRepository.save(entity);
        log.info("Provincia activada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "provincia", "operation", "deactivate"})
    @Override
    @Transactional
    public Provincia deactivateProvincia(Long id) {
        log.info("Desactivando provincia con id: {}", id);
        Provincia entity = findProvinciaById(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        Provincia updated = provinciaRepository.save(entity);
        log.info("Provincia desactivada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "provincia", "operation", "delete"})
    @Override
    @Transactional
    public void deleteProvincia(Long id) {
        log.info("Eliminando provincia con id: {}", id);
        findProvinciaById(id);
        provinciaRepository.deleteById(id);
        log.info("Provincia eliminada exitosamente con id: {}", id);
    }

    private void validateUniqueProvinciaCodigo(String codigo, Long excludeId) {
        boolean exists = excludeId == null
                ? provinciaRepository.existsByCodigoIgnoreCase(codigo)
                : provinciaRepository.existsByCodigoIgnoreCaseAndIdNot(codigo, excludeId);
        if (exists) {
            log.warn("Intento de duplicar codigo de provincia: {}", codigo);
            throw new BusinessException("Ya existe una provincia con codigo: " + codigo, HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
    }

    // ── Distrito ──────────────────────────────────────────────────────────

    @Timed(value = "app.db.query", extraTags = {"table", "distrito", "operation", "findAll"})
    @Override
    public Page<Distrito> findAllDistritos(Long provinciaId, Pageable pageable) {
        if (provinciaId != null) {
            log.info("Listando distritos para provinciaId: {} - page: {}, size: {}", provinciaId, pageable.getPageNumber(), pageable.getPageSize());
            Page<Distrito> result = distritoRepository.findByProvinciaId(provinciaId, pageable);
            log.info("Distritos encontrados: {} para provinciaId: {}", result.getTotalElements(), provinciaId);
            return result;
        }
        log.info("Listando todos los distritos - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<Distrito> result = distritoRepository.findAll(pageable);
        log.info("Distritos encontrados: {}", result.getTotalElements());
        return result;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "distrito", "operation", "findById"})
    @Override
    public Distrito findDistritoById(Long id) {
        log.info("Buscando distrito con id: {}", id);
        return distritoRepository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Distrito no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Distrito", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "distrito", "operation", "create"})
    @Override
    @Transactional
    public Distrito createDistrito(Distrito entity) {
        log.info("Creando distrito con codigo: {}", entity.getCodigo());
        if (entity.getProvinciaId() != null && !provinciaRepository.existsById(entity.getProvinciaId())) {
            throw new ResourceNotFoundException("Provincia", entity.getProvinciaId());
        }
        validateUniqueDistritoCodigo(entity.getCodigo(), null);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        Distrito saved = distritoRepository.save(entity);
        log.info("Distrito creado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "distrito", "operation", "update"})
    @Override
    @Transactional
    public Distrito updateDistrito(Long id, Distrito entity) {
        log.info("Actualizando distrito con id: {}", id);
        findDistritoById(id);
        if (entity.getProvinciaId() != null && !provinciaRepository.existsById(entity.getProvinciaId())) {
            throw new ResourceNotFoundException("Provincia", entity.getProvinciaId());
        }
        validateUniqueDistritoCodigo(entity.getCodigo(), id);
        entity.setId(id);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        Distrito updated = distritoRepository.save(entity);
        log.info("Distrito actualizado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "distrito", "operation", "activate"})
    @Override
    @Transactional
    public Distrito activateDistrito(Long id) {
        log.info("Activando distrito con id: {}", id);
        Distrito entity = findDistritoById(id);
        entity.setFlagEstado("1");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        Distrito updated = distritoRepository.save(entity);
        log.info("Distrito activado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "distrito", "operation", "deactivate"})
    @Override
    @Transactional
    public Distrito deactivateDistrito(Long id) {
        log.info("Desactivando distrito con id: {}", id);
        Distrito entity = findDistritoById(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        Distrito updated = distritoRepository.save(entity);
        log.info("Distrito desactivado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "distrito", "operation", "delete"})
    @Override
    @Transactional
    public void deleteDistrito(Long id) {
        log.info("Eliminando distrito con id: {}", id);
        findDistritoById(id);
        distritoRepository.deleteById(id);
        log.info("Distrito eliminado exitosamente con id: {}", id);
    }

    private void validateUniqueDistritoCodigo(String codigo, Long excludeId) {
        boolean exists = excludeId == null
                ? distritoRepository.existsByCodigoIgnoreCase(codigo)
                : distritoRepository.existsByCodigoIgnoreCaseAndIdNot(codigo, excludeId);
        if (exists) {
            log.warn("Intento de duplicar codigo de distrito: {}", codigo);
            throw new BusinessException("Ya existe un distrito con codigo: " + codigo, HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
    }
}
