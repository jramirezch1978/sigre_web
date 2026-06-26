package pe.restaurant.activos.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.activos.dto.AfPolizaActivoRequest;
import pe.restaurant.activos.dto.AfPolizaActivoResponse;
import pe.restaurant.activos.entity.AfPolizaActivo;

import java.util.List;

@Mapper(componentModel = "spring")
public interface AfPolizaActivoMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    AfPolizaActivo toEntity(AfPolizaActivoRequest request);

    AfPolizaActivoResponse toResponse(AfPolizaActivo entity);

    List<AfPolizaActivoResponse> toResponseList(List<AfPolizaActivo> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    void updateEntity(AfPolizaActivoRequest request, @MappingTarget AfPolizaActivo entity);
}
