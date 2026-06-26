package pe.restaurant.activos.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.activos.dto.AfMaestroRequest;
import pe.restaurant.activos.dto.AfMaestroResponse;
import pe.restaurant.activos.entity.AfMaestro;

import java.util.List;

@Mapper(componentModel = "spring")
public interface AfMaestroMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "ordenCompraId", ignore = true)
    @Mapping(target = "ordenCompraLineaId", ignore = true)
    AfMaestro toEntity(AfMaestroRequest request);

    AfMaestroResponse toResponse(AfMaestro entity);

    List<AfMaestroResponse> toResponseList(List<AfMaestro> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    void updateEntity(AfMaestroRequest request, @MappingTarget AfMaestro entity);
}
