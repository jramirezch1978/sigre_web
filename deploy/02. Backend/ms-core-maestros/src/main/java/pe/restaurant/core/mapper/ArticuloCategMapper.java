package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.ArticuloCategRequest;
import pe.restaurant.core.dto.ArticuloCategResponse;
import pe.restaurant.core.entity.ArticuloCateg;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ArticuloCategMapper {
    ArticuloCateg toEntity(ArticuloCategRequest request);
    ArticuloCategResponse toResponse(ArticuloCateg entity);
    List<ArticuloCategResponse> toResponseList(List<ArticuloCateg> entities);
    void updateEntity(ArticuloCategRequest request, @MappingTarget ArticuloCateg entity);
}
