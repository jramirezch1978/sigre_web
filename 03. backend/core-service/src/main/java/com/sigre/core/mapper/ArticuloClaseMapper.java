package com.sigre.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import com.sigre.core.dto.ArticuloClaseRequest;
import com.sigre.core.dto.ArticuloClaseResponse;
import com.sigre.core.entity.ArticuloClase;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ArticuloClaseMapper {
    ArticuloClase toEntity(ArticuloClaseRequest request);
    ArticuloClaseResponse toResponse(ArticuloClase entity);
    List<ArticuloClaseResponse> toResponseList(List<ArticuloClase> entities);
    void updateEntity(ArticuloClaseRequest request, @MappingTarget ArticuloClase entity);
}
