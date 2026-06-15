package com.sigre.core.mapper;

import org.mapstruct.Mapper;
import com.sigre.core.dto.ArticuloProveedorResponse;
import com.sigre.core.entity.ArticuloProveedor;

@Mapper(componentModel = "spring")
public interface ArticuloProveedorMapper {
    ArticuloProveedorResponse toResponse(ArticuloProveedor entity);
}
