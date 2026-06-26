package pe.restaurant.finanzas.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import pe.restaurant.finanzas.dto.request.RetencionRequest;
import pe.restaurant.finanzas.dto.response.RetencionResponse;
import pe.restaurant.finanzas.entity.Retencion;

import java.util.List;

@Mapper(componentModel = "spring")
public interface RetencionMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "sucursalId", ignore = true)
    @Mapping(target = "flagTabla", ignore = true)
    @Mapping(target = "tasaCambio", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    Retencion toEntity(RetencionRequest request);

    RetencionResponse toResponse(Retencion entity);

    List<RetencionResponse> toResponseList(List<Retencion> entities);
}
