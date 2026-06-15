package com.sigre.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import com.sigre.core.dto.ConversionUnidadRequest;
import com.sigre.core.dto.ConversionUnidadResponse;
import com.sigre.core.entity.ConversionUnidad;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ConversionUnidadMapper {
    ConversionUnidad toEntity(ConversionUnidadRequest request);
    ConversionUnidadResponse toResponse(ConversionUnidad entity);
    List<ConversionUnidadResponse> toResponseList(List<ConversionUnidad> entities);
    void updateEntity(ConversionUnidadRequest request, @MappingTarget ConversionUnidad entity);
}
