package com.sigre.finanzas.mapper;

import org.springframework.stereotype.Component;
import com.sigre.finanzas.dto.request.NotaDetalleRequest;
import com.sigre.finanzas.dto.response.NotaDetalleResponse;
import com.sigre.finanzas.entity.CntasPagarDet;

import java.time.ZoneId;
import java.util.List;

@Component
public class NotaDetalleMapper {

    public NotaDetalleResponse toResponse(CntasPagarDet entity) {
        if (entity == null) {
            return null;
        }

        NotaDetalleResponse response = new NotaDetalleResponse();
        response.setId(entity.getId());
        response.setCntasPagarId(entity.getCntasPagar() != null ? entity.getCntasPagar().getId() : null);
        response.setItem(entity.getItem());
        response.setConceptoFinancieroId(entity.getConceptoFinancieroId());
        response.setDescripcion(entity.getDescripcion());
        response.setArticuloId(entity.getArticuloId());
        response.setCantidad(entity.getCantidad());
        response.setPrecioUnitario(entity.getPrecioUnitario());
        response.setMonto(entity.getMonto());
        response.setCentrosCostoId(entity.getCentrosCostoId());
        response.setSucursalRefId(entity.getSucursalRefId());
        response.setDocTipoRefId(entity.getDocTipoRefId());
        response.setNroRef(entity.getNroRef());
        response.setItemRef(entity.getItemRef());
        response.setTrabajadorId(entity.getTrabajadorId());
        response.setOrdenCompraDetId(entity.getOrdenCompraDetId());
        response.setOrdenServicioDetId(entity.getOrdenServicioDetId());
        response.setValeMovDetId(entity.getValeMovDetId());
        response.setFecMovilidad(entity.getFecMovilidad());
        response.setMovDesde(entity.getMovDesde());
        response.setMovHasta(entity.getMovHasta());
        response.setFechaMov(entity.getFechaMov());
        response.setTipoMov(entity.getTipoMov());
        response.setReferencia(entity.getReferencia());
        response.setFlagEstado(entity.getFlagEstado());
        response.setCreatedBy(entity.getCreatedBy());
        response.setFecCreacion(entity.getFecCreacion() != null ?
            entity.getFecCreacion().atZone(ZoneId.systemDefault()).toLocalDateTime() : null);
        response.setUpdatedBy(entity.getUpdatedBy());
        response.setFecModificacion(entity.getFecModificacion() != null ?
            entity.getFecModificacion().atZone(ZoneId.systemDefault()).toLocalDateTime() : null);

        return response;
    }

    public List<NotaDetalleResponse> toResponseList(List<CntasPagarDet> entities) {
        return entities.stream()
                .map(this::toResponse)
                .toList();
    }

    public CntasPagarDet toEntity(NotaDetalleRequest request, Long cntasPagarId) {
        if (request == null) {
            return null;
        }

        CntasPagarDet entity = new CntasPagarDet();
        entity.setItem(request.getItem());
        entity.setConceptoFinancieroId(request.getConceptoFinancieroId());
        entity.setDescripcion(request.getDescripcion());
        entity.setArticuloId(request.getArticuloId());
        entity.setCantidad(request.getCantidad());
        entity.setPrecioUnitario(request.getPrecioUnitario());
        entity.setMonto(request.getMonto());
        entity.setCentrosCostoId(request.getCentrosCostoId());
        entity.setCreditoFiscalId(request.getCreditoFiscalId());
        entity.setSucursalRefId(request.getSucursalRefId());
        entity.setDocTipoRefId(request.getDocTipoRefId());
        entity.setNroRef(request.getNroRef());
        entity.setItemRef(request.getItemRef());
        entity.setTrabajadorId(request.getTrabajadorId());
        entity.setOrdenCompraDetId(request.getOrdenCompraDetId());
        entity.setOrdenServicioDetId(request.getOrdenServicioDetId());
        entity.setValeMovDetId(request.getValeMovDetId());
        entity.setFecMovilidad(request.getFecMovilidad());
        entity.setMovDesde(request.getMovDesde());
        entity.setMovHasta(request.getMovHasta());
        entity.setFechaMov(request.getFechaMov());
        entity.setTipoMov(request.getTipoMov());
        entity.setReferencia(request.getReferencia());
        entity.setFlagEstado("1");

        return entity;
    }
}
