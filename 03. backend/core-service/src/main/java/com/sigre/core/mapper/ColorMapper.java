package com.sigre.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import com.sigre.core.dto.ColorRequest;
import com.sigre.core.dto.ColorResponse;
import com.sigre.core.entity.Color;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ColorMapper {
    Color toEntity(ColorRequest request);
    ColorResponse toResponse(Color entity);
    List<ColorResponse> toResponseList(List<Color> entities);
    void updateEntity(ColorRequest request, @MappingTarget Color entity);
}
