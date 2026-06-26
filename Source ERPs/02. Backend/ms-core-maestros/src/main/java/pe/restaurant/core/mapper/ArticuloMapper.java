package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.ArticuloRequest;
import pe.restaurant.core.dto.ArticuloResponse;
import pe.restaurant.core.entity.Articulo;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ArticuloMapper {
    Articulo toEntity(ArticuloRequest request);
    ArticuloResponse toResponse(Articulo entity);
    List<ArticuloResponse> toResponseList(List<Articulo> entities);
    void updateEntity(ArticuloRequest request, @MappingTarget Articulo entity);
}
