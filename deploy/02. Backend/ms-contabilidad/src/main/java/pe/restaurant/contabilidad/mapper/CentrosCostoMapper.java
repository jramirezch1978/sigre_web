package pe.restaurant.contabilidad.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.contabilidad.dto.request.CentrosCostoRequest;
import pe.restaurant.contabilidad.dto.response.CentrosCostoResponse;
import pe.restaurant.contabilidad.entity.CentrosCosto;

import java.util.List;

@Mapper(componentModel = "spring")
public interface CentrosCostoMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    CentrosCosto toEntity(CentrosCostoRequest request);

    CentrosCostoResponse toResponse(CentrosCosto entity);

    List<CentrosCostoResponse> toResponseList(List<CentrosCosto> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(CentrosCostoRequest request, @MappingTarget CentrosCosto entity);
}
