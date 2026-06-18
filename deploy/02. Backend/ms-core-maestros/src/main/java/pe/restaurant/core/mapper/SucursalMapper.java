package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.SucursalRequest;
import pe.restaurant.core.dto.SucursalResponse;
import pe.restaurant.core.entity.Sucursal;

import java.util.List;

@Mapper(componentModel = "spring")
public interface SucursalMapper {
    Sucursal toEntity(SucursalRequest request);
    SucursalResponse toResponse(Sucursal entity);
    List<SucursalResponse> toResponseList(List<Sucursal> entities);
    void updateEntity(SucursalRequest request, @MappingTarget Sucursal entity);
}
