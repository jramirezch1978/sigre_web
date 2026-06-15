package com.sigre.rrhh.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.rrhh.dto.request.AdminAfpRequest;
import com.sigre.rrhh.dto.response.AdminAfpResponse;
import com.sigre.rrhh.entity.AdminAfp;
import com.sigre.rrhh.mapper.AdminAfpMapper;
import com.sigre.rrhh.repository.AdminAfpRepository;
import com.sigre.rrhh.repository.TrabajadorRepository;
import com.sigre.rrhh.service.AdminAfpService;

import java.time.Instant;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class AdminAfpServiceImpl implements AdminAfpService {

    private final AdminAfpRepository repository;
    private final TrabajadorRepository trabajadorRepository;
    private final AdminAfpMapper mapper;

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "admin_afp", "operation", "listar"})
    public Page<AdminAfpResponse> listar(String nombre, String flagEstado, Pageable pageable) {
        var spec = org.springframework.data.jpa.domain.Specification.where(
                (jakarta.persistence.criteria.Root<AdminAfp> root, jakarta.persistence.criteria.CriteriaQuery<?> query, jakarta.persistence.criteria.CriteriaBuilder cb) -> {
                    var predicates = new java.util.ArrayList<jakarta.persistence.criteria.Predicate>();
                    if (nombre != null && !nombre.isBlank()) {
                        predicates.add(cb.like(cb.lower(root.get("nombre")), "%" + nombre.toLowerCase() + "%"));
                    }
                    if (flagEstado != null && !flagEstado.isBlank()) {
                        predicates.add(cb.equal(root.get("flagEstado"), flagEstado));
                    }
                    return cb.and(predicates.toArray(new jakarta.persistence.criteria.Predicate[0]));
                });
        return repository.findAll(spec, pageable).map(mapper::toResponse);
    }

    @Override
    public List<AdminAfpResponse> listarActivos() {
        return mapper.toResponseList(repository.findByFlagEstadoOrderByNombreAsc("1"));
    }

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "admin_afp", "operation", "obtener"})
    public AdminAfpResponse obtenerPorId(Long id) {
        AdminAfp afp = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("AdminAfp", id));
        return mapper.toResponse(afp);
    }

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "admin_afp", "operation", "crear"})
    @Transactional
    public AdminAfpResponse crear(AdminAfpRequest request) {
        validarNombreUnico(request.getNombre(), null);
        AdminAfp afp = mapper.toEntity(request);
        afp.setCreatedBy(TenantContext.getUsuarioId());
        afp.setFecCreacion(Instant.now());
        AdminAfp saved = repository.save(afp);
        return mapper.toResponse(saved);
    }

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "admin_afp", "operation", "actualizar"})
    @Transactional
    public AdminAfpResponse actualizar(Long id, AdminAfpRequest request) {
        AdminAfp existing = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("AdminAfp", id));

        validarNombreUnico(request.getNombre(), id);

        mapper.updateEntity(request, existing);
        AdminAfp updated = repository.save(existing);
        return mapper.toResponse(updated);
    }

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "admin_afp", "operation", "desactivar"})
    @Transactional
    public AdminAfpResponse desactivar(Long id) {
        AdminAfp afp = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("AdminAfp", id));

        boolean tieneAsignados = trabajadorRepository.existsTrabajadoresByAdminAfpId(id);
        if (tieneAsignados) {
            throw new BusinessException(
                    "No se puede desactivar una AFP con colaboradores asignados.",
                    HttpStatus.CONFLICT,
                    "RH-AF-004");
        }

        afp.setFlagEstado("0");
        afp.setUpdatedBy(TenantContext.getUsuarioId());
        afp.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(afp));
    }

    @Override
    @Timed(value = "app.db.query", extraTags = {"table", "admin_afp", "operation", "activar"})
    @Transactional
    public AdminAfpResponse activar(Long id) {
        AdminAfp afp = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("AdminAfp", id));
        afp.setFlagEstado("1");
        afp.setUpdatedBy(TenantContext.getUsuarioId());
        afp.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(afp));
    }

    private void validarNombreUnico(String nombre, Long idExcluir) {
        boolean existe;
        if (idExcluir == null) {
            existe = repository.existsByNombreIgnoreCase(nombre);
        } else {
            existe = repository.existsByNombreIgnoreCaseAndIdNot(nombre, idExcluir);
        }

        if (existe) {
            throw new BusinessException(
                    "Ya existe una AFP con ese nombre.",
                    HttpStatus.CONFLICT,
                    "RH-AF-002");
        }
    }
}
