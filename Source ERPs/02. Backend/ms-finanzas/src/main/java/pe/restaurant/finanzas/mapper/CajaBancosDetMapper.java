package pe.restaurant.finanzas.mapper;

import org.springframework.stereotype.Component;
import pe.restaurant.finanzas.dto.request.CajaBancosDetalleRequest;
import pe.restaurant.finanzas.dto.response.CajaBancosDetResponse;
import pe.restaurant.finanzas.entity.CajaBancosDet;

@Component
public class CajaBancosDetMapper {

    public CajaBancosDet toEntity(CajaBancosDetalleRequest request) {
        CajaBancosDet entity = new CajaBancosDet();
        entity.setItem(request.getItem());
        entity.setEntidadContribuyenteId(request.getEntidadContribuyenteId());
        entity.setDocTipoId(request.getDocTipoId());
        entity.setNroDoc(request.getNroDoc());
        entity.setImporte(request.getImporte());
        entity.setCntasPagarId(request.getCntasPagarId());
        entity.setCntasCobrarId(request.getCntasCobrarId());
        entity.setSolicitudGiroId(request.getSolicitudGiroId());
        entity.setLiquidacionId(request.getLiquidacionId());
        entity.setConceptoFinancieroId(request.getConceptoFinancieroId());
        entity.setFlagCxp(request.getFlagCxp());
        entity.setSucursalRefId(request.getSucursalRefId());
        entity.setMonedaId(request.getMonedaId());
        entity.setCentrosCostoId(request.getCentrosCostoId());
        entity.setCodigoFlujoCajaId(request.getCodigoFlujoCajaId());
        entity.setBancoCntaProvId(request.getBancoCntaProvId());
        return entity;
    }

    public CajaBancosDetResponse toResponse(CajaBancosDet entity) {
        CajaBancosDetResponse response = new CajaBancosDetResponse();
        response.setId(entity.getId());
        response.setCajaBancosId(entity.getCajaBancos() != null ? entity.getCajaBancos().getId() : null);
        response.setItem(entity.getItem());
        response.setEntidadContribuyenteId(entity.getEntidadContribuyenteId());
        response.setDocTipoId(entity.getDocTipoId());
        response.setNroDoc(entity.getNroDoc());
        response.setImporte(entity.getImporte());
        response.setCntasPagarId(entity.getCntasPagarId());
        response.setCntasCobrarId(entity.getCntasCobrarId());
        response.setSolicitudGiroId(entity.getSolicitudGiroId());
        response.setLiquidacionId(entity.getLiquidacionId());
        response.setConceptoFinancieroId(entity.getConceptoFinancieroId());
        response.setFlagCxp(entity.getFlagCxp());
        response.setSucursalRefId(entity.getSucursalRefId());
        response.setMonedaId(entity.getMonedaId());
        response.setCentrosCostoId(entity.getCentrosCostoId());
        response.setCodigoFlujoCajaId(entity.getCodigoFlujoCajaId());
        response.setBancoCntaProvId(entity.getBancoCntaProvId());
        response.setFlagEstado(entity.getFlagEstado());
        response.setCreatedBy(entity.getCreatedBy());
        response.setFecCreacion(entity.getFecCreacion());
        response.setUpdatedBy(entity.getUpdatedBy());
        response.setFecModificacion(entity.getFecModificacion());
        return response;
    }
}
