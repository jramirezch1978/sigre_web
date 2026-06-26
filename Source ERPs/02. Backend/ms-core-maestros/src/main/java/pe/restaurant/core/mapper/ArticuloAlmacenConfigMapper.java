package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.ArticuloAlmacenConfigRequest;
import pe.restaurant.core.dto.ArticuloAlmacenConfigResponse;
import pe.restaurant.core.entity.ArticuloAlmacenConfig;

@Mapper(componentModel = "spring")
public interface ArticuloAlmacenConfigMapper {
    ArticuloAlmacenConfig toEntity(ArticuloAlmacenConfigRequest request);
    ArticuloAlmacenConfigResponse toResponse(ArticuloAlmacenConfig entity);
    void updateEntity(ArticuloAlmacenConfigRequest request, @MappingTarget ArticuloAlmacenConfig entity);
}
