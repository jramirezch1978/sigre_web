package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.TiposImpuestoRequest;
import pe.restaurant.core.dto.TiposImpuestoResponse;
import pe.restaurant.core.entity.TiposImpuesto;

import java.util.List;

@Mapper(componentModel = "spring")
public interface TiposImpuestoMapper {

    TiposImpuesto toEntity(TiposImpuestoRequest request);

    TiposImpuestoResponse toResponse(TiposImpuesto entity);

    List<TiposImpuestoResponse> toResponseList(List<TiposImpuesto> entities);

    void updateEntity(TiposImpuestoRequest request, @MappingTarget TiposImpuesto entity);
}
