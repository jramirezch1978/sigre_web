package com.sigre.comercializacion.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.security.TenantContext;
import com.sigre.comercializacion.dto.request.VendedorRequest;
import com.sigre.comercializacion.dto.response.VendedorResponse;
import com.sigre.comercializacion.entity.Vendedor;
import com.sigre.comercializacion.mapper.VendedorMapper;
import com.sigre.comercializacion.repository.VendedorRepository;
import com.sigre.comercializacion.service.VendedorService;
import com.sigre.comercializacion.service.VentasErrorCodes;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class VendedorServiceImpl implements VendedorService {

    private final VendedorRepository repository;
    private final VendedorMapper mapper;

    @Timed(value = "app.db.query", extraTags = {"table", "vendedor", "operation", "findAll"})
    @Override
    public Page<Vendedor> findAll(Pageable pageable) {
        log.info("Listando vendedores - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<Vendedor> page = repository.findAll(pageable);
        log.info("Vendedores encontrados: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "vendedor", "operation", "findAllWithFilters"})
    @Override
    public Page<Vendedor> findAllWithFilters(Long usuarioId, String nombre, String flagEstado, Pageable pageable) {
        log.info("Listando vendedores con filtros - usuarioId: {}, nombre: {}, flagEstado: {}",
                usuarioId, nombre, flagEstado);
        Page<Vendedor> page = repository.findAllWithFilters(usuarioId, nombre, flagEstado, pageable);
        log.info("Vendedores encontrados con filtros: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "vendedor", "operation", "findById"})
    @Override
    public Vendedor findById(Long id) {
        log.info("Buscando vendedor con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Vendedor no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Vendedor", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "vendedor", "operation", "create"})
    @Override
    @Transactional
    public Vendedor create(Vendedor entity) {
        log.info("Creando vendedor para usuario: {}", entity.getUsuarioId());
        validateUsuarioFk(entity.getUsuarioId());
        validateUniqueUsuario(entity.getUsuarioId(), null);

        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFlagEstado("1");

        Vendedor saved = repository.save(entity);
        log.info("Vendedor creado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "vendedor", "operation", "update"})
    @Override
    @Transactional
    public Vendedor update(Long id, Vendedor entity) {
        log.info("Actualizando vendedor con id: {}", id);
        Vendedor existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Vendedor no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Vendedor", id);
                });
        
        validateUsuarioFk(entity.getUsuarioId());
        validateUniqueUsuario(entity.getUsuarioId(), id);

        existing.setUsuarioId(entity.getUsuarioId());
        existing.setNombre(entity.getNombre());
        existing.setComisionPorcentaje(entity.getComisionPorcentaje());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        Vendedor updated = repository.save(existing);
        log.info("Vendedor actualizado exitosamente con id: {}", id);
        // Recargar con relaciones para el response
        return repository.findByIdWithRelations(updated.getId())
                .orElse(updated);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "vendedor", "operation", "activate"})
    @Override
    @Transactional
    public Vendedor activate(Long id) {
        log.info("Activando vendedor con id: {}", id);
        Vendedor existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Vendedor no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Vendedor", id);
                });
        
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        Vendedor activated = repository.save(existing);
        log.info("Vendedor activado exitosamente con id: {}", id);
        // Recargar con relaciones para el response
        return repository.findByIdWithRelations(activated.getId())
                .orElse(activated);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "vendedor", "operation", "deactivate"})
    @Override
    @Transactional
    public Vendedor deactivate(Long id) {
        log.info("Desactivando vendedor con id: {}", id);
        Vendedor existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Vendedor no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Vendedor", id);
                });
        
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        Vendedor deactivated = repository.save(existing);
        log.info("Vendedor desactivado exitosamente con id: {}", id);
        // Recargar con relaciones para el response
        return repository.findByIdWithRelations(deactivated.getId())
                .orElse(deactivated);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "vendedor", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando vendedor con id: {}", id);
        Vendedor existing = repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Vendedor no encontrado con id: {}", id);
                    return new ResourceNotFoundException("Vendedor", id);
                });
        
        repository.delete(existing);
        log.info("Vendedor eliminado exitosamente con id: {}", id);
    }

    @Override
    public Vendedor findByUsuarioId(Long usuarioId) {
        log.info("Buscando vendedor activo para usuario: {}", usuarioId);
        return repository.findByUsuarioIdAndActivo(usuarioId)
                .orElseThrow(() -> {
                    log.warn("Vendedor no encontrado para usuario: {}", usuarioId);
                    return new ResourceNotFoundException("Vendedor", "usuarioId", usuarioId.toString());
                });
    }

    private void validateUniqueUsuario(Long usuarioId, Long excludeId) {
        boolean exists = (excludeId == null)
                ? repository.existsByUsuarioIdAndFlagEstado(usuarioId, "1")
                : repository.existsByUsuarioIdAndFlagEstadoAndIdNot(usuarioId, "1", excludeId);

        if (exists) {
            log.warn("Intento de duplicar vendedor para usuario: {}", usuarioId);
            throw new BusinessException(
                    "Ya existe un vendedor para el usuario especificado",
                    org.springframework.http.HttpStatus.CONFLICT,
                    VentasErrorCodes.VENDEDOR_USUARIO_INVALIDO);
        }
    }

    private void validateUsuarioFk(Long usuarioId) {
        if (usuarioId == null) {
            return;
        }
        if (!repository.existsUsuarioActivo(usuarioId)) {
            throw new BusinessException(
                    "El usuario indicado no existe o no está activo",
                    org.springframework.http.HttpStatus.UNPROCESSABLE_ENTITY,
                    VentasErrorCodes.VENDEDOR_USUARIO_FK_INVALIDO);
        }
    }
}
