package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.ArticuloClaseRequest;
import pe.restaurant.core.dto.ArticuloClaseResponse;
import pe.restaurant.core.entity.ArticuloClase;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ArticuloClaseMapper {
    ArticuloClase toEntity(ArticuloClaseRequest request);
    ArticuloClaseResponse toResponse(ArticuloClase entity);
    List<ArticuloClaseResponse> toResponseList(List<ArticuloClase> entities);
    void updateEntity(ArticuloClaseRequest request, @MappingTarget ArticuloClase entity);
}
