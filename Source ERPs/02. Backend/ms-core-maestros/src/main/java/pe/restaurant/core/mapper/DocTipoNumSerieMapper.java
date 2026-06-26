package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.DocTipoNumSerieRequest;
import pe.restaurant.core.dto.DocTipoNumSerieResponse;
import pe.restaurant.core.entity.DocTipoNumSerie;

import java.util.List;

@Mapper(componentModel = "spring")
public interface DocTipoNumSerieMapper {
    DocTipoNumSerie toEntity(DocTipoNumSerieRequest request);
    DocTipoNumSerieResponse toResponse(DocTipoNumSerie entity);
    List<DocTipoNumSerieResponse> toResponseList(List<DocTipoNumSerie> entities);
    void updateEntity(DocTipoNumSerieRequest request, @MappingTarget DocTipoNumSerie entity);
}
