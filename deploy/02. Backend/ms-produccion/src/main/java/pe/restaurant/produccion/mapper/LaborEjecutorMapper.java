package pe.restaurant.produccion.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.produccion.dto.request.LaborEjecutorRequest;
import pe.restaurant.produccion.dto.response.LaborEjecutorResponse;
import pe.restaurant.produccion.entity.LaborEjecutor;

import java.util.List;

@Mapper(componentModel = "spring")
public interface LaborEjecutorMapper {

    LaborEjecutorResponse toResponse(LaborEjecutor entity);

    List<LaborEjecutorResponse> toResponseList(List<LaborEjecutor> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "laborId", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    LaborEjecutor toEntity(LaborEjecutorRequest request);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "laborId", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(LaborEjecutorRequest request, @MappingTarget LaborEjecutor entity);
}
