package pe.restaurant.produccion.mapper;

import org.mapstruct.Mapper;
import pe.restaurant.produccion.dto.response.LaborProduccionResponse;
import pe.restaurant.produccion.entity.LaborProduccion;

import java.util.List;

@Mapper(componentModel = "spring")
public interface LaborProduccionMapper {

    LaborProduccionResponse toResponse(LaborProduccion entity);

    List<LaborProduccionResponse> toResponseList(List<LaborProduccion> entities);
}
