package pe.restaurant.finanzas.mapper;

import org.springframework.stereotype.Component;
import pe.restaurant.finanzas.dto.request.ProgramacionPagoRequest;
import pe.restaurant.finanzas.dto.response.ProgramacionPagoResponse;
import pe.restaurant.finanzas.dto.response.ProgramacionPagoListResponse;
import pe.restaurant.finanzas.entity.ProgramacionPago;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.stream.Collectors;

@Component
public class ProgramacionPagoMapper {

    private final ProgramacionPagoDetMapper detMapper;

    public ProgramacionPagoMapper(ProgramacionPagoDetMapper detMapper) {
        this.detMapper = detMapper;
    }

    public ProgramacionPago toEntity(ProgramacionPagoRequest request) {
        ProgramacionPago entity = new ProgramacionPago();
        entity.setFechaProgramada(request.getFechaProgramada());
        return entity;
    }

    public ProgramacionPagoResponse toResponse(ProgramacionPago entity) {
        ProgramacionPagoResponse response = new ProgramacionPagoResponse();
        response.setId(entity.getId());
        response.setFechaProgramada(entity.getFechaProgramada());
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

    public ProgramacionPagoListResponse toListResponse(ProgramacionPago entity) {
        ProgramacionPagoListResponse response = new ProgramacionPagoListResponse();
        response.setId(entity.getId());
        response.setFechaProgramada(entity.getFechaProgramada());
        response.setFlagEstado(entity.getFlagEstado());
        response.setCreatedBy(entity.getCreatedBy());
        response.setFecCreacion(entity.getFecCreacion());
        response.setUpdatedBy(entity.getUpdatedBy());
        response.setFecModificacion(entity.getFecModificacion());

        if (entity.getDetalles() != null) {
            BigDecimal totalProgramado = entity.getDetalles().stream()
                .filter(detalle -> "1".equals(detalle.getFlagEstado()))
                .map(detalle -> detalle.getMontoProgramado())
                .reduce(BigDecimal.ZERO, BigDecimal::add);
            
            Integer cantidadDocumentos = (int) entity.getDetalles().stream()
                .filter(detalle -> "1".equals(detalle.getFlagEstado()))
                .count();
            
            response.setTotalProgramado(totalProgramado);
            response.setCantidadDocumentos(cantidadDocumentos);
        } else {
            response.setTotalProgramado(BigDecimal.ZERO);
            response.setCantidadDocumentos(0);
        }

        return response;
    }

    public void updateEntity(ProgramacionPago entity, ProgramacionPagoRequest request) {
        entity.setFechaProgramada(request.getFechaProgramada());
    }
}
