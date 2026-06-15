package com.sigre.finanzas.mapper;

import org.springframework.stereotype.Component;
import com.sigre.finanzas.dto.response.DestinoCanjeResponse;
import com.sigre.finanzas.dto.response.LetraCanjeDetalleResponse;
import com.sigre.finanzas.dto.response.LetraCanjeResponse;
import com.sigre.finanzas.dto.response.OrigenCanjeResponse;
import com.sigre.finanzas.entity.CntasPagar;
import com.sigre.finanzas.entity.CntasPagarDet;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@Component
public class LetraCanjeMapper {

    public LetraCanjeResponse toResponse(String referencia, List<CntasPagar> origenes, 
                                         List<CntasPagar> destinos) {
        LetraCanjeResponse response = new LetraCanjeResponse();
        response.setReferencia(referencia);
        
        if (!origenes.isEmpty()) {
            CntasPagar primerOrigen = origenes.get(0);
            response.setProveedorId(primerOrigen.getProveedorId());
            
            LocalDate fechaCanje = primerOrigen.getDetalles().stream()
                .filter(d -> referencia.equals(d.getReferencia()))
                .map(CntasPagarDet::getFechaMov)
                .findFirst()
                .orElse(null);
            response.setFechaCanje(fechaCanje);
            
            Long createdBy = primerOrigen.getDetalles().stream()
                .filter(d -> referencia.equals(d.getReferencia()))
                .map(CntasPagarDet::getCreatedBy)
                .findFirst()
                .orElse(null);
            response.setCreatedBy(createdBy);
            
            var fecCreacion = primerOrigen.getDetalles().stream()
                .filter(d -> referencia.equals(d.getReferencia()))
                .map(CntasPagarDet::getFecCreacion)
                .findFirst()
                .orElse(null);
            response.setFecCreacion(fecCreacion);
        }
        
        BigDecimal montoCanjeado = origenes.stream()
            .flatMap(o -> o.getDetalles().stream())
            .filter(d -> referencia.equals(d.getReferencia()) && "CANJE_ORIGEN".equals(d.getTipoMov()))
            .map(CntasPagarDet::getMonto)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        response.setMontoCanjeado(montoCanjeado);
        
        response.setCantidadOrigenes(origenes.size());
        response.setCantidadDestinos(destinos.size());
        
        return response;
    }

    public LetraCanjeDetalleResponse toDetalleResponse(String referencia, 
                                                       List<CntasPagar> origenes, 
                                                       List<CntasPagar> destinos) {
        LetraCanjeDetalleResponse response = new LetraCanjeDetalleResponse();
        response.setReferencia(referencia);
        
        if (!origenes.isEmpty()) {
            CntasPagar primerOrigen = origenes.get(0);
            response.setProveedorId(primerOrigen.getProveedorId());
            
            LocalDate fechaCanje = primerOrigen.getDetalles().stream()
                .filter(d -> referencia.equals(d.getReferencia()))
                .map(CntasPagarDet::getFechaMov)
                .findFirst()
                .orElse(null);
            response.setFechaCanje(fechaCanje);
        }
        
        BigDecimal montoCanjeado = origenes.stream()
            .flatMap(o -> o.getDetalles().stream())
            .filter(d -> referencia.equals(d.getReferencia()) && "CANJE_ORIGEN".equals(d.getTipoMov()))
            .map(CntasPagarDet::getMonto)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        response.setMontoCanjeado(montoCanjeado);
        
        List<OrigenCanjeResponse> origenesResponse = origenes.stream()
            .map(origen -> {
                BigDecimal montoCanjeadoOrigen = origen.getDetalles().stream()
                    .filter(d -> referencia.equals(d.getReferencia()) && "CANJE_ORIGEN".equals(d.getTipoMov()))
                    .map(CntasPagarDet::getMonto)
                    .findFirst()
                    .orElse(BigDecimal.ZERO);
                return toOrigenResponse(origen, montoCanjeadoOrigen);
            })
            .collect(Collectors.toList());
        response.setOrigenes(origenesResponse);
        
        List<DestinoCanjeResponse> destinosResponse = destinos.stream()
            .map(this::toDestinoResponse)
            .collect(Collectors.toList());
        response.setDestinos(destinosResponse);
        
        return response;
    }

    public OrigenCanjeResponse toOrigenResponse(CntasPagar origen, BigDecimal montoCanjeado) {
        OrigenCanjeResponse response = new OrigenCanjeResponse();
        response.setCntasPagarId(origen.getId());
        response.setSerie(origen.getSerie());
        response.setNumero(origen.getNumero());
        response.setTotalOriginal(origen.getTotal());
        response.setMontoCanjeado(montoCanjeado);
        response.setSaldoFinal(origen.getSaldo());
        return response;
    }

    public DestinoCanjeResponse toDestinoResponse(CntasPagar destino) {
        DestinoCanjeResponse response = new DestinoCanjeResponse();
        response.setCntasPagarId(destino.getId());
        response.setDocTipoId(destino.getDocTipoId());
        response.setSerie(destino.getSerie());
        response.setNumero(destino.getNumero());
        response.setFechaEmision(destino.getFechaEmision());
        response.setFechaVencimiento(destino.getFechaVencimiento());
        response.setMonedaId(destino.getMonedaId());
        response.setTotal(destino.getTotal());
        response.setSaldo(destino.getSaldo());
        response.setFlagEstado(destino.getFlagEstado());
        response.setCreatedBy(destino.getCreatedBy());
        response.setFecCreacion(destino.getFecCreacion());
        response.setUpdatedBy(destino.getUpdatedBy());
        response.setFecModificacion(destino.getFecModificacion());
        return response;
    }
}
