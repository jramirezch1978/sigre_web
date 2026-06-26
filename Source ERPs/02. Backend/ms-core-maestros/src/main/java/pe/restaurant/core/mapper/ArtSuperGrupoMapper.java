package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.ArtSuperGrupoRequest;
import pe.restaurant.core.dto.ArtSuperGrupoResponse;
import pe.restaurant.core.entity.ArtSuperGrupo;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ArtSuperGrupoMapper {
    ArtSuperGrupo toEntity(ArtSuperGrupoRequest request);
    ArtSuperGrupoResponse toResponse(ArtSuperGrupo entity);
    List<ArtSuperGrupoResponse> toResponseList(List<ArtSuperGrupo> entities);
    void updateEntity(ArtSuperGrupoRequest request, @MappingTarget ArtSuperGrupo entity);
}
