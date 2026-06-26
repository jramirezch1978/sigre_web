package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.DocTipoRequest;
import pe.restaurant.core.dto.DocTipoResponse;
import pe.restaurant.core.entity.DocTipo;

import java.util.List;

@Mapper(componentModel = "spring")
public interface DocTipoMapper {

    DocTipo toEntity(DocTipoRequest request);

    DocTipoResponse toResponse(DocTipo entity);

    List<DocTipoResponse> toResponseList(List<DocTipo> entities);

    void updateEntity(DocTipoRequest request, @MappingTarget DocTipo entity);
}
