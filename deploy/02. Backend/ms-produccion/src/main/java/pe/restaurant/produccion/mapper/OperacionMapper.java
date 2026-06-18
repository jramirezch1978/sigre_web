package pe.restaurant.produccion.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.produccion.dto.request.OperacionRequest;
import pe.restaurant.produccion.dto.response.OperacionResponse;
import pe.restaurant.produccion.entity.Operacion;

import java.util.List;

@Mapper(componentModel = "spring")
public interface OperacionMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    Operacion toEntity(OperacionRequest request);

    OperacionResponse toResponse(Operacion entity);

    List<OperacionResponse> toResponseList(List<Operacion> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(OperacionRequest request, @MappingTarget Operacion entity);
}
