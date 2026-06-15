package com.sigre.almacen.service.impl;

import io.micrometer.core.annotation.Timed;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;
import jakarta.persistence.criteria.Subquery;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.almacen.dto.AlmacenTipoMovResponse;
import com.sigre.almacen.entity.AlmacenTipoMov;
import com.sigre.almacen.entity.ArticuloMovTipo;
import com.sigre.almacen.repository.AlmacenRepository;
import com.sigre.almacen.repository.AlmacenTipoMovRepository;
import com.sigre.almacen.repository.ArticuloMovTipoRepository;
import com.sigre.almacen.service.AlmacenTipoMovService;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AlmacenTipoMovServiceImpl implements AlmacenTipoMovService {

    private final AlmacenTipoMovRepository almacenTipoMovRepository;
    private final AlmacenRepository almacenRepository;
    private final ArticuloMovTipoRepository articuloMovTipoRepository;

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "almacen_tipo_mov", "operation", "listar"})
    public Page<AlmacenTipoMovResponse> listarPorAlmacen(Long almacenId, Pageable pageable, String flagEstado, String tipoMov) {
        if (!almacenRepository.existsById(almacenId)) {
            throw new ResourceNotFoundException("Almacen", almacenId);
        }
        Page<AlmacenTipoMov> page = almacenTipoMovRepository.findAll(
                buildSpecification(almacenId, flagEstado, tipoMov), pageable);
        var list = page.getContent().stream().map(this::toResponse).collect(Collectors.toList());
        return new PageImpl<>(list, pageable, page.getTotalElements());
    }

    private Specification<AlmacenTipoMov> buildSpecification(Long almacenId, String flagEstado, String tipoMov) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.equal(root.get("almacenId"), almacenId));
            if (flagEstado != null && !flagEstado.isBlank()) {
                predicates.add(cb.equal(root.get("flagEstado"), flagEstado));
            }
            if (tipoMov != null && !tipoMov.isBlank()) {
                Subquery<Long> sq = query.subquery(Long.class);
                Root<ArticuloMovTipo> t = sq.from(ArticuloMovTipo.class);
                sq.select(t.get("id"));
                sq.where(cb.equal(t.get("tipoMov"), tipoMov));
                predicates.add(root.get("articuloMovTipoId").in(sq));
            }
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "almacen_tipo_mov", "operation", "asignar"})
    public AlmacenTipoMovResponse asignar(Long almacenId, Long articuloMovTipoId) {
        if (!almacenRepository.existsById(almacenId)) {
            throw new ResourceNotFoundException("Almacen", almacenId);
        }
        var tipo = articuloMovTipoRepository
                .findById(articuloMovTipoId)
                .orElseThrow(() -> new ResourceNotFoundException("ArticuloMovTipo", articuloMovTipoId));
        if (!"1".equals(tipo.getFlagEstado())) {
            throw new BusinessException(
                    "El tipo de movimiento no está activo.",
                    HttpStatus.UNPROCESSABLE_ENTITY,
                    "TIPO_MOV_INACTIVO");
        }
        var existingOpt = almacenTipoMovRepository.findByAlmacenIdAndArticuloMovTipoId(almacenId, articuloMovTipoId);
        if (existingOpt.isPresent()) {
            AlmacenTipoMov existing = existingOpt.get();
            if ("1".equals(existing.getFlagEstado())) {
                throw new BusinessException(
                        "Ese tipo de movimiento ya está asignado al almacén.",
                        HttpStatus.CONFLICT,
                        "ALMACEN_TIPO_MOV_DUPLICADO");
            }
            existing.setFlagEstado("1");
            var saved = almacenTipoMovRepository.save(existing);
            return toResponse(saved, tipo);
        }

        var row = new AlmacenTipoMov();
        row.setAlmacenId(almacenId);
        row.setArticuloMovTipoId(articuloMovTipoId);
        row.setFlagEstado("1");
        var saved = almacenTipoMovRepository.save(row);
        return toResponse(saved, tipo);
    }

    @Override
    @Transactional
    @Timed(value = "app.db.query", extraTags = {"table", "almacen_tipo_mov", "operation", "desasignar"})
    public void desasignar(Long almacenId, Long articuloMovTipoId) {
        if (!almacenRepository.existsById(almacenId)) {
            throw new ResourceNotFoundException("Almacen", almacenId);
        }
        var row = almacenTipoMovRepository
                .findByAlmacenIdAndArticuloMovTipoId(almacenId, articuloMovTipoId)
                .orElseThrow(
                        () -> new ResourceNotFoundException(
                                "Asignacion almacen-tipo-mov",
                                "almacenId+articuloMovTipoId",
                                almacenId + "/" + articuloMovTipoId));
        row.setFlagEstado("0");
        almacenTipoMovRepository.save(row);
    }

    private AlmacenTipoMovResponse toResponse(AlmacenTipoMov row) {
        return articuloMovTipoRepository
                .findById(row.getArticuloMovTipoId())
                .map(t -> toResponse(row, t))
                .orElseGet(() -> toResponseRowOnly(row));
    }

    private AlmacenTipoMovResponse toResponseRowOnly(AlmacenTipoMov row) {
        return AlmacenTipoMovResponse.builder()
                .id(row.getId())
                .almacenId(row.getAlmacenId())
                .articuloMovTipoId(row.getArticuloMovTipoId())
                .tipoMov(null)
                .descTipoMov(null)
                .flagEstado(row.getFlagEstado())
                .build();
    }

    private AlmacenTipoMovResponse toResponse(AlmacenTipoMov row, ArticuloMovTipo tipo) {
        return AlmacenTipoMovResponse.builder()
                .id(row.getId())
                .almacenId(row.getAlmacenId())
                .articuloMovTipoId(tipo.getId())
                .tipoMov(tipo.getTipoMov())
                .descTipoMov(tipo.getDescTipoMov())
                .flagEstado(row.getFlagEstado())
                .build();
    }
}
