package pe.restaurant.activos.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.activos.entity.AfOperaciones;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.repository.AfOperacionesRepository;
import pe.restaurant.activos.service.AfOperacionesService;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

import java.time.LocalDate;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AfOperacionesServiceImpl implements AfOperacionesService {

    private final AfOperacionesRepository repository;
    private final AfMaestroRepository maestroRepository;

    @Timed(value = "app.db.query", extraTags = {"table", "af_operaciones", "operation", "findAll"})
    @Override
    public Page<AfOperaciones> findAll(Pageable pageable) {
        log.info("Listando operaciones - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        Page<AfOperaciones> page = repository.findAll(pageable);
        log.info("Operaciones encontradas: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_operaciones", "operation", "findById"})
    @Override
    public AfOperaciones findById(Long id) {
        log.info("Buscando operación con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Operación no encontrada con id: {}", id);
                    return new ResourceNotFoundException("Operación", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_operaciones", "operation", "create"})
    @Override
    @Transactional
    public AfOperaciones create(AfOperaciones entity) {
        log.info("Creando operación para activo: {}", entity.getAfMaestroId());
        
        validarActivoExistente(entity.getAfMaestroId());

        entity.setCreatedBy(TenantContext.getUsuarioId());
        AfOperaciones saved = repository.save(entity);
        log.info("Operación creada exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_operaciones", "operation", "update"})
    @Override
    @Transactional
    public AfOperaciones update(Long id, AfOperaciones entity) {
        log.info("Actualizando operación con id: {}", id);
        AfOperaciones existing = findById(id);

        existing.setTipo(entity.getTipo());
        existing.setFechaProgramada(entity.getFechaProgramada());
        existing.setCosto(entity.getCosto());
        existing.setProveedorServicio(entity.getProveedorServicio());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        AfOperaciones updated = repository.save(existing);
        log.info("Operación actualizada exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_operaciones", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando operación con id: {}", id);
        AfOperaciones existing = findById(id);
        
        repository.delete(existing);
        log.info("Operación eliminada exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_operaciones", "operation", "findByActivo"})
    @Override
    public List<AfOperaciones> findByActivo(Long activoId) {
        log.info("Listando operaciones del activo: {}", activoId);
        List<AfOperaciones> operaciones = repository.findByAfMaestroId(activoId);
        log.info("Operaciones encontradas para activo {}: {}", activoId, operaciones.size());
        return operaciones;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_operaciones", "operation", "findProgramadas"})
    @Override
    public List<AfOperaciones> findProgramadas() {
        log.info("Listando operaciones programadas");
        List<AfOperaciones> operaciones = repository.findProgramadas(LocalDate.now().plusDays(30));
        log.info("Operaciones programadas encontradas: {}", operaciones.size());
        return operaciones;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_operaciones", "operation", "ejecutar"})
    @Override
    @Transactional
    public AfOperaciones ejecutar(Long id) {
        log.info("Ejecutando operación con id: {}", id);
        AfOperaciones operacion = findById(id);
        
        operacion.setFechaEjecucion(LocalDate.now());
        AfOperaciones ejecutada = repository.save(operacion);
        
        log.info("Operación ejecutada exitosamente con id: {}", id);
        return ejecutada;
    }

    private void validarActivoExistente(Long afMaestroId) {
        log.debug("Validando existencia de activo con id: {}", afMaestroId);
        maestroRepository.findById(afMaestroId)
                .orElseThrow(() -> {
                    log.warn("Activo maestro no encontrado con id: {}", afMaestroId);
                    return new BusinessException(
                            "El activo con ID " + afMaestroId + " no existe en el sistema",
                            HttpStatus.NOT_FOUND,
                            ActivosErrorCodes.MAESTRO_NO_ENCONTRADO
                    );
                });
        log.debug("Activo validado exitosamente");
    }
}
