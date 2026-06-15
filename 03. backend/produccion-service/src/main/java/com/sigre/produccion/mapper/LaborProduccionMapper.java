package com.sigre.produccion.mapper;

import org.mapstruct.Mapper;
import com.sigre.produccion.dto.response.LaborProduccionResponse;
import com.sigre.produccion.entity.LaborProduccion;

import java.util.List;

@Mapper(componentModel = "spring")
public interface LaborProduccionMapper {

    LaborProduccionResponse toResponse(LaborProduccion entity);

    List<LaborProduccionResponse> toResponseList(List<LaborProduccion> entities);
}
