package pe.restaurant.almacen.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.almacen.dto.ArticuloBonificacionRequest;
import pe.restaurant.almacen.dto.ArticuloBonificacionResponse;
import pe.restaurant.almacen.entity.ArticuloBonificacion;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ArticuloBonificacionMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    ArticuloBonificacion toEntity(ArticuloBonificacionRequest request);

    ArticuloBonificacionResponse toResponse(ArticuloBonificacion entity);

    List<ArticuloBonificacionResponse> toResponseList(List<ArticuloBonificacion> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(ArticuloBonificacionRequest request, @MappingTarget ArticuloBonificacion entity);
}
