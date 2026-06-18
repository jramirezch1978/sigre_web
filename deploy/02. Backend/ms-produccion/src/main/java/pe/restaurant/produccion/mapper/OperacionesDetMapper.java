package pe.restaurant.produccion.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import pe.restaurant.produccion.dto.request.OperacionDetRequest;
import pe.restaurant.produccion.dto.response.OperacionDetResponse;
import pe.restaurant.produccion.entity.OperacionesDet;

import java.util.List;

@Mapper(componentModel = "spring")
public interface OperacionesDetMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "operacionId", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    OperacionesDet toEntity(OperacionDetRequest request);

    OperacionDetResponse toResponse(OperacionesDet entity);

    List<OperacionDetResponse> toResponseList(List<OperacionesDet> entities);
}
