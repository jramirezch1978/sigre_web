package pe.restaurant.activos.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.activos.dto.AfHistorialRequest;
import pe.restaurant.activos.dto.AfHistorialResponse;
import pe.restaurant.activos.entity.AfHistorial;

import java.util.List;

@Mapper(componentModel = "spring")
public interface AfHistorialMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    AfHistorial toEntity(AfHistorialRequest request);

    AfHistorialResponse toResponse(AfHistorial entity);

    List<AfHistorialResponse> toResponseList(List<AfHistorial> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(AfHistorialRequest request, @MappingTarget AfHistorial entity);
}
