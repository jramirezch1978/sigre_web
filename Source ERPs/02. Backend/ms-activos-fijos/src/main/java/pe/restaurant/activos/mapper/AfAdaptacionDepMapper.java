package pe.restaurant.activos.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.activos.dto.AfAdaptacionDepRequest;
import pe.restaurant.activos.dto.AfAdaptacionDepResponse;
import pe.restaurant.activos.entity.AfAdaptacionDep;

import java.util.List;

@Mapper(componentModel = "spring")
public interface AfAdaptacionDepMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    AfAdaptacionDep toEntity(AfAdaptacionDepRequest request);

    AfAdaptacionDepResponse toResponse(AfAdaptacionDep entity);

    List<AfAdaptacionDepResponse> toResponseList(List<AfAdaptacionDep> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    void updateEntity(AfAdaptacionDepRequest request, @MappingTarget AfAdaptacionDep entity);
}
