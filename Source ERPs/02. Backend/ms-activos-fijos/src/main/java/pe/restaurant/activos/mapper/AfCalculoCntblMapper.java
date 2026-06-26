package pe.restaurant.activos.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.activos.dto.AfCalculoCntblRequest;
import pe.restaurant.activos.dto.AfCalculoCntblResponse;
import pe.restaurant.activos.entity.AfCalculoCntbl;

import java.util.List;

@Mapper(componentModel = "spring")
public interface AfCalculoCntblMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    AfCalculoCntbl toEntity(AfCalculoCntblRequest request);

    AfCalculoCntblResponse toResponse(AfCalculoCntbl entity);

    List<AfCalculoCntblResponse> toResponseList(List<AfCalculoCntbl> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    void updateEntity(AfCalculoCntblRequest request, @MappingTarget AfCalculoCntbl entity);
}
