package pe.restaurant.finanzas.mapper;

import org.springframework.stereotype.Component;
import pe.restaurant.finanzas.constants.SolicitudGiroConstants;
import pe.restaurant.finanzas.dto.request.SolicitudGiroRequest;
import pe.restaurant.finanzas.dto.response.SolicitudGiroDetalleResponse;
import pe.restaurant.finanzas.dto.response.SolicitudGiroResponse;
import pe.restaurant.finanzas.client.dto.SolicitudGiroDTO;
import pe.restaurant.finanzas.entity.SolicitudGiro;

@Component
public class SolicitudGiroMapper {

    public SolicitudGiro toEntity(SolicitudGiroRequest request) {
        SolicitudGiro entity = new SolicitudGiro();
        entity.setSucursalId(request.getSucursalId());
        entity.setSolicitanteId(request.getSolicitanteId());
        entity.setFecha(request.getFecha());
        entity.setMonto(request.getMonto());
        entity.setMotivo(request.getMotivo());
        entity.setTipoSolicitud(
                request.getTipoSolicitud() != null && !request.getTipoSolicitud().isBlank()
                        ? request.getTipoSolicitud()
                        : SolicitudGiroConstants.TIPO_ORDEN_GIRO);
        entity.setCentrosCostoId(request.getCentrosCostoId());
        entity.setMonedaId(request.getMonedaId());
        entity.setFormaPagoId(request.getFormaPagoId());
        return entity;
    }

    public SolicitudGiroResponse toResponse(SolicitudGiro entity) {
        SolicitudGiroResponse response = new SolicitudGiroResponse();
        response.setId(entity.getId());
        response.setSucursalId(entity.getSucursalId());
        response.setSolicitanteId(entity.getSolicitanteId());
        response.setNumero(entity.getNumero());
        response.setFecha(entity.getFecha());
        response.setMonto(entity.getMonto());
        response.setMotivo(entity.getMotivo());
        response.setTipoSolicitud(entity.getTipoSolicitud());
        response.setCentrosCostoId(entity.getCentrosCostoId());
        response.setMonedaId(entity.getMonedaId());
        response.setFormaPagoId(entity.getFormaPagoId());
        response.setAprobadorId(entity.getAprobadorId());
        response.setFecAprobacion(entity.getFecAprobacion());
        response.setFecRechazo(entity.getFecRechazo());
        response.setMotivoRechazo(entity.getMotivoRechazo());
        response.setMotivoDevolucion(entity.getMotivoDevolucion());
        response.setAprobadorDevolucionId(entity.getAprobadorDevolucionId());
        response.setFecAprobacionDevolucion(entity.getFecAprobacionDevolucion());
        response.setFecRechazoDevolucion(entity.getFecRechazoDevolucion());
        response.setMotivoRechazoDevolucion(entity.getMotivoRechazoDevolucion());
        response.setFlagEstadoDevolucion(entity.getFlagEstadoDevolucion());
        response.setFlagEstado(entity.getFlagEstado());
        response.setCreatedBy(entity.getCreatedBy());
        response.setFecCreacion(entity.getFecCreacion());
        response.setUpdatedBy(entity.getUpdatedBy());
        response.setFecModificacion(entity.getFecModificacion());
        return response;
    }

    public SolicitudGiroDetalleResponse toDetalleResponse(SolicitudGiro entity) {
        SolicitudGiroDetalleResponse response = new SolicitudGiroDetalleResponse();
        response.setId(entity.getId());
        response.setSucursalId(entity.getSucursalId());
        response.setSolicitanteId(entity.getSolicitanteId());
        response.setNumero(entity.getNumero());
        response.setFecha(entity.getFecha());
        response.setMonto(entity.getMonto());
        response.setMotivo(entity.getMotivo());
        response.setTipoSolicitud(entity.getTipoSolicitud());
        response.setCentrosCostoId(entity.getCentrosCostoId());
        response.setMonedaId(entity.getMonedaId());
        response.setFormaPagoId(entity.getFormaPagoId());
        response.setAprobadorId(entity.getAprobadorId());
        response.setFecAprobacion(entity.getFecAprobacion());
        response.setFecRechazo(entity.getFecRechazo());
        response.setMotivoRechazo(entity.getMotivoRechazo());
        response.setMotivoDevolucion(entity.getMotivoDevolucion());
        response.setAprobadorDevolucionId(entity.getAprobadorDevolucionId());
        response.setFecAprobacionDevolucion(entity.getFecAprobacionDevolucion());
        response.setFecRechazoDevolucion(entity.getFecRechazoDevolucion());
        response.setMotivoRechazoDevolucion(entity.getMotivoRechazoDevolucion());
        response.setFlagEstadoDevolucion(entity.getFlagEstadoDevolucion());
        response.setFlagEstado(entity.getFlagEstado());
        response.setCreatedBy(entity.getCreatedBy());
        response.setFecCreacion(entity.getFecCreacion());
        response.setUpdatedBy(entity.getUpdatedBy());
        response.setFecModificacion(entity.getFecModificacion());
        return response;
    }

    /**
     * Convierte una entidad SolicitudGiro a DTO para integración con otros microservicios.
     * 
     * @param entity Entidad SolicitudGiro
     * @return DTO para transferencia entre microservicios
     */
    public SolicitudGiroDTO toDTO(SolicitudGiro entity) {
        return SolicitudGiroDTO.builder()
                .id(entity.getId())
                .numero(entity.getNumero())
                .fecha(entity.getFecha())
                .solicitanteId(entity.getSolicitanteId())
                .monto(entity.getMonto())
                .motivo(entity.getMotivo())
                .tipoSolicitud(entity.getTipoSolicitud())
                .build();
    }

}
