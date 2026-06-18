package pe.restaurant.activos.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.activos.dto.AfMatrizSubClaseRequest;
import pe.restaurant.activos.dto.AfMatrizSubClaseResponse;
import pe.restaurant.activos.entity.AfMatrizSubClase;

import java.util.List;

@Mapper(componentModel = "spring")
public interface AfMatrizSubClaseMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    AfMatrizSubClase toEntity(AfMatrizSubClaseRequest request);

    AfMatrizSubClaseResponse toResponse(AfMatrizSubClase entity);

    List<AfMatrizSubClaseResponse> toResponseList(List<AfMatrizSubClase> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(AfMatrizSubClaseRequest request, @MappingTarget AfMatrizSubClase entity);
}
