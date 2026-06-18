package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.TipoDocIdentidadRequest;
import pe.restaurant.core.dto.TipoDocIdentidadResponse;
import pe.restaurant.core.entity.TipoDocIdentidad;

import java.util.List;

@Mapper(componentModel = "spring")
public interface TipoDocIdentidadMapper {
    TipoDocIdentidadResponse toResponse(TipoDocIdentidad entity);
    List<TipoDocIdentidadResponse> toResponseList(List<TipoDocIdentidad> entities);
    TipoDocIdentidad toEntity(TipoDocIdentidadRequest request);
    void updateEntity(TipoDocIdentidadRequest request, @MappingTarget TipoDocIdentidad entity);
}
