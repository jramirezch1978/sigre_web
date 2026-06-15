package com.sigre.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import com.sigre.core.dto.ArticuloRequest;
import com.sigre.core.dto.ArticuloResponse;
import com.sigre.core.entity.Articulo;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ArticuloMapper {
    Articulo toEntity(ArticuloRequest request);
    ArticuloResponse toResponse(Articulo entity);
    List<ArticuloResponse> toResponseList(List<Articulo> entities);
    void updateEntity(ArticuloRequest request, @MappingTarget Articulo entity);
}
