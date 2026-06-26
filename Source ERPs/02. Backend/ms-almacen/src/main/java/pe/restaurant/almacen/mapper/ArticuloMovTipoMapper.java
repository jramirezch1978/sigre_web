package pe.restaurant.almacen.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.almacen.dto.ArticuloMovTipoRequest;
import pe.restaurant.almacen.dto.ArticuloMovTipoResponse;
import pe.restaurant.almacen.entity.ArticuloMovTipo;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ArticuloMovTipoMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    ArticuloMovTipo toEntity(ArticuloMovTipoRequest request);

    ArticuloMovTipoResponse toResponse(ArticuloMovTipo entity);

    List<ArticuloMovTipoResponse> toResponseList(List<ArticuloMovTipo> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(ArticuloMovTipoRequest request, @MappingTarget ArticuloMovTipo entity);
}
