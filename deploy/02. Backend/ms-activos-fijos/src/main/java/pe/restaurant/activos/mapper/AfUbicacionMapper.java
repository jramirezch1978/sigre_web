package pe.restaurant.activos.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.activos.dto.AfUbicacionRequest;
import pe.restaurant.activos.dto.AfUbicacionResponse;
import pe.restaurant.activos.entity.AfUbicacion;

import java.util.List;

@Mapper(componentModel = "spring")
public interface AfUbicacionMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    AfUbicacion toEntity(AfUbicacionRequest request);

    AfUbicacionResponse toResponse(AfUbicacion entity);

    List<AfUbicacionResponse> toResponseList(List<AfUbicacion> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    void updateEntity(AfUbicacionRequest request, @MappingTarget AfUbicacion entity);
}
