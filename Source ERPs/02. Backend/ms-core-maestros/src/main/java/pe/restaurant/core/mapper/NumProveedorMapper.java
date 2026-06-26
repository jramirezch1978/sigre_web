package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.NumProveedorRequest;
import pe.restaurant.core.dto.NumProveedorResponse;
import pe.restaurant.core.entity.NumProveedor;

import java.util.List;

@Mapper(componentModel = "spring")
public interface NumProveedorMapper {
    NumProveedor toEntity(NumProveedorRequest request);
    NumProveedorResponse toResponse(NumProveedor entity);
    List<NumProveedorResponse> toResponseList(List<NumProveedor> entities);
    void updateEntity(NumProveedorRequest request, @MappingTarget NumProveedor entity);
}
