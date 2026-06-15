package com.sigre.produccion.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import com.sigre.produccion.dto.request.ControlCalidadRequest;
import com.sigre.produccion.dto.response.ControlCalidadResponse;
import com.sigre.produccion.entity.ControlCalidad;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ControlCalidadMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    ControlCalidad toEntity(ControlCalidadRequest request);

    ControlCalidadResponse toResponse(ControlCalidad entity);

    List<ControlCalidadResponse> toResponseList(List<ControlCalidad> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(ControlCalidadRequest request, @MappingTarget ControlCalidad entity);
}
