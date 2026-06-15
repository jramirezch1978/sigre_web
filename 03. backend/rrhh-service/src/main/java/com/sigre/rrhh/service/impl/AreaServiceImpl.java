package com.sigre.rrhh.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.rrhh.dto.request.AreaRequest;
import com.sigre.rrhh.dto.response.AreaResponse;
import com.sigre.rrhh.dto.response.AreaTreeResponse;
import com.sigre.rrhh.entity.Area;
import com.sigre.rrhh.mapper.AreaMapper;
import com.sigre.rrhh.repository.AreaRepository;
import com.sigre.rrhh.service.AreaService;
import com.sigre.rrhh.specification.AreaSpecification;
import com.sigre.rrhh.validation.AreaValidator;

import java.time.Instant;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AreaServiceImpl implements AreaService {

    private final AreaRepository repository;
    private final AreaValidator validator;
    private final AreaMapper mapper;

    @Timed(value = "app.db.query", extraTags = {"table", "area", "operation", "findAll"})
    @Override
    public Page<AreaResponse> listar(Pageable pageable, String nombre, Long padreId, String flagEstado) {
        Specification<Area> spec = Specification.where(null);

        if (nombre != null && !nombre.trim().isEmpty()) {
            spec = spec.and(AreaSpecification.nombreContains(nombre));
        }

        if (padreId != null) {
            spec = spec.and(AreaSpecification.padreIdEquals(padreId));
        }

        if (flagEstado != null && !flagEstado.isBlank()) {
            spec = spec.and((root, query, cb) -> cb.equal(root.get("flagEstado"), flagEstado));
        }

        Page<Area> page = repository.findAll(spec, pageable);
        return page.map(mapper::toResponse);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "area", "operation", "findById"})
    @Override
    public AreaResponse obtener(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "area", "operation", "create"})
    @Override
    @Transactional
    public AreaResponse crear(AreaRequest request) {
        validator.validarNombreUnico(request.getNombre(), request.getPadreId(), null);

        Area entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        Area saved = repository.save(entity);
        return mapper.toResponse(saved);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "area", "operation", "update"})
    @Override
    @Transactional
    public AreaResponse actualizar(Long id, AreaRequest request) {
        Area existing = buscarOrThrow(id);

        validator.validarNombreUnico(request.getNombre(), request.getPadreId(), id);
        validator.validarSinCiclos(id, request.getPadreId());

        mapper.updateEntity(request, existing);
        Area updated = repository.save(existing);
        return mapper.toResponse(updated);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "area", "operation", "activar"})
    @Override
    @Transactional
    public AreaResponse activar(Long id) {
        Area existing = buscarOrThrow(id);
        existing.setFlagEstado("1");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "area", "operation", "desactivar"})
    @Override
    @Transactional
    public AreaResponse desactivar(Long id) {
        Area existing = buscarOrThrow(id);
        validator.validarSinHijos(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "area", "operation", "tree"})
    @Override
    public List<AreaTreeResponse> obtenerArbolJerarquico() {
        List<Area> roots = repository.findRootAreas();
        return roots.stream()
                .map(this::construirArbol)
                .collect(Collectors.toList());
    }

    private Area buscarOrThrow(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Area", id));
    }

    private AreaTreeResponse construirArbol(Area area) {
        AreaTreeResponse node = mapper.toTreeResponse(area);
        List<Area> hijos = repository.findByPadreId(area.getId());
        node.setHijos(hijos.stream()
                .map(this::construirArbol)
                .collect(Collectors.toList()));
        return node;
    }
}
