package com.sigre.produccion.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import com.sigre.produccion.dto.request.RecetaLaborRequest;
import com.sigre.produccion.dto.response.RecetaLaborResponse;
import com.sigre.produccion.entity.RecetaLabor;

import java.util.List;

@Mapper(componentModel = "spring")
public interface RecetaLaborMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "recetaId", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    RecetaLabor toEntity(RecetaLaborRequest request);

    RecetaLaborResponse toResponse(RecetaLabor entity);

    List<RecetaLaborResponse> toResponseList(List<RecetaLabor> entities);
}
