package com.sigre.compras.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import com.sigre.compras.dto.SolicitudCompraDetResponse;
import com.sigre.compras.dto.SolicitudCompraDetalleResponse;
import com.sigre.compras.dto.SolicitudCompraResponse;
import com.sigre.compras.entity.SolicitudCompra;
import com.sigre.compras.entity.SolicitudCompraDet;

import java.util.List;

@Mapper(componentModel = "spring")
public interface SolicitudCompraMapper {

    @Mapping(source = "nroSolicitud", target = "numero")
    @Mapping(target = "totalItems", expression = "java(entity.getLineas() != null ? entity.getLineas().size() : 0)")
    SolicitudCompraResponse toResponse(SolicitudCompra entity);

    List<SolicitudCompraResponse> toResponseList(List<SolicitudCompra> entities);

    @Mapping(source = "nroSolicitud", target = "numero")
    SolicitudCompraDetalleResponse toDetalleResponse(SolicitudCompra entity);

    @Mapping(target = "articuloCodigo", ignore = true)
    @Mapping(target = "articuloDescripcion", ignore = true)
    SolicitudCompraDetResponse toDetResponse(SolicitudCompraDet det);

    List<SolicitudCompraDetResponse> toDetResponseList(List<SolicitudCompraDet> dets);
}
