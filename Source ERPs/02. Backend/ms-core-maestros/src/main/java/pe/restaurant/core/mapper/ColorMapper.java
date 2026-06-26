package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.ColorRequest;
import pe.restaurant.core.dto.ColorResponse;
import pe.restaurant.core.entity.Color;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ColorMapper {
    Color toEntity(ColorRequest request);
    ColorResponse toResponse(Color entity);
    List<ColorResponse> toResponseList(List<Color> entities);
    void updateEntity(ColorRequest request, @MappingTarget Color entity);
}
