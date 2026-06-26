package pe.restaurant.produccion.mapper;

import org.mapstruct.Mapper;
import pe.restaurant.produccion.dto.response.LaborInsumoResponse;
import pe.restaurant.produccion.entity.LaborInsumo;

import java.util.List;

@Mapper(componentModel = "spring")
public interface LaborInsumoMapper {

    LaborInsumoResponse toResponse(LaborInsumo entity);

    List<LaborInsumoResponse> toResponseList(List<LaborInsumo> entities);
}
