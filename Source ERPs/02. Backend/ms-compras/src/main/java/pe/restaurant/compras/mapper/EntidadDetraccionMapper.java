package pe.restaurant.compras.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.compras.dto.EntidadDetraccionRequest;
import pe.restaurant.compras.dto.EntidadDetraccionResponse;
import pe.restaurant.compras.entity.EntidadDetraccion;

import java.util.List;

@Mapper(componentModel = "spring")
public interface EntidadDetraccionMapper {
    EntidadDetraccion toEntity(EntidadDetraccionRequest request);
    EntidadDetraccionResponse toResponse(EntidadDetraccion entity);
    List<EntidadDetraccionResponse> toResponseList(List<EntidadDetraccion> entities);
    void updateEntity(EntidadDetraccionRequest request, @MappingTarget EntidadDetraccion entity);
}
