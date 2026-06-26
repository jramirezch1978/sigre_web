package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.DetraccionRequest;
import pe.restaurant.core.dto.DetraccionResponse;
import pe.restaurant.core.entity.Detraccion;

import java.util.List;

@Mapper(componentModel = "spring")
public interface DetraccionMapper {
    Detraccion toEntity(DetraccionRequest request);
    DetraccionResponse toResponse(Detraccion entity);
    List<DetraccionResponse> toResponseList(List<Detraccion> entities);
    void updateEntity(DetraccionRequest request, @MappingTarget Detraccion entity);
}
