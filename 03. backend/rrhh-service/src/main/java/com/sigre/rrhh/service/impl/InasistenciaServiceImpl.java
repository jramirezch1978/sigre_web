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
import com.sigre.rrhh.constants.InasistenciaConstants;
import com.sigre.rrhh.dto.request.InasistenciaCreateRequest;
import com.sigre.rrhh.dto.request.InasistenciaRegularizarRequest;
import com.sigre.rrhh.dto.request.InasistenciaUpdateRequest;
import com.sigre.rrhh.dto.response.InasistenciaResponse;
import com.sigre.rrhh.entity.Inasistencia;
import com.sigre.rrhh.mapper.InasistenciaMapper;
import com.sigre.rrhh.repository.InasistenciaRepository;
import com.sigre.rrhh.service.InasistenciaService;
import com.sigre.rrhh.specification.InasistenciaSpecification;

import java.time.Instant;
import java.time.LocalDate;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class InasistenciaServiceImpl implements InasistenciaService {

    private final InasistenciaRepository repository;
    private final InasistenciaMapper mapper;

    @Override
    @Timed("rrhh.inasistencia.listar")
    public Page<InasistenciaResponse> listar(Long trabajadorId, LocalDate fechaDesde, LocalDate fechaHasta,
                                             String flagEstado, Pageable pageable) {
        return repository.findAll(
                        InasistenciaSpecification.filtros(trabajadorId, fechaDesde, fechaHasta, flagEstado),
                        pageable)
                .map(mapper::toResponse);
    }

    @Override
    @Timed("rrhh.inasistencia.obtener")
    public InasistenciaResponse obtenerPorId(Long id) {
        return mapper.toResponse(buscarOrThrow(id));
    }

    @Override
    @Transactional
    @Timed("rrhh.inasistencia.crear")
    public InasistenciaResponse crear(InasistenciaCreateRequest request) {
        validarTrabajador(request.getTrabajadorId());
        validarConceptoPlanilla(request.getConceptoPlanillaId());
        validarDuplicidad(request.getTrabajadorId(), request.getFechaDesde(), null);

        Inasistencia entity = mapper.toEntity(request);
        if (entity.getFlagEstado() == null || entity.getFlagEstado().isBlank()) {
            entity.setFlagEstado(InasistenciaConstants.ESTADO_REGISTRADO);
        }
        entity.setCreatedBy(TenantContext.getUsuarioId());
        entity.setFecCreacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    @Transactional
    @Timed("rrhh.inasistencia.actualizar")
    public InasistenciaResponse actualizar(Long id, InasistenciaUpdateRequest request) {
        Inasistencia entity = buscarOrThrow(id);
        validarModificable(entity);
        validarConceptoPlanilla(request.getConceptoPlanillaId());

        LocalDate fechaDesde = request.getFechaDesde() != null ? request.getFechaDesde() : entity.getFechaDesde();
        if (request.getFechaDesde() != null) {
            validarDuplicidad(entity.getTrabajadorId(), fechaDesde, id);
        }

        mapper.updateEntity(entity, request);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    @Transactional
    @Timed("rrhh.inasistencia.aprobar")
    public InasistenciaResponse aprobar(Long id) {
        Inasistencia entity = buscarOrThrow(id);
        entity.setFlagEstado(InasistenciaConstants.ESTADO_JUSTIFICADA);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    @Transactional
    @Timed("rrhh.inasistencia.rechazar")
    public InasistenciaResponse rechazar(Long id) {
        Inasistencia entity = buscarOrThrow(id);
        entity.setFlagEstado(InasistenciaConstants.ESTADO_INJUSTIFICADA);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    @Transactional
    @Timed("rrhh.inasistencia.anular")
    public InasistenciaResponse anular(Long id) {
        Inasistencia entity = buscarOrThrow(id);
        entity.setFlagEstado(InasistenciaConstants.ESTADO_ANULADA);
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    @Transactional
    @Timed("rrhh.inasistencia.regularizar")
    public InasistenciaResponse regularizar(Long id, InasistenciaRegularizarRequest request) {
        Inasistencia entity = buscarOrThrow(id);
        if (request.getFechaHasta() != null) {
            entity.setFechaHasta(request.getFechaHasta());
        }
        if (request.getDiasInasistencia() != null) {
            entity.setDiasInasistencia(request.getDiasInasistencia());
        }
        if (request.getFlagEstado() != null && !request.getFlagEstado().isBlank()) {
            entity.setFlagEstado(request.getFlagEstado());
        }
        entity.setUpdatedBy(TenantContext.getUsuarioId());
        entity.setFecModificacion(Instant.now());
        return mapper.toResponse(repository.save(entity));
    }

    @Override
    @Transactional
    @Timed("rrhh.inasistencia.desactivar")
    public InasistenciaResponse desactivar(Long id) {
        return anular(id);
    }

    private Inasistencia buscarOrThrow(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Inasistencia", id));
    }

    private void validarTrabajador(Long trabajadorId) {
        if (!repository.existsTrabajadorVigenteById(trabajadorId)) {
            throw new BusinessException(
                    "Trabajador no vigente (activo y sin fecha de cese) con ID: " + trabajadorId,
                    HttpStatus.UNPROCESSABLE_ENTITY, "RH-IN-001");
        }
    }

    private void validarConceptoPlanilla(Long conceptoPlanillaId) {
        if (conceptoPlanillaId != null && !repository.existsConceptoPlanillaById(conceptoPlanillaId)) {
            throw new BusinessException("Concepto de planilla no encontrado con ID: " + conceptoPlanillaId,
                    HttpStatus.UNPROCESSABLE_ENTITY, "RH-IN-002");
        }
    }

    private void validarDuplicidad(Long trabajadorId, LocalDate fechaDesde, Long excluirId) {
        boolean duplicada = excluirId == null
                ? repository.existsByTrabajadorIdAndFechaDesdeAndFlagEstadoNot(
                        trabajadorId, fechaDesde, InasistenciaConstants.ESTADO_ANULADA)
                : repository.existsByTrabajadorIdAndFechaDesdeAndFlagEstadoNotAndIdNot(
                        trabajadorId, fechaDesde, InasistenciaConstants.ESTADO_ANULADA, excluirId);
        if (duplicada) {
            throw new BusinessException(InasistenciaConstants.MSG_DUPLICADA,
                    HttpStatus.CONFLICT, "RH-IN-004");
        }
    }

    private void validarModificable(Inasistencia entity) {
        if (InasistenciaConstants.ESTADO_ANULADA.equals(entity.getFlagEstado())) {
            throw new BusinessException("No se puede modificar una inasistencia anulada",
                    HttpStatus.BAD_REQUEST, "RH-IN-005");
        }
    }
}
