package com.sigre.produccion.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import com.sigre.produccion.dto.request.ProgramacionProduccionRequest;
import com.sigre.produccion.dto.response.ProgramacionProduccionResponse;
import com.sigre.produccion.entity.ProgramacionProduccion;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ProgramacionProduccionMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    ProgramacionProduccion toEntity(ProgramacionProduccionRequest request);

    ProgramacionProduccionResponse toResponse(ProgramacionProduccion entity);

    List<ProgramacionProduccionResponse> toResponseList(List<ProgramacionProduccion> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(ProgramacionProduccionRequest request, @MappingTarget ProgramacionProduccion entity);
}
