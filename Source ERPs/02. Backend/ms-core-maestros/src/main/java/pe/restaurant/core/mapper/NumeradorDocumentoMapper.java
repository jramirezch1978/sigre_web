package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import pe.restaurant.core.dto.NumeradorDocumentoRequest;
import pe.restaurant.core.dto.NumeradorDocumentoResponse;
import pe.restaurant.core.entity.NumeradorDocumento;

import java.util.List;

@Mapper(componentModel = "spring")
public interface NumeradorDocumentoMapper {
    NumeradorDocumento toEntity(NumeradorDocumentoRequest request);
    NumeradorDocumentoResponse toResponse(NumeradorDocumento entity);
    List<NumeradorDocumentoResponse> toResponseList(List<NumeradorDocumento> entities);
}
