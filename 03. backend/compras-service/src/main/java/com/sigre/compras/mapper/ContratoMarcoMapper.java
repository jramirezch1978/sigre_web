package com.sigre.compras.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import com.sigre.compras.dto.ContratoMarcoRequest;
import com.sigre.compras.entity.ContratoMarco;

@Mapper(componentModel = "spring")
public interface ContratoMarcoMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "nroContrato", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    ContratoMarco toEntity(ContratoMarcoRequest request);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "nroContrato", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(ContratoMarcoRequest request, @MappingTarget ContratoMarco entity);
}
