package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import pe.restaurant.core.dto.ArticuloProveedorResponse;
import pe.restaurant.core.entity.ArticuloProveedor;

@Mapper(componentModel = "spring")
public interface ArticuloProveedorMapper {
    ArticuloProveedorResponse toResponse(ArticuloProveedor entity);
}
