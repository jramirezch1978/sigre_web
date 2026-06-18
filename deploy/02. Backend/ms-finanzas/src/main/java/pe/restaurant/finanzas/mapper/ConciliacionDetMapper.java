package pe.restaurant.finanzas.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import pe.restaurant.finanzas.dto.request.ConciliacionDetRequest;
import pe.restaurant.finanzas.dto.response.ConciliacionDetResponse;
import pe.restaurant.finanzas.entity.ConciliacionDet;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ConciliacionDetMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "conciliacion", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    ConciliacionDet toEntity(ConciliacionDetRequest request);

    ConciliacionDetResponse toResponse(ConciliacionDet entity);

    List<ConciliacionDetResponse> toResponseList(List<ConciliacionDet> entities);
}
