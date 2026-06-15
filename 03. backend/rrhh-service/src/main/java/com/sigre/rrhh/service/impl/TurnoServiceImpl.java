package com.sigre.rrhh.service.impl;

import io.micrometer.core.annotation.Timed;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.rrhh.dto.request.TurnoRequest;
import com.sigre.rrhh.dto.response.TurnoResponse;
import com.sigre.rrhh.entity.Turno;
import com.sigre.rrhh.mapper.TurnoMapper;
import com.sigre.rrhh.repository.TurnoRepository;
import com.sigre.rrhh.repository.HorarioTrabajadorRepository;
import com.sigre.rrhh.service.TurnoService;

import java.time.Instant;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class TurnoServiceImpl implements TurnoService {

    private final TurnoRepository turnoRepository;
    private final TurnoMapper turnoMapper;
    private final HorarioTrabajadorRepository horarioTrabajadorRepository;

    @Override
    @Timed("rrhh.turno.listar")
    public Page<TurnoResponse> listar(String nombre, String flagEstado, Pageable pageable) {
        var spec = org.springframework.data.jpa.domain.Specification.where(
                (jakarta.persistence.criteria.Root<Turno> root, jakarta.persistence.criteria.CriteriaQuery<?> query, jakarta.persistence.criteria.CriteriaBuilder cb) -> {
                    var predicates = new java.util.ArrayList<jakarta.persistence.criteria.Predicate>();
                    if (nombre != null && !nombre.isBlank()) {
                        predicates.add(cb.like(cb.lower(root.get("nombre")), "%" + nombre.toLowerCase() + "%"));
                    }
                    if (flagEstado != null && !flagEstado.isBlank()) {
                        predicates.add(cb.equal(root.get("flagEstado"), flagEstado));
                    }
                    return cb.and(predicates.toArray(new jakarta.persistence.criteria.Predicate[0]));
                });
        return turnoRepository.findAll(spec, pageable).map(turnoMapper::toResponse);
    }

    @Override
    public List<TurnoResponse> listarActivos() {
        return turnoMapper.toResponseList(turnoRepository.findByFlagEstadoOrderByNombreAsc("1"));
    }

    @Override
    @Timed("rrhh.turno.obtener")
    public TurnoResponse obtenerPorId(Long id) {
        Turno turno = turnoRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Turno", id));
        return turnoMapper.toResponse(turno);
    }

    @Override
    @Transactional
    @Timed("rrhh.turno.crear")
    public TurnoResponse crear(TurnoRequest request) {
        if (turnoRepository.existsByNombreIgnoreCase(request.getNombre())) {
            throw new BusinessException(
                    "Ya existe un turno con ese nombre.",
                    HttpStatus.CONFLICT,
                    "RH-TU-002");
        }

        validarTurno(request);

        Turno turno = turnoMapper.toEntity(request);
        turno.setCreatedBy(TenantContext.getUsuarioId());
        turno.setFecCreacion(Instant.now());
        Turno saved = turnoRepository.save(turno);
        return turnoMapper.toResponse(saved);
    }

    @Override
    @Transactional
    @Timed("rrhh.turno.actualizar")
    public TurnoResponse actualizar(Long id, TurnoRequest request) {
        Turno turno = turnoRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Turno", id));

        if (!turno.getNombre().equalsIgnoreCase(request.getNombre()) &&
            turnoRepository.existsByNombreIgnoreCase(request.getNombre())) {
            throw new BusinessException(
                    "Ya existe un turno con ese nombre.",
                    HttpStatus.CONFLICT,
                    "RH-TU-002");
        }

        validarTurno(request);

        turnoMapper.updateEntity(request, turno);
        turno.setUpdatedBy(TenantContext.getUsuarioId());
        Turno saved = turnoRepository.save(turno);
        return turnoMapper.toResponse(saved);
    }

    @Override
    @Transactional
    @Timed("rrhh.turno.activar")
    public TurnoResponse activar(Long id) {
        Turno turno = turnoRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Turno", id));
        turno.setFlagEstado("1");
        turno.setUpdatedBy(TenantContext.getUsuarioId());
        turno.setFecModificacion(Instant.now());
        return turnoMapper.toResponse(turnoRepository.save(turno));
    }

    @Override
    @Transactional
    @Timed("rrhh.turno.desactivar")
    public TurnoResponse desactivar(Long id) {
        Turno turno = turnoRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Turno", id));

        boolean tieneAsignados = horarioTrabajadorRepository.existsByTurnoIdAndFlagEstado(id, "1");
        if (tieneAsignados) {
            throw new BusinessException(
                    "No se puede desactivar un turno con colaboradores asignados.",
                    HttpStatus.CONFLICT,
                    "RH-TU-004");
        }

        turno.setFlagEstado("0");
        turno.setUpdatedBy(TenantContext.getUsuarioId());
        turno.setFecModificacion(Instant.now());
        return turnoMapper.toResponse(turnoRepository.save(turno));
    }

    private void validarTurno(TurnoRequest request) {
        if (request.getNombre() == null || request.getNombre().isBlank()) {
            throw new BusinessException(
                    "El nombre del turno es obligatorio.",
                    HttpStatus.BAD_REQUEST,
                    "RH-TU-001");
        }

        if (request.getMinutosTolerancia() != null && request.getMinutosTolerancia() < 0) {
            throw new BusinessException(
                    "Los minutos de tolerancia deben ser mayores o iguales a 0.",
                    HttpStatus.BAD_REQUEST,
                    "RH-TU-001");
        }

        boolean algunDiaActivo = Boolean.TRUE.equals(request.getAplicaLunes()) ||
                Boolean.TRUE.equals(request.getAplicaMartes()) ||
                Boolean.TRUE.equals(request.getAplicaMiercoles()) ||
                Boolean.TRUE.equals(request.getAplicaJueves()) ||
                Boolean.TRUE.equals(request.getAplicaViernes()) ||
                Boolean.TRUE.equals(request.getAplicaSabado()) ||
                Boolean.TRUE.equals(request.getAplicaDomingo());
        if (!algunDiaActivo) {
            throw new BusinessException(
                    "El turno debe aplicar al menos a un día de la semana.",
                    HttpStatus.BAD_REQUEST,
                    "RH-TU-003");
        }
    }
}
