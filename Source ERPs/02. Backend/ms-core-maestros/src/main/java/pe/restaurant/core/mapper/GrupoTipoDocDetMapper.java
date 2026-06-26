package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.GrupoTipoDocDetRequest;
import pe.restaurant.core.dto.GrupoTipoDocDetResponse;
import pe.restaurant.core.entity.GrupoTipoDocDet;

import java.util.List;

@Mapper(componentModel = "spring")
public interface GrupoTipoDocDetMapper {
    GrupoTipoDocDet toEntity(GrupoTipoDocDetRequest request);
    GrupoTipoDocDetResponse toResponse(GrupoTipoDocDet entity);
    List<GrupoTipoDocDetResponse> toResponseList(List<GrupoTipoDocDet> entities);
    void updateEntity(GrupoTipoDocDetRequest request, @MappingTarget GrupoTipoDocDet entity);
}
