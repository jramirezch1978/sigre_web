package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.ArticuloSubCategRequest;
import pe.restaurant.core.dto.ArticuloSubCategResponse;
import pe.restaurant.core.entity.ArticuloSubCateg;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ArticuloSubCategMapper {
    ArticuloSubCateg toEntity(ArticuloSubCategRequest request);
    ArticuloSubCategResponse toResponse(ArticuloSubCateg entity);
    List<ArticuloSubCategResponse> toResponseList(List<ArticuloSubCateg> entities);
    void updateEntity(ArticuloSubCategRequest request, @MappingTarget ArticuloSubCateg entity);
}
