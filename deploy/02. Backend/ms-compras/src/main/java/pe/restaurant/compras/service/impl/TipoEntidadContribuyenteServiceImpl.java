package pe.restaurant.compras.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.compras.entity.TipoEntidadContribuyente;
import pe.restaurant.compras.repository.TipoEntidadContribuyenteRepository;
import pe.restaurant.compras.service.TipoEntidadContribuyenteService;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TipoEntidadContribuyenteServiceImpl implements TipoEntidadContribuyenteService {

    private final TipoEntidadContribuyenteRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "tipo_entidad_contribuyente", "operation", "findAll"})
    @Override
    public Page<TipoEntidadContribuyente> findAll(Pageable pageable) {
        log.info("Listando tipos de entidad contribuyente - page: {}, size: {}",
                pageable.getPageNumber(), pageable.getPageSize());
        Page<TipoEntidadContribuyente> page = repository.findAll(pageable);
        log.info("Tipos de entidad contribuyente encontrados: {}", page.getTotalElements());
        return page;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "tipo_entidad_contribuyente", "operation", "findById"})
    @Override
    public TipoEntidadContribuyente findById(Long id) {
        log.info("Buscando tipo de entidad contribuyente con id: {}", id);
        return repository.findById(id)
                .orElseThrow(() -> {
                    log.warn("Tipo de entidad contribuyente no encontrado con id: {}", id);
                    return new ResourceNotFoundException("TipoEntidadContribuyente", id);
                });
    }

    @Timed(value = "app.db.query", extraTags = {"table", "tipo_entidad_contribuyente", "operation", "create"})
    @Override
    @Transactional
    public TipoEntidadContribuyente create(TipoEntidadContribuyente entity) {
        log.info("Creando tipo de entidad contribuyente, tipo: {}", entity.getTipo());
        validateUnique(entity.getTipo(), null);
        TipoEntidadContribuyente saved = repository.save(entity);
        log.info("Tipo de entidad contribuyente creado exitosamente con id: {}", saved.getId());
        return saved;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "tipo_entidad_contribuyente", "operation", "update"})
    @Override
    @Transactional
    public TipoEntidadContribuyente update(Long id, TipoEntidadContribuyente entity) {
        log.info("Actualizando tipo de entidad contribuyente con id: {}", id);
        findById(id);
        validateUnique(entity.getTipo(), id);
        entity.setId(id);
        TipoEntidadContribuyente updated = repository.save(entity);
        log.info("Tipo de entidad contribuyente actualizado exitosamente con id: {}", id);
        return updated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "tipo_entidad_contribuyente", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        log.info("Eliminando tipo de entidad contribuyente con id: {}", id);
        findById(id);
        repository.deleteById(id);
        log.info("Tipo de entidad contribuyente eliminado exitosamente con id: {}", id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "tipo_entidad_contribuyente", "operation", "activate"})
    @Override
    @Transactional
    public TipoEntidadContribuyente activate(Long id) {
        log.info("Activando tipo de entidad contribuyente con id: {}", id);
        TipoEntidadContribuyente existing = findById(id);
        existing.setFlagEstado("1");
        TipoEntidadContribuyente activated = repository.save(existing);
        log.info("Tipo de entidad contribuyente activado exitosamente con id: {}", id);
        return activated;
    }

    @Timed(value = "app.db.query", extraTags = {"table", "tipo_entidad_contribuyente", "operation", "deactivate"})
    @Override
    @Transactional
    public TipoEntidadContribuyente deactivate(Long id) {
        log.info("Desactivando tipo de entidad contribuyente con id: {}", id);
        TipoEntidadContribuyente existing = findById(id);
        existing.setFlagEstado("0");
        TipoEntidadContribuyente deactivated = repository.save(existing);
        log.info("Tipo de entidad contribuyente desactivado exitosamente con id: {}", id);
        return deactivated;
    }

    private void validateUnique(String tipo, Long excludeId) {
        boolean exists = excludeId == null
                ? repository.existsByTipoIgnoreCase(tipo)
                : repository.existsByTipoIgnoreCaseAndIdNot(tipo, excludeId);
        if (exists) {
            throw new BusinessException(
                    "Ya existe un tipo de entidad contribuyente con el mismo tipo",
                    HttpStatus.CONFLICT, "BUSINESS_ERROR");
        }
    }
}
