package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.EntidadDireccionRequest;
import pe.restaurant.core.dto.EntidadDireccionResponse;
import pe.restaurant.core.entity.EntidadDireccion;

import java.util.List;

@Mapper(componentModel = "spring")
public interface EntidadDireccionMapper {
    EntidadDireccion toEntity(EntidadDireccionRequest request);
    EntidadDireccionResponse toResponse(EntidadDireccion entity);
    List<EntidadDireccionResponse> toResponseList(List<EntidadDireccion> entities);
    void updateEntity(EntidadDireccionRequest request, @MappingTarget EntidadDireccion entity);
}
