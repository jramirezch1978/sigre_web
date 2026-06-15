package com.sigre.finanzas.mapper;

import org.springframework.stereotype.Component;
import com.sigre.finanzas.dto.request.LiquidacionDetalleRequest;
import com.sigre.finanzas.dto.request.LiquidacionRequest;
import com.sigre.finanzas.dto.response.LiquidacionDetalleResponse;
import com.sigre.finanzas.dto.response.LiquidacionResponse;
import com.sigre.finanzas.client.dto.LiquidacionDTO;
import com.sigre.finanzas.entity.Liquidacion;
import com.sigre.finanzas.entity.LiquidacionDet;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.stream.Collectors;

@Component
public class LiquidacionMapper {

    private final LiquidacionDetMapper detMapper;

    public LiquidacionMapper(LiquidacionDetMapper detMapper) {
        this.detMapper = detMapper;
    }

    public Liquidacion toEntity(LiquidacionRequest request) {
        Liquidacion entity = new Liquidacion();
        entity.setSolicitudGiroId(request.getSolicitudGiroId());
        // Solo asignar número si viene del request (null = generar automáticamente en backend)
        if (request.getNroLiquidacion() != null) {
            entity.setNroLiquidacion(request.getNroLiquidacion());
        }
        entity.setSucursalId(request.getSucursalId());
        entity.setDocTipoId(request.getDocTipoId());
        entity.setProveedorId(request.getProveedorId());
        entity.setFechaLiquidacion(request.getFechaLiquidacion());
        entity.setTipoLiquidacion(request.getTipoLiquidacion());
        entity.setMonedaId(request.getMonedaId());
        entity.setConceptoFinancieroId(request.getConceptoFinancieroId());
        entity.setCntblLibroId(request.getCntblLibroId());
        entity.setImporteNeto(request.getImporteNeto());
        entity.setSaldo(BigDecimal.ZERO); // Inicializar saldo en 0 al crear liquidación
        entity.setTasaCambio(request.getTasaCambio());
        entity.setAnio(request.getAnio());
        entity.setMes(request.getMes());
        entity.setUsuarioId(request.getUsuarioId());
        entity.setObservacion(request.getObservacion());
        return entity;
    }

    public LiquidacionResponse toResponse(Liquidacion entity) {
        LiquidacionResponse response = new LiquidacionResponse();
        response.setId(entity.getId());
        response.setSolicitudGiroId(entity.getSolicitudGiroId());
        response.setNroLiquidacion(entity.getNroLiquidacion());
        response.setSucursalId(entity.getSucursalId());
        response.setDocTipoId(entity.getDocTipoId());
                response.setProveedorId(entity.getProveedorId());
        response.setFechaRegistro(entity.getFechaRegistro());
        response.setFechaLiquidacion(entity.getFechaLiquidacion());
        response.setTipoLiquidacion(entity.getTipoLiquidacion());
        response.setMonedaId(entity.getMonedaId());
        response.setConceptoFinancieroId(entity.getConceptoFinancieroId());
        response.setImporteNeto(entity.getImporteNeto());
        response.setSaldo(entity.getSaldo());
        response.setTasaCambio(entity.getTasaCambio());
        response.setAnio(entity.getAnio());
        response.setMes(entity.getMes());
        response.setCntblLibroId(entity.getCntblLibroId());
        response.setCntblAsientoId(entity.getCntblAsientoId());
        response.setUsuarioId(entity.getUsuarioId());
        response.setObservacion(entity.getObservacion());
        response.setFlagEstado(entity.getFlagEstado());
        response.setCreatedBy(entity.getCreatedBy());
        response.setFecCreacion(entity.getFecCreacion());
        response.setUpdatedBy(entity.getUpdatedBy());
        response.setFecModificacion(entity.getFecModificacion());
        return response;
    }

    public LiquidacionDetalleResponse toDetalleResponse(Liquidacion entity) {
        LiquidacionDetalleResponse response = new LiquidacionDetalleResponse();
        response.setId(entity.getId());
        response.setSolicitudGiroId(entity.getSolicitudGiroId());
        response.setNroLiquidacion(entity.getNroLiquidacion());
        response.setSucursalId(entity.getSucursalId());
        response.setDocTipoId(entity.getDocTipoId());
        response.setProveedorId(entity.getProveedorId());
        response.setFechaRegistro(entity.getFechaRegistro());
        response.setFechaLiquidacion(entity.getFechaLiquidacion());
        response.setTipoLiquidacion(entity.getTipoLiquidacion());
        response.setMonedaId(entity.getMonedaId());
        response.setConceptoFinancieroId(entity.getConceptoFinancieroId());
        response.setImporteNeto(entity.getImporteNeto());
        response.setSaldo(entity.getSaldo());
        response.setTasaCambio(entity.getTasaCambio());
        response.setAnio(entity.getAnio());
        response.setMes(entity.getMes());
        response.setCntblLibroId(entity.getCntblLibroId());
        response.setCntblAsientoId(entity.getCntblAsientoId());
        response.setUsuarioId(entity.getUsuarioId());
        response.setObservacion(entity.getObservacion());
        response.setFlagEstado(entity.getFlagEstado());
        response.setCreatedBy(entity.getCreatedBy());
        response.setFecCreacion(entity.getFecCreacion());
        response.setUpdatedBy(entity.getUpdatedBy());
        response.setFecModificacion(entity.getFecModificacion());

        if (entity.getDetalles() != null) {
            response.setDetalles(entity.getDetalles().stream()
                .filter(detalle -> "1".equals(detalle.getFlagEstado()))
                .map(detMapper::toResponse)
                .collect(Collectors.toList()));
        } else {
            response.setDetalles(Collections.emptyList());
        }

        return response;
    }

    public void updateEntity(Liquidacion entity, LiquidacionRequest request) {
        entity.setDocTipoId(request.getDocTipoId());
                entity.setProveedorId(request.getProveedorId());
        entity.setFechaLiquidacion(request.getFechaLiquidacion());
        entity.setTipoLiquidacion(request.getTipoLiquidacion());
        entity.setMonedaId(request.getMonedaId());
        entity.setConceptoFinancieroId(request.getConceptoFinancieroId());
        entity.setCntblLibroId(request.getCntblLibroId());
        entity.setImporteNeto(request.getImporteNeto());
        entity.setTasaCambio(request.getTasaCambio());
        entity.setAnio(request.getAnio());
        entity.setMes(request.getMes());
        entity.setUsuarioId(request.getUsuarioId());
        entity.setObservacion(request.getObservacion());
    }

    /**
     * Convierte una entidad Liquidacion a DTO para integración con otros microservicios.
     * 
     * @param entity Entidad Liquidacion
     * @return DTO para transferencia entre microservicios
     */
    public LiquidacionDTO toDTO(Liquidacion entity) {
        return LiquidacionDTO.builder()
                .id(entity.getId())
                .nroLiquidacion(entity.getNroLiquidacion())
                .fechaRegistro(entity.getFechaRegistro())
                .proveedorId(entity.getProveedorId())
                .monedaId(entity.getMonedaId())
                .importeNeto(entity.getImporteNeto())
                .saldo(entity.getSaldo())
                .observacion(entity.getObservacion())
                .build();
    }
}
