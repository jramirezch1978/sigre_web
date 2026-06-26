package pe.restaurant.finanzas.mapper;

import org.springframework.stereotype.Component;
import pe.restaurant.finanzas.dto.request.ProgramacionPagoDetalleRequest;
import pe.restaurant.finanzas.dto.response.ProgramacionPagoDetalleResponse;
import pe.restaurant.finanzas.entity.ProgramacionPagoDet;

@Component
public class ProgramacionPagoDetMapper {

    public ProgramacionPagoDet toEntity(ProgramacionPagoDetalleRequest request) {
        ProgramacionPagoDet entity = new ProgramacionPagoDet();
        entity.setCntasPagarId(request.getCntasPagarId());
        entity.setMontoProgramado(request.getMontoProgramado());
        return entity;
    }

    public ProgramacionPagoDetalleResponse toResponse(ProgramacionPagoDet entity) {
        ProgramacionPagoDetalleResponse response = new ProgramacionPagoDetalleResponse();
        response.setId(entity.getId());
        response.setProgramacionId(entity.getProgramacionPago() != null ? entity.getProgramacionPago().getId() : null);
        response.setCntasPagarId(entity.getCntasPagarId());
        response.setMontoProgramado(entity.getMontoProgramado());
        response.setFlagEstado(entity.getFlagEstado());
        response.setCreatedBy(entity.getCreatedBy());
        response.setFecCreacion(entity.getFecCreacion());
        response.setUpdatedBy(entity.getUpdatedBy());
        response.setFecModificacion(entity.getFecModificacion());
        return response;
    }

    public void updateEntity(ProgramacionPagoDet entity, ProgramacionPagoDetalleRequest request) {
        entity.setCntasPagarId(request.getCntasPagarId());
        entity.setMontoProgramado(request.getMontoProgramado());
    }
}
