package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.CondicionPagoRequest;
import pe.restaurant.core.dto.CondicionPagoResponse;
import pe.restaurant.core.entity.CondicionPago;

import java.util.List;

@Mapper(componentModel = "spring")
public interface CondicionPagoMapper {
    CondicionPago toEntity(CondicionPagoRequest request);
    CondicionPagoResponse toResponse(CondicionPago entity);
    List<CondicionPagoResponse> toResponseList(List<CondicionPago> entities);
    void updateEntity(CondicionPagoRequest request, @MappingTarget CondicionPago entity);
}
