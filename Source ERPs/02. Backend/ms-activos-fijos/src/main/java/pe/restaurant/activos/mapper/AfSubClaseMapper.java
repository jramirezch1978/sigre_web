package pe.restaurant.activos.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.activos.dto.AfSubClaseRequest;
import pe.restaurant.activos.dto.AfSubClaseResponse;
import pe.restaurant.activos.entity.AfSubClase;

import java.util.List;

@Mapper(componentModel = "spring")
public interface AfSubClaseMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "afClase", ignore = true)
    AfSubClase toEntity(AfSubClaseRequest request);

    AfSubClaseResponse toResponse(AfSubClase entity);

    List<AfSubClaseResponse> toResponseList(List<AfSubClase> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "afClase", ignore = true)
    void updateEntity(AfSubClaseRequest request, @MappingTarget AfSubClase entity);
}
