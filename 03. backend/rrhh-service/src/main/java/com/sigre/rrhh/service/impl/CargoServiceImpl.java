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
import com.sigre.rrhh.dto.request.CargoRequest;
import com.sigre.rrhh.dto.response.CargoResponse;
import com.sigre.rrhh.entity.Cargo;
import com.sigre.rrhh.mapper.CargoMapper;
import com.sigre.rrhh.repository.CargoRepository;
import com.sigre.rrhh.service.CargoService;
import com.sigre.rrhh.specification.CargoSpecification;
import com.sigre.rrhh.validation.CargoValidator;

import java.time.Instant;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CargoServiceImpl implements CargoService {

    private final CargoRepository repository;
    private final CargoValidator validator;
    private final CargoMapper mapper;

    @Timed(value = "app.db.query", extraTags = {"table", "cargo", "operation", "findAll"})
    @Override
    public Page<CargoResponse> listar(Pageable pageable, String nombre, String nivel) {
        Specification<Cargo> spec = null;
        if (nombre != null && !nombre.trim().isEmpty()) {
            spec = CargoSpecification.nombreContains(nombre);
        }
        if (nivel != null && !nivel.trim().isEmpty()) {
            Specification<Cargo> nivelSpec = CargoSpecification.nivelEquals(nivel);
            spec = (spec == null) ? nivelSpec : spec.and(nivelSpec);
        }
        Page<Cargo> page = (spec != null) ? repository.findAll(spec, pageable) : repository.findAll(pageable);
        return page.map(mapper::toResponse);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "cargo", "operation", "findById"})
    @Override
    public CargoResponse obtener(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Timed(value = "app.db.query", extraTags = {"table", "cargo", "operation", "create"})
    @Override
    @Transactional
    public CargoResponse crear(CargoRequest request) {
        validator.validarNombreUnico(request.getNombre(), null);
        validator.validarBandaSalarial(request);
        Cargo entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        Cargo saved = repository.save(entity);
        return mapper.toResponse(saved);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "cargo", "operation", "update"})
    @Override
    @Transactional
    public CargoResponse actualizar(Long id, CargoRequest request) {
        Cargo existing = buscarOrThrow(id);
        validator.validarNombreUnico(request.getNombre(), id);
        validator.validarBandaSalarial(request);
        mapper.updateEntity(request, existing);
        Cargo updated = repository.save(existing);
        return mapper.toResponse(updated);
    }

    @Timed(value = "app.db.query", extraTags = {"table", "cargo", "operation", "desactivar"})
    @Override
    @Transactional
    public CargoResponse desactivar(Long id) {
        Cargo existing = buscarOrThrow(id);
        validator.validarSinTrabajadoresAsignados(id);
        existing.setFlagEstado("0");
        existing.setUpdatedBy(TenantContext.getUsuarioId());
        existing.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(existing));
    }

    @Timed(value = "rrhh.cargo.activar")
    @Override
    @Transactional
    public CargoResponse activar(Long id) {
        Cargo cargo = buscarOrThrow(id);
        cargo.setFlagEstado("1");
        cargo.setUpdatedBy(TenantContext.getUsuarioId());
        cargo.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(cargo));
    }

    @Override
    public List<CargoResponse> listarActivos() {
        return mapper.toResponseList(repository.findByFlagEstadoOrderByNombreAsc("1"));
    }

    private Cargo buscarOrThrow(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Cargo", id));
    }
}
