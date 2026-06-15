package com.sigre.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import com.sigre.core.dto.ArticuloAlmacenConfigRequest;
import com.sigre.core.dto.ArticuloAlmacenConfigResponse;
import com.sigre.core.entity.ArticuloAlmacenConfig;

@Mapper(componentModel = "spring")
public interface ArticuloAlmacenConfigMapper {
    ArticuloAlmacenConfig toEntity(ArticuloAlmacenConfigRequest request);
    ArticuloAlmacenConfigResponse toResponse(ArticuloAlmacenConfig entity);
    void updateEntity(ArticuloAlmacenConfigRequest request, @MappingTarget ArticuloAlmacenConfig entity);
}
