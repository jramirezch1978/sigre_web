package pe.restaurant.activos.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.activos.dto.AfValuacionRequest;
import pe.restaurant.activos.dto.AfValuacionResponse;
import pe.restaurant.activos.entity.AfValuacion;

import java.util.List;

@Mapper(componentModel = "spring")
public interface AfValuacionMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "estado", ignore = true)
    AfValuacion toEntity(AfValuacionRequest request);

    AfValuacionResponse toResponse(AfValuacion entity);

    List<AfValuacionResponse> toResponseList(List<AfValuacion> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "estado", ignore = true)
    void updateEntity(AfValuacionRequest request, @MappingTarget AfValuacion entity);
}
