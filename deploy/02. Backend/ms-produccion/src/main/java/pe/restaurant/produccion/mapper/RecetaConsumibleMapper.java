package pe.restaurant.produccion.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import pe.restaurant.produccion.dto.request.RecetaConsumibleRequest;
import pe.restaurant.produccion.dto.response.RecetaConsumibleResponse;
import pe.restaurant.produccion.entity.RecetaLaborConsumible;

import java.util.List;

@Mapper(componentModel = "spring")
public interface RecetaConsumibleMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "recetaPadreId", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    RecetaLaborConsumible toEntity(RecetaConsumibleRequest request);

    @Mapping(target = "articuloCodigo", ignore = true)
    @Mapping(target = "articuloDescripcion", ignore = true)
    RecetaConsumibleResponse toResponse(RecetaLaborConsumible entity);

    List<RecetaConsumibleResponse> toResponseList(List<RecetaLaborConsumible> entities);
}
