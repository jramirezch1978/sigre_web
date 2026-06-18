package pe.restaurant.finanzas.mapper;

import org.springframework.stereotype.Component;
import pe.restaurant.finanzas.dto.request.LiquidacionDetalleRequest;
import pe.restaurant.finanzas.dto.response.LiquidacionDetResponse;
import pe.restaurant.finanzas.entity.LiquidacionDet;

@Component
public class LiquidacionDetMapper {

    public LiquidacionDet toEntity(LiquidacionDetalleRequest request) {
        LiquidacionDet entity = new LiquidacionDet();
        entity.setItem(request.getItem());
        entity.setOrigenDocRef(request.getOrigenDocRef());
        entity.setMonedaId(request.getMonedaId());
        entity.setConceptoFinancieroId(request.getConceptoFinancieroId());
        entity.setCntasPagarId(request.getCntasPagarId());
        entity.setCntasCobrarId(request.getCntasCobrarId());
        entity.setCentrosCostoId(request.getCentrosCostoId());
        entity.setFactorSigno(request.getFactorSigno());
        entity.setImporte(request.getImporte());
        entity.setFlagRetencion(request.getFlagRetencion());
        entity.setImporteRetenido(request.getImporteRetenido());
        entity.setFlagProvisionado(request.getFlagProvisionado());
        return entity;
    }

    public LiquidacionDetResponse toResponse(LiquidacionDet entity) {
        LiquidacionDetResponse response = new LiquidacionDetResponse();
        response.setId(entity.getId());
        response.setLiquidacionId(entity.getLiquidacion() != null ? entity.getLiquidacion().getId() : null);
        response.setItem(entity.getItem());
        response.setOrigenDocRef(entity.getOrigenDocRef());
        response.setMonedaId(entity.getMonedaId());
        response.setConceptoFinancieroId(entity.getConceptoFinancieroId());
        response.setCntasPagarId(entity.getCntasPagarId());
        response.setCntasCobrarId(entity.getCntasCobrarId());
        response.setCentrosCostoId(entity.getCentrosCostoId());
        response.setFactorSigno(entity.getFactorSigno());
        response.setImporte(entity.getImporte());
        response.setFlagRetencion(entity.getFlagRetencion());
        response.setImporteRetenido(entity.getImporteRetenido());
        response.setFlagProvisionado(entity.getFlagProvisionado());
        response.setFlagEstado(entity.getFlagEstado());
        response.setCreatedBy(entity.getCreatedBy());
        response.setFecCreacion(entity.getFecCreacion());
        response.setUpdatedBy(entity.getUpdatedBy());
        response.setFecModificacion(entity.getFecModificacion());
        return response;
    }
}
