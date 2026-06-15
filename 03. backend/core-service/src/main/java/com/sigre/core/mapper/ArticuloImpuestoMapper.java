package com.sigre.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import com.sigre.core.dto.ArticuloImpuestoResponse;
import com.sigre.core.entity.ArticuloImpuesto;
import com.sigre.core.entity.TiposImpuesto;

@Mapper(componentModel = "spring")
public interface ArticuloImpuestoMapper {

    @Mapping(target = "id", source = "entity.id")
    @Mapping(target = "articuloId", source = "entity.articuloId")
    @Mapping(target = "tiposImpuestoId", source = "entity.tiposImpuestoId")
    @Mapping(target = "orden", source = "entity.orden")
    @Mapping(target = "tipoImpuesto", source = "impuesto.tipoImpuesto")
    @Mapping(target = "descImpuesto", source = "impuesto.descImpuesto")
    @Mapping(target = "tasaImpuesto", source = "impuesto.tasaImpuesto")
    @Mapping(target = "signo", source = "impuesto.signo")
    @Mapping(target = "flagIgv", source = "impuesto.flagIgv")
    @Mapping(target = "tipoCalculo", source = "impuesto.tipoCalculo")
    ArticuloImpuestoResponse toResponse(ArticuloImpuesto entity, TiposImpuesto impuesto);
}
