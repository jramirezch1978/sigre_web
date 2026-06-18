package pe.restaurant.contabilidad.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.contabilidad.dto.request.CntblLibroRequest;
import pe.restaurant.contabilidad.dto.response.CntblLibroResponse;
import pe.restaurant.contabilidad.entity.CntblLibro;

import java.util.List;

@Mapper(componentModel = "spring")
public interface CntblLibroMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    CntblLibro toEntity(CntblLibroRequest request);

    CntblLibroResponse toResponse(CntblLibro entity);

    List<CntblLibroResponse> toResponseList(List<CntblLibro> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(CntblLibroRequest request, @MappingTarget CntblLibro entity);
}
