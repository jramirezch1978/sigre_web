package pe.restaurant.finanzas.mapper;

import org.springframework.stereotype.Component;
import pe.restaurant.finanzas.dto.request.CajaBancosRequest;
import pe.restaurant.finanzas.dto.response.CajaBancosDetalleResponse;
import pe.restaurant.finanzas.dto.response.CajaBancosResponse;
import pe.restaurant.finanzas.entity.CajaBancos;

import java.util.Collections;
import java.util.stream.Collectors;

@Component
public class CajaBancosMapper {

    private final CajaBancosDetMapper detMapper;

    public CajaBancosMapper(CajaBancosDetMapper detMapper) {
        this.detMapper = detMapper;
    }

    public CajaBancos toEntity(CajaBancosRequest request) {
        CajaBancos entity = new CajaBancos();
        entity.setFlagTipoTransaccion(request.getFlagTipoTransaccion());
        entity.setBancoCntaId(request.getBancoCntaId());
        entity.setBancoCntaRefId(request.getBancoCntaRefId());
        entity.setFechaEmision(request.getFechaEmision());
        entity.setFechaProgramada(request.getFechaProgramada());
        entity.setMonedaId(request.getMonedaId());
        entity.setEntidadContribuyenteId(request.getEntidadContribuyenteId());
        entity.setImpTotal(request.getImpTotal());
        entity.setConceptoFinancieroId(request.getConceptoFinancieroId());
        entity.setAno(request.getAno());
        entity.setMes(request.getMes());
        entity.setCntblLibroId(request.getCntblLibroId());
        entity.setDocTipoId(request.getDocTipoId());
        entity.setNroDoc(request.getNroDoc());
        entity.setObservacion(request.getObservacion());
        entity.setTasaCambio(request.getTasaCambio());
        entity.setMedioPagoId(request.getMedioPagoId());
        return entity;
    }

    public CajaBancosResponse toResponse(CajaBancos entity) {
        CajaBancosResponse response = new CajaBancosResponse();
        response.setId(entity.getId());
        response.setSucursalId(entity.getSucursalId());
        response.setNroRegistro(entity.getNroRegistro());
        response.setFlagTipoTransaccion(entity.getFlagTipoTransaccion());
        response.setBancoCntaId(entity.getBancoCntaId());
        response.setBancoCntaRefId(entity.getBancoCntaRefId());
        response.setFechaEmision(entity.getFechaEmision());
        response.setFechaProgramada(entity.getFechaProgramada());
        response.setFechaEjecucion(entity.getFechaEjecucion());
        response.setMonedaId(entity.getMonedaId());
        response.setEntidadContribuyenteId(entity.getEntidadContribuyenteId());
        response.setImpTotal(entity.getImpTotal());
        response.setImpAsignado(entity.getImpAsignado());
        response.setConceptoFinancieroId(entity.getConceptoFinancieroId());
        response.setAno(entity.getAno());
        response.setMes(entity.getMes());
        response.setCntblLibroId(entity.getCntblLibroId());
        response.setDocTipoId(entity.getDocTipoId());
        response.setNroDoc(entity.getNroDoc());
        response.setTasaCambio(entity.getTasaCambio());
        response.setMedioPagoId(entity.getMedioPagoId());
        response.setFlagEstado(entity.getFlagEstado());
        response.setCreatedBy(entity.getCreatedBy());
        response.setUpdatedBy(entity.getUpdatedBy());
        return response;
    }

    public CajaBancosDetalleResponse toDetalleResponse(CajaBancos entity) {
        CajaBancosDetalleResponse response = new CajaBancosDetalleResponse();
        response.setId(entity.getId());
        response.setSucursalId(entity.getSucursalId());
        response.setNroRegistro(entity.getNroRegistro());
        response.setFlagTipoTransaccion(entity.getFlagTipoTransaccion());
        response.setBancoCntaId(entity.getBancoCntaId());
        response.setBancoCntaRefId(entity.getBancoCntaRefId());
        response.setFechaEmision(entity.getFechaEmision());
        response.setFechaProgramada(entity.getFechaProgramada());
        response.setFechaEjecucion(entity.getFechaEjecucion());
        response.setFlagPago(entity.getFlagPago());
        response.setMonedaId(entity.getMonedaId());
        response.setEntidadContribuyenteId(entity.getEntidadContribuyenteId());
        response.setImpTotal(entity.getImpTotal());
        response.setImpAsignado(entity.getImpAsignado());
        response.setConceptoFinancieroId(entity.getConceptoFinancieroId());
        response.setAno(entity.getAno());
        response.setMes(entity.getMes());
        response.setCntblLibroId(entity.getCntblLibroId());
        response.setDocTipoId(entity.getDocTipoId());
        response.setNroDoc(entity.getNroDoc());
        response.setObservacion(entity.getObservacion());
        response.setTasaCambio(entity.getTasaCambio());
        response.setMedioPagoId(entity.getMedioPagoId());
        response.setCntblAsientoId(entity.getCntblAsientoId());
        response.setFlagEstado(entity.getFlagEstado());
        response.setCreatedBy(entity.getCreatedBy());
        response.setUpdatedBy(entity.getUpdatedBy());

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

    public void updateEntity(CajaBancos entity, CajaBancosRequest request) {
        entity.setFlagTipoTransaccion(request.getFlagTipoTransaccion());
        entity.setBancoCntaId(request.getBancoCntaId());
        entity.setBancoCntaRefId(request.getBancoCntaRefId());
        entity.setFechaEmision(request.getFechaEmision());
        entity.setFechaProgramada(request.getFechaProgramada());
        entity.setMonedaId(request.getMonedaId());
        entity.setEntidadContribuyenteId(request.getEntidadContribuyenteId());
        entity.setImpTotal(request.getImpTotal());
        entity.setConceptoFinancieroId(request.getConceptoFinancieroId());
        entity.setAno(request.getAno());
        entity.setMes(request.getMes());
        entity.setCntblLibroId(request.getCntblLibroId());
        entity.setDocTipoId(request.getDocTipoId());
        entity.setNroDoc(request.getNroDoc());
        entity.setObservacion(request.getObservacion());
        entity.setTasaCambio(request.getTasaCambio());
        entity.setMedioPagoId(request.getMedioPagoId());
    }

}
