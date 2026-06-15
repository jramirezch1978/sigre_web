package com.sigre.contabilidad.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import com.sigre.contabilidad.dto.request.PlanContableDetRequest;
import com.sigre.contabilidad.dto.response.PlanContableDetResponse;
import com.sigre.contabilidad.entity.PlanContableDet;

import java.util.List;

@Mapper(componentModel = "spring")
public interface PlanContableDetMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    PlanContableDet toEntity(PlanContableDetRequest request);

    @Mapping(target = "nombre", source = "descCnta")
    PlanContableDetResponse toResponse(PlanContableDet entity);

    List<PlanContableDetResponse> toResponseList(List<PlanContableDet> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "planContableId", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(PlanContableDetRequest request, @MappingTarget PlanContableDet entity);
}
