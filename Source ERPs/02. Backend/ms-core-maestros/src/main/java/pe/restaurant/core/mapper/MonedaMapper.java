package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.MonedaRequest;
import pe.restaurant.core.dto.MonedaResponse;
import pe.restaurant.core.entity.Moneda;

import java.util.List;

@Mapper(componentModel = "spring")
public interface MonedaMapper {
    Moneda toEntity(MonedaRequest request);
    MonedaResponse toResponse(Moneda entity);
    List<MonedaResponse> toResponseList(List<Moneda> entities);
    void updateEntity(MonedaRequest request, @MappingTarget Moneda entity);
}
