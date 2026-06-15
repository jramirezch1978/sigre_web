package com.sigre.produccion.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import com.sigre.produccion.dto.request.EjecutorRequest;
import com.sigre.produccion.dto.response.EjecutorResponse;
import com.sigre.produccion.entity.Ejecutor;

import java.util.List;

@Mapper(componentModel = "spring")
public interface EjecutorMapper {

    EjecutorResponse toResponse(Ejecutor entity);

    List<EjecutorResponse> toResponseList(List<Ejecutor> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    Ejecutor toEntity(EjecutorRequest request);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(EjecutorRequest request, @MappingTarget Ejecutor entity);
}
