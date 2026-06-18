package pe.restaurant.produccion.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.produccion.dto.request.ParteProduccionRequest;
import pe.restaurant.produccion.dto.response.ParteProduccionResponse;
import pe.restaurant.produccion.entity.ParteProduccion;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ParteProduccionMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    ParteProduccion toEntity(ParteProduccionRequest request);

    ParteProduccionResponse toResponse(ParteProduccion entity);

    List<ParteProduccionResponse> toResponseList(List<ParteProduccion> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(ParteProduccionRequest request, @MappingTarget ParteProduccion entity);
}
