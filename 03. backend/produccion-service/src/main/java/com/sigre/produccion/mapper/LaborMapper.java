package com.sigre.produccion.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import com.sigre.produccion.dto.request.LaborRequest;
import com.sigre.produccion.dto.response.LaborResponse;
import com.sigre.produccion.entity.Labor;

import java.util.List;

@Mapper(componentModel = "spring")
public interface LaborMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    Labor toEntity(LaborRequest request);

    LaborResponse toResponse(Labor entity);

    List<LaborResponse> toResponseList(List<Labor> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(LaborRequest request, @MappingTarget Labor entity);
}
