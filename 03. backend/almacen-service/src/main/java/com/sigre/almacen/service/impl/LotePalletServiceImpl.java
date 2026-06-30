package com.sigre.almacen.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.almacen.entity.LotePallet;
import com.sigre.almacen.repository.LotePalletRepository;
import com.sigre.almacen.service.LotePalletService;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class LotePalletServiceImpl implements LotePalletService {

    private final LotePalletRepository repository;
    private final JdbcTemplate jdbcTemplate;

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "lote_pallet", "operation", "buscar"})
    public Page<LotePallet> buscar(Long articuloId, Pageable pageable) {
        return repository.findFiltrado(articuloId, pageable);
    }

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "lote_pallet", "operation", "findById"})
    public LotePallet findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("LotePallet", id));
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "lote_pallet", "operation", "create"})
    public LotePallet create(LotePallet entity) {
        assertArticuloExiste(entity.getArticuloId());
        validarUqLote(null, entity.getArticuloId(), entity.getNroLote());
        if (entity.getFlagEstado() == null) {
            entity.setFlagEstado("1");
        }
        return repository.save(entity);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "lote_pallet", "operation", "update"})
    public LotePallet update(Long id, LotePallet entity) {
        LotePallet existing = findById(id);
        assertArticuloExiste(entity.getArticuloId());
        validarUqLote(id, entity.getArticuloId(), entity.getNroLote());
        existing.setArticuloId(entity.getArticuloId());
        existing.setNroLote(entity.getNroLote());
        existing.setFechaProduccion(entity.getFechaProduccion());
        existing.setFechaVencimiento(entity.getFechaVencimiento());
        existing.setObservacion(entity.getObservacion());
        if (entity.getFlagEstado() != null) {
            existing.setFlagEstado(entity.getFlagEstado());
        }
        return repository.save(existing);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "lote_pallet", "operation", "activate"})
    public LotePallet activate(Long id) {
        LotePallet e = findById(id);
        e.setFlagEstado("1");
        return repository.save(e);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "lote_pallet", "operation", "deactivate"})
    public LotePallet deactivate(Long id) {
        LotePallet e = findById(id);
        e.setFlagEstado("0");
        return repository.save(e);
    }

    private void assertArticuloExiste(Long articuloId) {
        Integer c = jdbcTemplate.queryForObject(
                "SELECT COUNT(*)::int FROM core.articulo WHERE id = ?",
                Integer.class,
                articuloId);
        if (c == null || c == 0) {
            throw new ResourceNotFoundException("Articulo", articuloId);
        }
    }

    private void validarUqLote(Long idExcluir, Long articuloId, String nroLote) {
        boolean dup = (idExcluir == null)
                ? repository.existsByArticuloIdAndNroLoteIgnoreCase(articuloId, nroLote)
                : repository.existsByArticuloIdAndNroLoteIgnoreCaseAndIdNot(
                articuloId, nroLote, idExcluir);
        if (dup) {
            throw new BusinessException(
                    "Ya existe un lote con el mismo número para este artículo.",
                    HttpStatus.CONFLICT,
                    "LOTE_PALLET_DUPLICADO");
        }
    }
}
