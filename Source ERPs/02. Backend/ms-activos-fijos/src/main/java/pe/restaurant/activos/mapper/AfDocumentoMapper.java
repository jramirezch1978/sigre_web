package pe.restaurant.activos.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.activos.dto.AfDocumentoRequest;
import pe.restaurant.activos.dto.AfDocumentoResponse;
import pe.restaurant.activos.entity.AfDocumento;

import java.util.List;

@Mapper(componentModel = "spring")
public interface AfDocumentoMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    AfDocumento toEntity(AfDocumentoRequest request);

    AfDocumentoResponse toResponse(AfDocumento entity);

    List<AfDocumentoResponse> toResponseList(List<AfDocumento> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(AfDocumentoRequest request, @MappingTarget AfDocumento entity);
}
