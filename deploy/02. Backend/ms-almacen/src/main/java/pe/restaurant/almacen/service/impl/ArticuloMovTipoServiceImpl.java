package pe.restaurant.almacen.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.almacen.entity.ArticuloMovTipo;
import pe.restaurant.almacen.repository.ArticuloMovTipoRepository;
import pe.restaurant.almacen.service.ArticuloMovTipoService;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ArticuloMovTipoServiceImpl implements ArticuloMovTipoService {

    private final ArticuloMovTipoRepository repository;

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_mov_tipo", "operation", "findAll"})
    @Override
    public List<ArticuloMovTipo> findAll() {
        return repository.findAll();
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_mov_tipo", "operation", "findAllPaged"})
    @Override
    public Page<ArticuloMovTipo> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_mov_tipo", "operation", "findById"})
    @Override
    public ArticuloMovTipo findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("ArticuloMovTipo", id));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_mov_tipo", "operation", "findByTipoMov"})
    @Override
    public ArticuloMovTipo findByTipoMov(String tipoMov) {
        return repository.findByTipoMov(tipoMov)
                .orElseThrow(() -> new ResourceNotFoundException("ArticuloMovTipo", "tipoMov", tipoMov));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_mov_tipo", "operation", "create"})
    @Override
    @Transactional
    public ArticuloMovTipo create(ArticuloMovTipo entity) {
        if (repository.existsByTipoMov(entity.getTipoMov())) {
            throw new BusinessException("Ya existe un tipo de movimiento con código " + entity.getTipoMov());
        }
        validateTipoMovDev(entity);
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_mov_tipo", "operation", "update"})
    @Override
    @Transactional
    public ArticuloMovTipo update(Long id, ArticuloMovTipo entity) {
        findById(id);
        if (entity.getTipoMov() != null && repository.existsByTipoMovAndIdNot(entity.getTipoMov(), id)) {
            throw new BusinessException("Ya existe un tipo de movimiento con código " + entity.getTipoMov());
        }
        validateTipoMovDev(entity);
        entity.setId(id);
        return repository.save(entity);
    }

    private void validateTipoMovDev(ArticuloMovTipo entity) {
        if (entity.getTipoMovDev() == null || entity.getTipoMovDev().isBlank()) {
            return;
        }
        String code = entity.getTipoMov() == null ? null : entity.getTipoMov().trim();
        String dev = entity.getTipoMovDev().trim();
        if (code != null && code.equalsIgnoreCase(dev)) {
            throw new BusinessException(
                    "tipo_mov_dev no puede ser el mismo código que tipo_mov (auto-referencia no permitida).");
        }
        repository.findByTipoMov(dev)
                .orElseThrow(() -> new ResourceNotFoundException("ArticuloMovTipo", "tipoMovDev", dev));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_mov_tipo", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        if (!repository.existsById(id)) {
            throw new ResourceNotFoundException("ArticuloMovTipo", id);
        }
        repository.deleteById(id);
    }
}
