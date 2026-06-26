package pe.restaurant.produccion.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.produccion.dto.request.RecetaRequest;
import pe.restaurant.produccion.dto.response.RecetaResponse;
import pe.restaurant.produccion.entity.Receta;

import java.util.List;

@Mapper(componentModel = "spring")
public interface RecetaMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    Receta toEntity(RecetaRequest request);

    RecetaResponse toResponse(Receta entity);

    List<RecetaResponse> toResponseList(List<Receta> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(RecetaRequest request, @MappingTarget Receta entity);
}
