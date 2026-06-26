package pe.restaurant.finanzas.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import pe.restaurant.finanzas.dto.request.DetraccionRequest;
import pe.restaurant.finanzas.dto.response.DetraccionResponse;
import pe.restaurant.finanzas.entity.Detraccion;

import java.util.List;

@Mapper(componentModel = "spring")
public interface DetraccionMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "codUsr", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    Detraccion toEntity(DetraccionRequest request);

    @Mapping(target = "cntasPagarNumero", ignore = true)
    DetraccionResponse toResponse(Detraccion entity);

    List<DetraccionResponse> toResponseList(List<Detraccion> entities);
}
