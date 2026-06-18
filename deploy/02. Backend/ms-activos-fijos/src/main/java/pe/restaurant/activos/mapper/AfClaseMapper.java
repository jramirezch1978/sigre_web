package pe.restaurant.activos.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.activos.dto.AfClaseRequest;
import pe.restaurant.activos.dto.AfClaseResponse;
import pe.restaurant.activos.entity.AfClase;

import java.util.List;

@Mapper(componentModel = "spring")
public interface AfClaseMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    AfClase toEntity(AfClaseRequest request);

    AfClaseResponse toResponse(AfClase entity);

    List<AfClaseResponse> toResponseList(List<AfClase> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    void updateEntity(AfClaseRequest request, @MappingTarget AfClase entity);
}
