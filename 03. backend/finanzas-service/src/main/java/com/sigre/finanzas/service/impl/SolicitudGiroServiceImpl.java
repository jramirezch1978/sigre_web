package com.sigre.finanzas.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.finanzas.constants.SolicitudGiroConstants;
import com.sigre.finanzas.dto.request.AprobarSolicitudRequest;
import com.sigre.finanzas.dto.request.DevolucionTotalRequest;
import com.sigre.finanzas.dto.request.RechazoDevolucionTotalRequest;
import com.sigre.finanzas.dto.request.RechazarSolicitudRequest;
import com.sigre.finanzas.dto.request.SolicitudGiroRequest;
import com.sigre.finanzas.dto.response.*;
import com.sigre.finanzas.entity.SolicitudGiro;
import com.sigre.finanzas.mapper.SolicitudGiroMapper;
import com.sigre.finanzas.repository.SolicitudGiroRepository;
import com.sigre.finanzas.service.FinanzasErrorCodes;
import com.sigre.finanzas.service.SolicitudGiroService;
import com.sigre.common.service.NumeradorDocumentoService;

import jakarta.persistence.criteria.Predicate;
import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;
import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class SolicitudGiroServiceImpl implements SolicitudGiroService {

    private final SolicitudGiroRepository repository;
    private final SolicitudGiroMapper mapper;
    private final NumeradorDocumentoService numeradorDocumentoService;

    @Override
    @Transactional(readOnly = true)
    public Page<SolicitudGiroResponse> listarSolicitudes(
            LocalDate fechaDesde,
            LocalDate fechaHasta,
            String estado,
            Pageable pageable) {

        Specification<SolicitudGiro> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (fechaDesde != null) {
                predicates.add(cb.greaterThanOrEqualTo(root.get("fecha"), fechaDesde));
            }

            if (fechaHasta != null) {
                predicates.add(cb.lessThanOrEqualTo(root.get("fecha"), fechaHasta));
            }

            if (estado != null && !estado.isBlank()) {
                predicates.add(cb.equal(root.get("flagEstado"), estado));
            }

            return cb.and(predicates.toArray(new Predicate[0]));
        };

        Page<SolicitudGiro> page = repository.findAll(spec, pageable);

        return page.map(mapper::toResponse);
    }

    @Override
    @Transactional(readOnly = true)
    public SolicitudGiroDetalleResponse obtenerPorId(Long id) {
        SolicitudGiro solicitud = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("SolicitudGiro", id));

        return mapper.toDetalleResponse(solicitud);
    }

    @Override
    public SolicitudGiroDetalleResponse crearSolicitud(SolicitudGiroRequest request) {
        validarMonto(request.getMonto());

        String numero = numeradorDocumentoService.siguienteNroDocumento(
            "finanzas.solicitud_giro",
            request.getSucursalId(),
            request.getFecha().getYear()
        );

        SolicitudGiro solicitud = mapper.toEntity(request);
        solicitud.setNumero(numero);
        solicitud.setFlagEstado(SolicitudGiroConstants.FLAG_PENDIENTE);
        if (solicitud.getTipoSolicitud() == null || solicitud.getTipoSolicitud().isBlank()) {
            solicitud.setTipoSolicitud(SolicitudGiroConstants.TIPO_ORDEN_GIRO);
        }

        if (request.getSolicitanteId() != null) {
            solicitud.setSolicitanteId(request.getSolicitanteId());
            solicitud.setCreatedBy(request.getSolicitanteId());
        } else {
            solicitud.setCreatedBy(com.sigre.common.security.TenantContext.getUsuarioId());
        }

        solicitud = repository.save(solicitud);

        return mapper.toDetalleResponse(solicitud);
    }

    @Override
    public SolicitudGiroDetalleResponse actualizarSolicitud(Long id, SolicitudGiroRequest request) {
        SolicitudGiro solicitud = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("SolicitudGiro", id));

        validarEstadoEditable(solicitud.getFlagEstado());
        validarMonto(request.getMonto());

        solicitud.setSolicitanteId(request.getSolicitanteId());
        solicitud.setFecha(request.getFecha());
        solicitud.setMonto(request.getMonto());
        solicitud.setMotivo(request.getMotivo());
        if (request.getTipoSolicitud() != null && !request.getTipoSolicitud().isBlank()) {
            solicitud.setTipoSolicitud(request.getTipoSolicitud());
        }
        if (request.getCentrosCostoId() != null) {
            solicitud.setCentrosCostoId(request.getCentrosCostoId());
        }
        solicitud.setUpdatedBy(com.sigre.common.security.TenantContext.getUsuarioId());

        solicitud = repository.save(solicitud);

        return mapper.toDetalleResponse(solicitud);
    }

    @Override
    public Map<String, Object> anularSolicitud(Long id) {
        SolicitudGiro solicitud = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("SolicitudGiro", id));

        validarEstadoAnulable(solicitud.getFlagEstado());

        solicitud.setFlagEstado(SolicitudGiroConstants.FLAG_ANULADA);
        solicitud.setUpdatedBy(com.sigre.common.security.TenantContext.getUsuarioId());

        solicitud = repository.save(solicitud);

        Map<String, Object> response = new HashMap<>();
        response.put("id", solicitud.getId());
        response.put("flagEstado", solicitud.getFlagEstado());
        response.put("updatedBy", solicitud.getUpdatedBy());
        response.put("fecModificacion", solicitud.getFecModificacion());

        return response;
    }

    private void validarMonto(BigDecimal monto) {
        if (monto == null || monto.compareTo(BigDecimal.ZERO) <= 0) {
            throw new BusinessException(
                "El monto debe ser mayor a cero",
                FinanzasErrorCodes.SOLICITUD_MONTO_INVALIDO
            );
        }
    }

    private void validarEstadoEditable(String flagEstado) {
        if (!SolicitudGiroConstants.FLAG_PENDIENTE.equals(flagEstado)) {
            throw new BusinessException(
                "No se puede modificar: solicitud no está pendiente de aprobación",
                FinanzasErrorCodes.SOLICITUD_NO_EDITABLE
            );
        }
    }

    private void validarEstadoAnulable(String flagEstado) {
        if (SolicitudGiroConstants.FLAG_ANULADA.equals(flagEstado)) {
            throw new BusinessException(
                "Solicitud ya anulada",
                FinanzasErrorCodes.SOLICITUD_NO_ANULABLE
            );
        }

        if (SolicitudGiroConstants.FLAG_APROBADA.equals(flagEstado)) {
            throw new BusinessException(
                "No se puede anular: solicitud ya aprobada",
                FinanzasErrorCodes.SOLICITUD_NO_ANULABLE
            );
        }
    }

    @Override
    @Transactional(readOnly = true)
    public Page<SolicitudPendienteAprobacionResponse> listarPendientesAprobacion(Pageable pageable) {
        Specification<SolicitudGiro> spec = (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();
            predicates.add(cb.equal(root.get("flagEstado"), SolicitudGiroConstants.FLAG_PENDIENTE));
            return cb.and(predicates.toArray(new Predicate[0]));
        };

        Page<SolicitudGiro> page = repository.findAll(spec, pageable);

        return page.map(entity -> {
            SolicitudPendienteAprobacionResponse response = new SolicitudPendienteAprobacionResponse();
            response.setId(entity.getId());
            response.setSolicitanteId(entity.getSolicitanteId());
            response.setNumero(entity.getNumero());
            response.setFecha(entity.getFecha());
            response.setMonto(entity.getMonto());
            response.setMotivo(entity.getMotivo());
            response.setFlagEstado(entity.getFlagEstado());
            response.setCreatedBy(entity.getCreatedBy());
            response.setFecCreacion(entity.getFecCreacion());
            response.setUpdatedBy(entity.getUpdatedBy());
            response.setFecModificacion(entity.getFecModificacion());
            return response;
        });
    }

    @Override
    public SolicitudGiroDetalleResponse aprobarSolicitud(Long id, AprobarSolicitudRequest request) {
        SolicitudGiro solicitud = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("SolicitudGiro", id));

        if (!SolicitudGiroConstants.FLAG_PENDIENTE.equals(solicitud.getFlagEstado())) {
            throw new BusinessException(
                "Solo se pueden aprobar solicitudes pendientes de aprobación",
                FinanzasErrorCodes.SOLICITUD_ESTADO_INVALIDO
            );
        }

        Long usuarioId = com.sigre.common.security.TenantContext.getUsuarioId();
        solicitud.setFlagEstado(SolicitudGiroConstants.FLAG_APROBADA);
        solicitud.setAprobadorId(usuarioId);
        solicitud.setFecAprobacion(Instant.now());
        solicitud.setUpdatedBy(usuarioId);
        solicitud = repository.save(solicitud);

        return mapper.toDetalleResponse(solicitud);
    }

    @Override
    public Map<String, Object> rechazarSolicitud(Long id, RechazarSolicitudRequest request) {
        SolicitudGiro solicitud = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("SolicitudGiro", id));

        if (!SolicitudGiroConstants.FLAG_PENDIENTE.equals(solicitud.getFlagEstado())) {
            throw new BusinessException(
                "Solo se pueden rechazar solicitudes pendientes de aprobación",
                FinanzasErrorCodes.SOLICITUD_ESTADO_INVALIDO
            );
        }

        Long usuarioId = com.sigre.common.security.TenantContext.getUsuarioId();
        solicitud.setFlagEstado(SolicitudGiroConstants.FLAG_ANULADA);
        solicitud.setMotivoRechazo(request.getObservacion());
        solicitud.setFecRechazo(Instant.now());
        solicitud.setUpdatedBy(usuarioId);
        solicitud = repository.save(solicitud);

        Map<String, Object> response = new HashMap<>();
        response.put("id", solicitud.getId());
        response.put("flagEstado", solicitud.getFlagEstado());
        response.put("updatedBy", solicitud.getUpdatedBy());
        response.put("fecModificacion", solicitud.getFecModificacion());

        return response;
    }

    // ========== FI333 - DEVOLUCIÓN TOTAL (Escenario 1) ==========

    @Override
    @Transactional
    public SolicitudGiroDetalleResponse registrarDevolucionTotal(Long id, DevolucionTotalRequest request) {
        SolicitudGiro solicitud = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("SolicitudGiro", id));

        if (!SolicitudGiroConstants.FLAG_APROBADA.equals(solicitud.getFlagEstado())) {
            throw new BusinessException(
                "Solo se puede registrar devolución total en solicitudes aprobadas",
                FinanzasErrorCodes.SOLICITUD_ESTADO_INVALIDO
            );
        }

        if (solicitud.getMotivoDevolucion() != null) {
            throw new BusinessException(
                "La solicitud ya tiene una devolución registrada",
                "FIN-DEVOLUCION_YA_REGISTRADA"
            );
        }

        Long usuarioId = com.sigre.common.security.TenantContext.getUsuarioId();
        solicitud.setMotivoDevolucion(request.getMotivoDevolucion());
        solicitud.setFlagEstadoDevolucion(null);
        solicitud.setUpdatedBy(usuarioId);
        solicitud = repository.save(solicitud);

        return mapper.toDetalleResponse(solicitud);
    }

    @Override
    @Transactional
    public SolicitudGiroDetalleResponse aprobarDevolucionTotal(Long id) {
        SolicitudGiro solicitud = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("SolicitudGiro", id));

        if (solicitud.getMotivoDevolucion() == null || solicitud.getMotivoDevolucion().isBlank()) {
            throw new BusinessException(
                "No existe motivo de devolución registrado",
                "FIN-DEVOLUCION_SIN_MOTIVO"
            );
        }

        if (solicitud.getFlagEstadoDevolucion() != null) {
            throw new BusinessException(
                "La devolución ya fue procesada",
                "FIN-DEVOLUCION_YA_PROCESADA"
            );
        }

        Long usuarioId = com.sigre.common.security.TenantContext.getUsuarioId();
        solicitud.setFlagEstadoDevolucion(SolicitudGiroConstants.DEVOLUCION_APROBADA);
        solicitud.setAprobadorDevolucionId(usuarioId);
        solicitud.setFecAprobacionDevolucion(Instant.now());
        solicitud.setUpdatedBy(usuarioId);
        solicitud = repository.save(solicitud);

        return mapper.toDetalleResponse(solicitud);
    }

    @Override
    @Transactional
    public SolicitudGiroDetalleResponse rechazarDevolucionTotal(Long id, RechazoDevolucionTotalRequest request) {
        SolicitudGiro solicitud = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("SolicitudGiro", id));

        if (solicitud.getMotivoDevolucion() == null || solicitud.getMotivoDevolucion().isBlank()) {
            throw new BusinessException(
                "No existe motivo de devolución registrado",
                "FIN-DEVOLUCION_SIN_MOTIVO"
            );
        }

        if (solicitud.getFlagEstadoDevolucion() != null) {
            throw new BusinessException(
                "La devolución ya fue procesada",
                "FIN-DEVOLUCION_YA_PROCESADA"
            );
        }

        Long usuarioId = com.sigre.common.security.TenantContext.getUsuarioId();
        solicitud.setFlagEstadoDevolucion(SolicitudGiroConstants.DEVOLUCION_RECHAZADA);
        solicitud.setAprobadorDevolucionId(usuarioId);
        solicitud.setFecRechazoDevolucion(Instant.now());
        solicitud.setMotivoRechazoDevolucion(request.getMotivoRechazo());
        solicitud.setUpdatedBy(usuarioId);
        solicitud = repository.save(solicitud);

        return mapper.toDetalleResponse(solicitud);
    }
}
