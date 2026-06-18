package pe.restaurant.almacen.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.almacen.dto.MotivoTrasladoRequest;
import pe.restaurant.almacen.dto.MotivoTrasladoResponse;
import pe.restaurant.almacen.entity.MotivoTraslado;

import java.util.List;

@Mapper(componentModel = "spring")
public interface MotivoTrasladoMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    MotivoTraslado toEntity(MotivoTrasladoRequest request);

    MotivoTrasladoResponse toResponse(MotivoTraslado entity);

    List<MotivoTrasladoResponse> toResponseList(List<MotivoTraslado> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    void updateEntity(MotivoTrasladoRequest request, @MappingTarget MotivoTraslado entity);
}
