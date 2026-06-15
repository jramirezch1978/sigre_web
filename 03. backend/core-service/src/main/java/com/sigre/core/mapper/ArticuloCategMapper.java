package com.sigre.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import com.sigre.core.dto.ArticuloCategRequest;
import com.sigre.core.dto.ArticuloCategResponse;
import com.sigre.core.entity.ArticuloCateg;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ArticuloCategMapper {
    ArticuloCateg toEntity(ArticuloCategRequest request);
    ArticuloCategResponse toResponse(ArticuloCateg entity);
    List<ArticuloCategResponse> toResponseList(List<ArticuloCateg> entities);
    void updateEntity(ArticuloCategRequest request, @MappingTarget ArticuloCateg entity);
}
