package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.ConversionUnidadRequest;
import pe.restaurant.core.dto.ConversionUnidadResponse;
import pe.restaurant.core.entity.ConversionUnidad;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ConversionUnidadMapper {
    ConversionUnidad toEntity(ConversionUnidadRequest request);
    ConversionUnidadResponse toResponse(ConversionUnidad entity);
    List<ConversionUnidadResponse> toResponseList(List<ConversionUnidad> entities);
    void updateEntity(ConversionUnidadRequest request, @MappingTarget ConversionUnidad entity);
}
