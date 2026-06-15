package com.sigre.almacen.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.almacen.entity.ArticuloBonificacion;
import com.sigre.almacen.repository.ArticuloBonificacionRepository;
import com.sigre.almacen.service.ArticuloBonificacionService;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ArticuloBonificacionServiceImpl implements ArticuloBonificacionService {

    private final ArticuloBonificacionRepository repository;
    private final JdbcTemplate jdbcTemplate;

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_bonificacion", "operation", "findAll"})
    @Override
    public Page<ArticuloBonificacion> findAll(Long articuloId, Pageable pageable) {
        if (articuloId != null) {
            return repository.findByArticuloId(articuloId, pageable);
        }
        return repository.findAll(pageable);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_bonificacion", "operation", "findById"})
    @Override
    public ArticuloBonificacion findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("ArticuloBonificacion", id));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_bonificacion", "operation", "create"})
    @Override
    @Transactional
    public ArticuloBonificacion create(ArticuloBonificacion entity) {
        assertArticuloExiste(entity.getArticuloId());
        validateFechas(entity);
        validateDuplicado(entity.getArticuloId(), entity.getCantidadMinima(), null);
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_bonificacion", "operation", "update"})
    @Override
    @Transactional
    public ArticuloBonificacion update(Long id, ArticuloBonificacion entity) {
        findById(id);
        assertArticuloExiste(entity.getArticuloId());
        validateFechas(entity);
        validateDuplicado(entity.getArticuloId(), entity.getCantidadMinima(), id);
        entity.setId(id);
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_bonificacion", "operation", "delete"})
    @Override
    @Transactional
    public void delete(Long id) {
        if (!repository.existsById(id)) {
            throw new ResourceNotFoundException("ArticuloBonificacion", id);
        }
        repository.deleteById(id);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_bonificacion", "operation", "activate"})
    @Override
    @Transactional
    public ArticuloBonificacion activate(Long id) {
        ArticuloBonificacion entity = findById(id);
        entity.setFlagEstado("1");
        return repository.save(entity);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "articulo_bonificacion", "operation", "deactivate"})
    @Override
    @Transactional
    public ArticuloBonificacion deactivate(Long id) {
        ArticuloBonificacion entity = findById(id);
        entity.setFlagEstado("0");
        return repository.save(entity);
    }

    private void assertArticuloExiste(Long articuloId) {
        Integer c = jdbcTemplate.queryForObject(
                "SELECT COUNT(*)::int FROM core.articulo WHERE id = ?", Integer.class, articuloId);
        if (c == null || c == 0) {
            throw new ResourceNotFoundException("Articulo", articuloId);
        }
    }

    private void validateFechas(ArticuloBonificacion entity) {
        if (entity.getFechaInicio() != null && entity.getFechaFin() != null
                && entity.getFechaFin().isBefore(entity.getFechaInicio())) {
            throw new BusinessException("fecha_fin no puede ser anterior a fecha_inicio");
        }
    }

    private void validateDuplicado(Long articuloId, java.math.BigDecimal cantidadMinima, Long excludeId) {
        boolean exists;
        if (excludeId != null) {
            exists = repository.existsByArticuloIdAndCantidadMinimaAndIdNot(articuloId, cantidadMinima, excludeId);
        } else {
            exists = repository.existsByArticuloIdAndCantidadMinima(articuloId, cantidadMinima);
        }
        if (exists) {
            throw new BusinessException(
                    "Ya existe una bonificación para este artículo con cantidad mínima " + cantidadMinima);
        }
    }
}
