package com.sigre.finanzas.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.finanzas.dto.request.LiquidacionDetalleRequest;
import com.sigre.finanzas.dto.request.LiquidacionRequest;
import com.sigre.finanzas.dto.response.LiquidacionDetalleResponse;
import com.sigre.finanzas.dto.response.LiquidacionResponse;
import com.sigre.finanzas.dto.response.ValidacionCierreResponse;
import com.sigre.finanzas.entity.Liquidacion;
import com.sigre.finanzas.entity.LiquidacionDet;
import com.sigre.finanzas.entity.SolicitudGiro;
import com.sigre.finanzas.mapper.LiquidacionDetMapper;
import com.sigre.finanzas.mapper.LiquidacionMapper;
import com.sigre.finanzas.repository.LiquidacionDetRepository;
import com.sigre.finanzas.repository.LiquidacionRepository;
import com.sigre.finanzas.repository.SolicitudGiroRepository;
import com.sigre.common.service.NumeradorDocumentoService;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class LiquidacionService {

    private final LiquidacionRepository repository;
    private final LiquidacionDetRepository detRepository;
    private final SolicitudGiroRepository solicitudGiroRepository;
    private final LiquidacionMapper mapper;
    private final LiquidacionDetMapper detMapper;
    private final NumeradorDocumentoService numeradorDocumentoService;

    @Transactional(readOnly = true)
    public Page<LiquidacionResponse> listarLiquidaciones(Pageable pageable) {
        Page<Liquidacion> page = repository.findAll(pageable);
        return page.map(mapper::toResponse);
    }

    @Transactional(readOnly = true)
    public LiquidacionDetalleResponse obtenerPorId(Long id) {
        Liquidacion entity = repository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Liquidacion", id));
        return mapper.toDetalleResponse(entity);
    }

    @Transactional
    public LiquidacionDetalleResponse crearLiquidacion(LiquidacionRequest request) {
        validarSolicitudGiro(request.getSolicitudGiroId());
        validarCuadreDetalles(request);
        
        Long sucursalId = request.getSucursalId() != null ? request.getSucursalId() : 
            com.sigre.common.security.TenantContext.getSucursalId();
        
        Long usuarioId = com.sigre.common.security.TenantContext.getUsuarioId();
        
        Liquidacion entity = mapper.toEntity(request);
        
        // Generar número automáticamente solo si no viene del request
        if (entity.getNroLiquidacion() == null || entity.getNroLiquidacion().isEmpty()) {
            String nroLiquidacion = numeradorDocumentoService.siguienteNroDocumento(
                "finanzas.liquidacion",
                sucursalId,
                LocalDate.now().getYear()
            );
            entity.setNroLiquidacion(nroLiquidacion);
        }
        entity.setFechaRegistro(LocalDate.now());
        
        // Establecer campos de auditoría
        entity.setCreatedBy(usuarioId);
        entity.setUpdatedBy(usuarioId);
        
        Liquidacion saved = repository.save(entity);
        
        for (LiquidacionDetalleRequest detalleReq : request.getDetalles()) {
            LiquidacionDet detalle = detMapper.toEntity(detalleReq);
            detalle.setCreatedBy(usuarioId);
            detalle.setUpdatedBy(usuarioId);
            saved.addDetalle(detalle);
        }
        
        repository.save(saved);
        
        return mapper.toDetalleResponse(saved);
    }

    @Transactional
    public LiquidacionDetalleResponse actualizarLiquidacion(Long id, LiquidacionRequest request) {
        Liquidacion entity = repository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Liquidacion", id));
        
        if (!"1".equals(entity.getFlagEstado())) {
            throw new BusinessException(
                "Solo se pueden actualizar liquidaciones activas",
                FinanzasErrorCodes.LIQUIDACION_ESTADO_INVALIDO
            );
        }
        
        validarCuadreDetalles(request);
        
        Long usuarioId = com.sigre.common.security.TenantContext.getUsuarioId();
        
        mapper.updateEntity(entity, request);
        entity.setUpdatedBy(usuarioId);
        
        // Limpiar detalles existentes y forzar flush para evitar conflictos de unicidad
        entity.clearDetalles();
        repository.saveAndFlush(entity);
        
        // Agregar nuevos detalles
        for (LiquidacionDetalleRequest detalleReq : request.getDetalles()) {
            LiquidacionDet detalle = detMapper.toEntity(detalleReq);
            detalle.setCreatedBy(usuarioId);
            detalle.setUpdatedBy(usuarioId);
            entity.addDetalle(detalle);
        }
        
        repository.save(entity);
        
        return mapper.toDetalleResponse(entity);
    }

    @Transactional
    public Map<String, Object> anularLiquidacion(Long id) {
        Liquidacion entity = repository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Liquidacion", id));
        
        if ("2".equals(entity.getFlagEstado())) {
            throw new BusinessException(
                "No se puede anular una liquidación cerrada",
                FinanzasErrorCodes.LIQUIDACION_ESTADO_INVALIDO
            );
        }
        
        entity.setFlagEstado("0");
        entity.setUpdatedBy(com.sigre.common.security.TenantContext.getUsuarioId());
        repository.save(entity);
        
        Map<String, Object> response = new HashMap<>();
        response.put("id", entity.getId());
        response.put("flagEstado", entity.getFlagEstado());
        
        return response;
    }

    @Transactional(readOnly = true)
    public ValidacionCierreResponse validarCierre(Long id) {
        Liquidacion entity = repository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Liquidacion", id));
        
        BigDecimal sumaDetalles = detRepository.calcularSumaImportes(id);
        if (sumaDetalles == null) {
            sumaDetalles = BigDecimal.ZERO;
        }
        
        boolean cuadrado = entity.getImporteNeto().compareTo(sumaDetalles) == 0;
        boolean puedeCerrar = "1".equals(entity.getFlagEstado()) && cuadrado;
        
        SolicitudGiro solicitudGiro = solicitudGiroRepository.findById(entity.getSolicitudGiroId())
            .orElse(null);
        
        ValidacionCierreResponse response = new ValidacionCierreResponse();
        response.setId(entity.getId());
        response.setNroLiquidacion(entity.getNroLiquidacion());
        response.setImporteNeto(entity.getImporteNeto());
        response.setSumaDetalles(sumaDetalles);
        response.setCuadrado(cuadrado);
        response.setSolicitudGiroId(entity.getSolicitudGiroId());
        response.setSolicitudGiroNumero(solicitudGiro != null ? solicitudGiro.getNumero() : null);
        response.setPuedeCerrar(puedeCerrar);
        
        return response;
    }

    @Transactional
    public LiquidacionDetalleResponse cerrarLiquidacion(Long id, String observacion) {
        Liquidacion entity = repository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Liquidacion", id));
        
        if (!"1".equals(entity.getFlagEstado())) {
            throw new BusinessException(
                "Solo se pueden cerrar liquidaciones activas",
                FinanzasErrorCodes.LIQUIDACION_ESTADO_INVALIDO
            );
        }
        
        BigDecimal sumaDetalles = detRepository.calcularSumaImportes(id);
        if (sumaDetalles == null) {
            sumaDetalles = BigDecimal.ZERO;
        }
        
        if (entity.getImporteNeto().compareTo(sumaDetalles) != 0) {
            throw new BusinessException(
                "Los detalles no cuadran con el importe neto",
                FinanzasErrorCodes.LIQUIDACION_TOTALES_NO_CUADRAN
            );
        }
        
        entity.setFlagEstado("2");
        if (observacion != null && !observacion.isEmpty()) {
            entity.setObservacion(observacion);
        }
        entity.setUpdatedBy(com.sigre.common.security.TenantContext.getUsuarioId());
        repository.save(entity);
        
        return mapper.toDetalleResponse(entity);
    }

    private void validarSolicitudGiro(Long solicitudGiroId) {
        SolicitudGiro solicitudGiro = solicitudGiroRepository.findById(solicitudGiroId)
            .orElseThrow(() -> new ResourceNotFoundException("SolicitudGiro", solicitudGiroId));
        
        if (!"1".equals(solicitudGiro.getFlagEstado())) {
            throw new BusinessException(
                "La solicitud de giro no está activa",
                FinanzasErrorCodes.SOLICITUD_GIRO_INACTIVA
            );
        }
        
        if (!"1".equals(solicitudGiro.getFlagEstado())) {
            throw new BusinessException(
                "La solicitud de giro debe estar aprobada",
                FinanzasErrorCodes.SOLICITUD_GIRO_NO_APROBADA
            );
        }
    }

    private void validarCuadreDetalles(LiquidacionRequest request) {
        BigDecimal sumaDetalles = request.getDetalles().stream()
            .map(det -> {
                BigDecimal importe = det.getImporte();
                Short factor = det.getFactorSigno();
                if (factor != null) {
                    return importe.multiply(BigDecimal.valueOf(factor));
                }
                return importe;
            })
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        if (request.getImporteNeto().compareTo(sumaDetalles) != 0) {
            throw new BusinessException(
                "La suma de los detalles no cuadra con el importe neto",
                FinanzasErrorCodes.LIQUIDACION_TOTALES_NO_CUADRAN
            );
        }
    }
}
