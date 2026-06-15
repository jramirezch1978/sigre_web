package com.sigre.finanzas.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import com.sigre.finanzas.dto.request.ConciliacionBancariaRequest;
import com.sigre.finanzas.dto.response.ConciliacionBancariaResponse;
import com.sigre.finanzas.entity.ConciliacionBancaria;

import java.util.List;

@Mapper(componentModel = "spring", uses = {ConciliacionDetMapper.class})
public interface ConciliacionBancariaMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "diferencia", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "detalles", ignore = true)
    ConciliacionBancaria toEntity(ConciliacionBancariaRequest request);

    @Mapping(target = "bancoCntaCodigo", ignore = true)
    ConciliacionBancariaResponse toResponse(ConciliacionBancaria entity);

    List<ConciliacionBancariaResponse> toResponseList(List<ConciliacionBancaria> entities);
}
