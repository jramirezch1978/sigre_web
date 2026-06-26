package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.TipoCambioRequest;
import pe.restaurant.core.dto.TipoCambioResponse;
import pe.restaurant.core.entity.TipoCambio;

import java.util.List;

@Mapper(componentModel = "spring")
public interface TipoCambioMapper {
    TipoCambio toEntity(TipoCambioRequest request);
    TipoCambioResponse toResponse(TipoCambio entity);
    List<TipoCambioResponse> toResponseList(List<TipoCambio> entities);
    void updateEntity(TipoCambioRequest request, @MappingTarget TipoCambio entity);
}
