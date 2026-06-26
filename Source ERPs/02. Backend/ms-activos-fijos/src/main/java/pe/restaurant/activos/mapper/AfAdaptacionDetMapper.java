package pe.restaurant.activos.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.activos.dto.AfAdaptacionDetRequest;
import pe.restaurant.activos.dto.AfAdaptacionDetResponse;
import pe.restaurant.activos.entity.AfAdaptacionDet;

import java.util.List;

@Mapper(componentModel = "spring")
public interface AfAdaptacionDetMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    AfAdaptacionDet toEntity(AfAdaptacionDetRequest request);

    AfAdaptacionDetResponse toResponse(AfAdaptacionDet entity);

    List<AfAdaptacionDetResponse> toResponseList(List<AfAdaptacionDet> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    void updateEntity(AfAdaptacionDetRequest request, @MappingTarget AfAdaptacionDet entity);
}
