package pe.restaurant.core.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.core.entity.DocTipo;
import pe.restaurant.core.repository.DocTipoRepository;
import pe.restaurant.core.service.DocTipoService;

import java.time.Instant;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class DocTipoServiceImpl implements DocTipoService {

    private final DocTipoRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "doc_tipo", "operation", "findAll"})
    @Override
    public List<DocTipo> findAll() {
        log.info("Listando todos los tipos de documento");
        List<DocTipo> result = repository.findAll();
        log.info("Tipos de documento encontrados: {}", result.size());
        return result;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "doc_tipo", "operation", "findById"})
    @Override
    public DocTipo findById(Long id) {
        log.info("Buscando tipo de documento con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("DocTipo no encontrado con id: {}", id);
                    return new ResourceNotFoundException("DocTipo", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "doc_tipo", "operation", "findByCodigo"})
    @Override
    public DocTipo findByCodigo(String codigo) {
        log.info("Buscando tipo de documento con codigo: {}", codigo);
        return repository.findByCodigo(codigo)
                .orElseThrow(() -> {
                    log.warn("DocTipo no encontrado con codigo: {}", codigo);
                    return new ResourceNotFoundException("DocTipo", "codigo", codigo);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "doc_tipo", "operation", "create"})
    @Override
    @Transactional
    public DocTipo create(DocTipo entity) {
        log.info("Creando tipo de documento con codigo: {}", entity.getCodigo());
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        DocTipo saved = repository.save(entity);
        log.info("DocTipo creado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "doc_tipo", "operation", "update"})
    @Override
    @Transactional
    public DocTipo update(Long id, DocTipo entity) {
        log.info("Actualizando tipo de documento con id: {}", id);
        DocTipo existing = findById(id);
        existing.setCodigo(entity.getCodigo());
        existing.setNombre(entity.getNombre());
        existing.setSunatCodigo(entity.getSunatCodigo());
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        DocTipo updated = repository.save(existing);
        log.info("DocTipo actualizado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "doc_tipo", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando tipo de documento con id: {}", id);
        findById(id);
        repository.deleteById(id);
        log.info("DocTipo eliminado exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "doc_tipo", "operation", "activate"})
    @Override
    @Transactional
    public DocTipo activate(Long id) {
        log.info("Activando tipo de documento con id: {}", id);
        DocTipo existing = findById(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "doc_tipo", "operation", "deactivate"})
    @Override
    @Transactional
    public DocTipo deactivate(Long id) {
        log.info("Desactivando tipo de documento con id: {}", id);
        DocTipo existing = findById(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return repository.save(existing);
    }
}
