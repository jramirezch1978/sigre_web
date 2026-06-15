package com.sigre.produccion.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import com.sigre.produccion.dto.request.OtAdministracionRequest;
import com.sigre.produccion.dto.response.OtAdministracionResponse;
import com.sigre.produccion.entity.OtAdministracion;

import java.util.List;

@Mapper(componentModel = "spring")
public interface OtAdministracionMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    OtAdministracion toEntity(OtAdministracionRequest request);

    OtAdministracionResponse toResponse(OtAdministracion entity);

    List<OtAdministracionResponse> toResponseList(List<OtAdministracion> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(OtAdministracionRequest request, @MappingTarget OtAdministracion entity);
}
