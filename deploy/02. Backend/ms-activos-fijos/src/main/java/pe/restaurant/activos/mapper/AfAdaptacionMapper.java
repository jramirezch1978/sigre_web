package pe.restaurant.activos.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.activos.dto.AfAdaptacionRequest;
import pe.restaurant.activos.dto.AfAdaptacionResponse;
import pe.restaurant.activos.entity.AfAdaptacion;

import java.util.List;

@Mapper(componentModel = "spring")
public interface AfAdaptacionMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "estado", ignore = true)
    AfAdaptacion toEntity(AfAdaptacionRequest request);

    AfAdaptacionResponse toResponse(AfAdaptacion entity);

    List<AfAdaptacionResponse> toResponseList(List<AfAdaptacion> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "estado", ignore = true)
    void updateEntity(AfAdaptacionRequest request, @MappingTarget AfAdaptacion entity);
}
