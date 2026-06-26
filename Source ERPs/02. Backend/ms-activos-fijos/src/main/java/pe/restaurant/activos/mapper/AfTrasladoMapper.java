package pe.restaurant.activos.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.activos.dto.AfTrasladoRequest;
import pe.restaurant.activos.dto.AfTrasladoResponse;
import pe.restaurant.activos.entity.AfTraslado;

import java.util.List;

@Mapper(componentModel = "spring")
public interface AfTrasladoMapper {

    @Mapping(target = "id", ignore = true)
    AfTraslado toEntity(AfTrasladoRequest request);

    AfTrasladoResponse toResponse(AfTraslado entity);

    List<AfTrasladoResponse> toResponseList(List<AfTraslado> entities);

    @Mapping(target = "id", ignore = true)
    void updateEntity(AfTrasladoRequest request, @MappingTarget AfTraslado entity);
}
