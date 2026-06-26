package pe.restaurant.activos.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.activos.dto.AfOperacionesRequest;
import pe.restaurant.activos.dto.AfOperacionesResponse;
import pe.restaurant.activos.entity.AfOperaciones;

import java.util.List;

@Mapper(componentModel = "spring")
public interface AfOperacionesMapper {

    @Mapping(target = "id", ignore = true)
    AfOperaciones toEntity(AfOperacionesRequest request);

    AfOperacionesResponse toResponse(AfOperaciones entity);

    List<AfOperacionesResponse> toResponseList(List<AfOperaciones> entities);

    @Mapping(target = "id", ignore = true)
    void updateEntity(AfOperacionesRequest request, @MappingTarget AfOperaciones entity);
}
