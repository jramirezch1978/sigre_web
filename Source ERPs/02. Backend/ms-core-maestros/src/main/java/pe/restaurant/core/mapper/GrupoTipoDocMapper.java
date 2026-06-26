package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.GrupoTipoDocRequest;
import pe.restaurant.core.dto.GrupoTipoDocResponse;
import pe.restaurant.core.entity.GrupoTipoDoc;

import java.util.List;

@Mapper(componentModel = "spring")
public interface GrupoTipoDocMapper {
    GrupoTipoDoc toEntity(GrupoTipoDocRequest request);
    GrupoTipoDocResponse toResponse(GrupoTipoDoc entity);
    List<GrupoTipoDocResponse> toResponseList(List<GrupoTipoDoc> entities);
    void updateEntity(GrupoTipoDocRequest request, @MappingTarget GrupoTipoDoc entity);
}
