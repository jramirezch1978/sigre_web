package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.DocTipoUsuarioRequest;
import pe.restaurant.core.dto.DocTipoUsuarioResponse;
import pe.restaurant.core.entity.DocTipoUsuario;

import java.util.List;

@Mapper(componentModel = "spring")
public interface DocTipoUsuarioMapper {
    DocTipoUsuario toEntity(DocTipoUsuarioRequest request);
    DocTipoUsuarioResponse toResponse(DocTipoUsuario entity);
    List<DocTipoUsuarioResponse> toResponseList(List<DocTipoUsuario> entities);
    void updateEntity(DocTipoUsuarioRequest request, @MappingTarget DocTipoUsuario entity);
}
