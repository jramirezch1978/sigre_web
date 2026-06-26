package pe.restaurant.activos.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.activos.entity.AfDocumento;
import pe.restaurant.activos.repository.AfDocumentoRepository;
import pe.restaurant.activos.repository.AfMaestroRepository;
import pe.restaurant.activos.service.AfDocumentoService;
import pe.restaurant.activos.service.ActivosErrorCodes;
import pe.restaurant.activos.util.ActivosFlagEstado;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

import java.time.LocalDate;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AfDocumentoServiceImpl implements AfDocumentoService {

    private final AfDocumentoRepository repository;
    private final AfMaestroRepository maestroRepository;

    @Timed(value = "app.db.query", extraTags = {"table", "af_documento", "operation", "findAll"})
    @Override
    public Page<AfDocumento> findAll(Pageable pageable) {
        log.info("Listando documentos - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        return repository.findAll(pageable);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_documento", "operation", "findById"})
    @Override
    public AfDocumento findById(Long id) {
        log.info("Buscando documento con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Documento", id));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_documento", "operation", "create"})
    @Override
    @Transactional
    public AfDocumento create(AfDocumento entity) {
        log.info("Creando documento para activo: {}", entity.getAfMaestroId());
        
        validarActivoExistente(entity.getAfMaestroId());
        
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        if (entity.getFechaCarga() == null) {
            entity.setFechaCarga(LocalDate.now());
        }
        
        AfDocumento saved = repository.save(entity);
        log.info("Documento creado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_documento", "operation", "update"})
    @Override
    @Transactional
    public AfDocumento update(Long id, AfDocumento entity) {
        log.info("Actualizando documento con id: {}", id);
        AfDocumento existing = findById(id);
        
        existing.setTipoDocumento(entity.getTipoDocumento());
        existing.setNombreArchivo(entity.getNombreArchivo());
        existing.setDescripcion(entity.getDescripcion());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        
        AfDocumento updated = repository.save(existing);
        log.info("Documento actualizado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_documento", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando documento con id: {}", id);
        AfDocumento existing = findById(id);
        repository.delete(existing);
        log.info("Documento eliminado exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_documento", "operation", "findByActivo"})
    @Override
    public List<AfDocumento> findByActivo(Long activoId) {
        log.info("Listando documentos del activo: {}", activoId);
        return repository.findByAfMaestroIdOrderByFechaCargaDesc(activoId);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_documento", "operation", "findByTipo"})
    @Override
    public Page<AfDocumento> findByTipo(String tipoDocumento, Pageable pageable) {
        log.info("Listando documentos por tipo: {}", tipoDocumento);
        return repository.findByTipoDocumento(tipoDocumento, pageable);
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
    }
}
