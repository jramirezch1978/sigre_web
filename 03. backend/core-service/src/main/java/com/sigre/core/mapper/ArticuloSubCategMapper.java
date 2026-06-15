package com.sigre.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import com.sigre.core.dto.ArticuloSubCategRequest;
import com.sigre.core.dto.ArticuloSubCategResponse;
import com.sigre.core.entity.ArticuloSubCateg;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ArticuloSubCategMapper {
    ArticuloSubCateg toEntity(ArticuloSubCategRequest request);
    ArticuloSubCategResponse toResponse(ArticuloSubCateg entity);
    List<ArticuloSubCategResponse> toResponseList(List<ArticuloSubCateg> entities);
    void updateEntity(ArticuloSubCategRequest request, @MappingTarget ArticuloSubCateg entity);
}
