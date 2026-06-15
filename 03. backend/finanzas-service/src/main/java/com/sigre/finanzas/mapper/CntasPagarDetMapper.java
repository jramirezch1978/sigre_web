package com.sigre.finanzas.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import com.sigre.finanzas.dto.request.CntasPagarDetRequest;
import com.sigre.finanzas.dto.response.CntasPagarDetResponse;
import com.sigre.finanzas.entity.CntasPagarDet;

import java.util.List;

@Mapper(componentModel = "spring")
public interface CntasPagarDetMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "cntasPagar", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    CntasPagarDet toEntity(CntasPagarDetRequest request);

    @Mapping(target = "cntasPagarId", source = "cntasPagar.id")
    @Mapping(target = "impuestos", ignore = true)
    CntasPagarDetResponse toResponse(CntasPagarDet entity);

    List<CntasPagarDetResponse> toResponseList(List<CntasPagarDet> entities);
}
