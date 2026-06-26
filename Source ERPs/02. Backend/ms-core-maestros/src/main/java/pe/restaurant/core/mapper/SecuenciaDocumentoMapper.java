package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.SecuenciaDocumentoRequest;
import pe.restaurant.core.dto.SecuenciaDocumentoResponse;
import pe.restaurant.core.entity.SecuenciaDocumento;

import java.util.List;

@Mapper(componentModel = "spring")
public interface SecuenciaDocumentoMapper {
    SecuenciaDocumento toEntity(SecuenciaDocumentoRequest request);
    SecuenciaDocumentoResponse toResponse(SecuenciaDocumento entity);
    List<SecuenciaDocumentoResponse> toResponseList(List<SecuenciaDocumento> entities);
    void updateEntity(SecuenciaDocumentoRequest request, @MappingTarget SecuenciaDocumento entity);
}
