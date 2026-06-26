package pe.restaurant.contabilidad.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.contabilidad.dto.request.CntblTipoDetraccionRequest;
import pe.restaurant.contabilidad.dto.response.CntblTipoDetraccionResponse;
import pe.restaurant.contabilidad.entity.CntblTipoDetraccion;

import java.util.List;

@Mapper(componentModel = "spring")
public interface CntblTipoDetraccionMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    CntblTipoDetraccion toEntity(CntblTipoDetraccionRequest request);

    CntblTipoDetraccionResponse toResponse(CntblTipoDetraccion entity);

    List<CntblTipoDetraccionResponse> toResponseList(List<CntblTipoDetraccion> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(CntblTipoDetraccionRequest request, @MappingTarget CntblTipoDetraccion entity);
}
