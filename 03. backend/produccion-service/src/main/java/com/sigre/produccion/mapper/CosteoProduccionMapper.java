package com.sigre.produccion.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import com.sigre.produccion.dto.request.CosteoProduccionRequest;
import com.sigre.produccion.dto.response.CosteoProduccionResponse;
import com.sigre.produccion.entity.CosteoProduccion;

import java.util.List;

@Mapper(componentModel = "spring")
public interface CosteoProduccionMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    CosteoProduccion toEntity(CosteoProduccionRequest request);

    CosteoProduccionResponse toResponse(CosteoProduccion entity);

    List<CosteoProduccionResponse> toResponseList(List<CosteoProduccion> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(CosteoProduccionRequest request, @MappingTarget CosteoProduccion entity);
}
