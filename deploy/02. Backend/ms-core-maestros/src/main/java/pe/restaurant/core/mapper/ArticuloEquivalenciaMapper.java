package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.ArticuloEquivalenciaRequest;
import pe.restaurant.core.dto.ArticuloEquivalenciaResponse;
import pe.restaurant.core.entity.ArticuloEquivalencia;
import java.util.List;

@Mapper(componentModel = "spring")
public interface ArticuloEquivalenciaMapper {
    ArticuloEquivalencia toEntity(ArticuloEquivalenciaRequest request);
    ArticuloEquivalenciaResponse toResponse(ArticuloEquivalencia entity);
    List<ArticuloEquivalenciaResponse> toResponseList(List<ArticuloEquivalencia> entities);
    void updateEntity(ArticuloEquivalenciaRequest request, @MappingTarget ArticuloEquivalencia entity);
}
