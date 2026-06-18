package pe.restaurant.rrhh.service.impl;

import io.micrometer.core.annotation.Timed;
import java.time.Instant;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.rrhh.dto.request.CapacitacionCreateRequest;
import pe.restaurant.rrhh.dto.request.CapacitacionUpdateRequest;
import pe.restaurant.rrhh.dto.request.CapacitacionTrabajadorRequest;
import pe.restaurant.rrhh.dto.response.CapacitacionResponse;
import pe.restaurant.rrhh.dto.response.CapacitacionTrabajadorResponse;
import pe.restaurant.rrhh.entity.Capacitacion;
import pe.restaurant.rrhh.entity.CapacitacionTrabajador;
import pe.restaurant.rrhh.mapper.CapacitacionMapper;
import pe.restaurant.rrhh.mapper.CapacitacionTrabajadorMapper;
import pe.restaurant.rrhh.repository.CapacitacionRepository;
import pe.restaurant.rrhh.repository.CapacitacionTrabajadorRepository;
import pe.restaurant.rrhh.service.CapacitacionService;
import pe.restaurant.rrhh.specification.CapacitacionSpecification;
import pe.restaurant.rrhh.validation.CapacitacionValidator;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CapacitacionServiceImpl implements CapacitacionService {

    private final CapacitacionRepository repository;
    private final CapacitacionTrabajadorRepository ctRepository;
    private final CapacitacionMapper mapper;
    private final CapacitacionTrabajadorMapper ctMapper;
    private final CapacitacionValidator validator;

    @Override @Timed("rrhh.capacitacion.listar")
    public Page<CapacitacionResponse> listar(String nombre, String flagEstado, Pageable pageable) {
        return repository.findAll(CapacitacionSpecification.filtros(nombre, flagEstado), pageable).map(mapper::toResponse);
    }

    @Override @Timed("rrhh.capacitacion.obtener")
    public CapacitacionResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override @Transactional @Timed("rrhh.capacitacion.crear")
    public CapacitacionResponse crear(CapacitacionCreateRequest request) {
        validator.validarFechas(request.getFechaInicio(), request.getFechaFin());
        var entity = mapper.toEntity(request);
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Transactional @Timed("rrhh.capacitacion.actualizar")
    public CapacitacionResponse actualizar(Long id, CapacitacionUpdateRequest request) {
        var existing = buscarOrThrow(id);
        validator.validarFechas(
                request.getFechaInicio() != null ? request.getFechaInicio() : existing.getFechaInicio(),
                request.getFechaFin() != null ? request.getFechaFin() : existing.getFechaFin());
        mapper.updateEntity(existing, request);
        return mapper.toResponse(repository.save(existing));
    }

    @Override @Transactional @Timed("rrhh.capacitacion.desactivar")
    public CapacitacionResponse desactivar(Long id) {
        var entity = buscarOrThrow(id);
        validator.validarSinParticipantes(id);
        entity.setFlagEstado("0");
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override @Timed("rrhh.capacitacion.listarParticipantes")
    public List<CapacitacionTrabajadorResponse> listarParticipantes(Long capacitacionId) {
        return ctMapper.toResponseList(ctRepository.findByCapacitacionId(capacitacionId));
    }

    @Override @Transactional @Timed("rrhh.capacitacion.agregarParticipante")
    public CapacitacionTrabajadorResponse agregarParticipante(Long capacitacionId, CapacitacionTrabajadorRequest request) {
        buscarOrThrow(capacitacionId);
        validator.validarTrabajador(request.getTrabajadorId());
        validator.validarParticipanteNoDuplicado(capacitacionId, request.getTrabajadorId());
        var ct = ctMapper.toEntity(request);
        ct.setCapacitacionId(capacitacionId);
        ct.setCreatedBy(TenantContext.getUsuarioId());
        ct.setFecCreacion(Instant.now());
        return ctMapper.toResponse(ctRepository.save(ct));
    }

    @Override @Transactional @Timed("rrhh.capacitacion.actualizarParticipante")
    public CapacitacionTrabajadorResponse actualizarParticipante(Long capacitacionId, Long trabajadorId, CapacitacionTrabajadorRequest request) {
        CapacitacionTrabajador ct = ctRepository.findByCapacitacionIdAndTrabajadorId(capacitacionId, trabajadorId)
                .orElseThrow(() -> new ResourceNotFoundException("Participante en capacitación", "capacitacionId y trabajadorId", capacitacionId + "-" + trabajadorId));
        ct.setAsistio(request.getAsistio());
        ct.setCalificacion(request.getCalificacion());
        ct.setCertificado(request.getCertificado());
        ct.setUpdatedBy(TenantContext.getUsuarioId());
        ct.setFecModificacion(Instant.now());
        return ctMapper.toResponse(ctRepository.save(ct));
    }

    @Override @Transactional @Timed("rrhh.capacitacion.eliminarParticipante")
    public void eliminarParticipante(Long capacitacionId, Long trabajadorId) {
        var ct = ctRepository.findByCapacitacionIdAndTrabajadorId(capacitacionId, trabajadorId)
                .orElseThrow(() -> new BusinessException("Participante no encontrado.", HttpStatus.NOT_FOUND, "RH-CP-001"));
        ctRepository.delete(ct);
    }

    private Capacitacion buscarOrThrow(Long id) {
        return repository.findById(id).orElseThrow(() -> {
            log.warn("Capacitación no encontrada: {}", id);
            return new ResourceNotFoundException("Capacitacion", id);
        });
    }
}
