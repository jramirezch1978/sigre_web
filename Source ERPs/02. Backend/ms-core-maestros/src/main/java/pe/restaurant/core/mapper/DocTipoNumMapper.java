package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.DocTipoNumRequest;
import pe.restaurant.core.dto.DocTipoNumResponse;
import pe.restaurant.core.entity.DocTipoNum;

import java.util.List;

@Mapper(componentModel = "spring")
public interface DocTipoNumMapper {
    DocTipoNum toEntity(DocTipoNumRequest request);
    DocTipoNumResponse toResponse(DocTipoNum entity);
    List<DocTipoNumResponse> toResponseList(List<DocTipoNum> entities);
    void updateEntity(DocTipoNumRequest request, @MappingTarget DocTipoNum entity);
}
