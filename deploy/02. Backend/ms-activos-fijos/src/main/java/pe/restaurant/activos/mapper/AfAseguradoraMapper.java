package pe.restaurant.activos.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.activos.dto.AfAseguradoraRequest;
import pe.restaurant.activos.dto.AfAseguradoraResponse;
import pe.restaurant.activos.entity.AfAseguradora;

import java.util.List;

@Mapper(componentModel = "spring")
public interface AfAseguradoraMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    AfAseguradora toEntity(AfAseguradoraRequest request);

    AfAseguradoraResponse toResponse(AfAseguradora entity);

    List<AfAseguradoraResponse> toResponseList(List<AfAseguradora> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    void updateEntity(AfAseguradoraRequest request, @MappingTarget AfAseguradora entity);
}
