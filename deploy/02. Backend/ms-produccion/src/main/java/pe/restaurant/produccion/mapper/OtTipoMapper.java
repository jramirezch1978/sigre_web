package pe.restaurant.produccion.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.produccion.dto.request.OtTipoRequest;
import pe.restaurant.produccion.dto.response.OtTipoResponse;
import pe.restaurant.produccion.entity.OtTipo;

import java.util.List;

@Mapper(componentModel = "spring")
public interface OtTipoMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    OtTipo toEntity(OtTipoRequest request);

    OtTipoResponse toResponse(OtTipo entity);

    List<OtTipoResponse> toResponseList(List<OtTipo> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(OtTipoRequest request, @MappingTarget OtTipo entity);
}
