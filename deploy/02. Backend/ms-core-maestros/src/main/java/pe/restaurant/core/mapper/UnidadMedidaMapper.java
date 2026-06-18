package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.UnidadMedidaRequest;
import pe.restaurant.core.dto.UnidadMedidaResponse;
import pe.restaurant.core.entity.UnidadMedida;

import java.util.List;

@Mapper(componentModel = "spring")
public interface UnidadMedidaMapper {
    UnidadMedida toEntity(UnidadMedidaRequest request);
    UnidadMedidaResponse toResponse(UnidadMedida entity);
    List<UnidadMedidaResponse> toResponseList(List<UnidadMedida> entities);
    void updateEntity(UnidadMedidaRequest request, @MappingTarget UnidadMedida entity);
}
