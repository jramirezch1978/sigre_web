package pe.restaurant.produccion.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import pe.restaurant.produccion.dto.request.ParteInsumoRequest;
import pe.restaurant.produccion.dto.response.ParteInsumoResponse;
import pe.restaurant.produccion.entity.ParteProduccionInsumo;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ParteInsumoMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "parteProduccionId", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    ParteProduccionInsumo toEntity(ParteInsumoRequest request);

    ParteInsumoResponse toResponse(ParteProduccionInsumo entity);

    List<ParteInsumoResponse> toResponseList(List<ParteProduccionInsumo> entities);
}
