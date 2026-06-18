package pe.restaurant.activos.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.activos.entity.AfHistorial;
import pe.restaurant.activos.repository.AfHistorialRepository;
import pe.restaurant.activos.service.AfHistorialService;
import pe.restaurant.activos.util.ActivosFlagEstado;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;

import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AfHistorialServiceImpl implements AfHistorialService {

    private final AfHistorialRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "af_historial", "operation", "findAll"})
    @Override
    public Page<AfHistorial> findAll(Pageable pageable) {
        log.info("Listando historial - page: {}, size: {}", pageable.getPageNumber(), pageable.getPageSize());
        return repository.findAll(pageable);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_historial", "operation", "findById"})
    @Override
    public AfHistorial findById(Long id) {
        log.info("Buscando historial con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Historial", id));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_historial", "operation", "create"})
    @Override
    @Transactional
    public AfHistorial create(AfHistorial entity) {
        log.info("Creando registro de historial para activo: {}", entity.getAfMaestroId());
        
        if (entity.getFechaEvento() == null) {
            entity.setFechaEvento(LocalDateTime.now());
        }
        
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        AfHistorial saved = repository.save(entity);
        log.info("Historial creado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_historial", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando historial con id: {}", id);
        AfHistorial existing = findById(id);
        repository.delete(existing);
        log.info("Historial eliminado exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_historial", "operation", "findByActivo"})
    @Override
    public List<AfHistorial> findByActivo(Long activoId) {
        log.info("Listando historial del activo: {}", activoId);
        return repository.findByAfMaestroIdOrderByFechaEventoDesc(activoId);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_historial", "operation", "findByTipoEvento"})
    @Override
    public List<AfHistorial> findByTipoEvento(String tipoEvento) {
        log.info("Listando historial por tipo de evento: {}", tipoEvento);
        return repository.findByTipoEvento(tipoEvento, Pageable.unpaged()).getContent();
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_historial", "operation", "findByUsuario"})
    @Override
    public List<AfHistorial> findByUsuario(Long usuarioId) {
        log.info("Listando historial del usuario: {}", usuarioId);
        return repository.findByUsuarioId(usuarioId);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "af_historial", "operation", "findByFechaRange"})
    @Override
    public List<AfHistorial> findByFechaRange(LocalDateTime fechaInicio, LocalDateTime fechaFin) {
        log.info("Listando historial entre {} y {}", fechaInicio, fechaFin);
        return repository.findByFechaRange(fechaInicio, fechaFin);
    }
}
