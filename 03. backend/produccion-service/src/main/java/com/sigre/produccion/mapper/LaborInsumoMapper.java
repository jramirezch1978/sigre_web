package com.sigre.produccion.mapper;

import org.mapstruct.Mapper;
import com.sigre.produccion.dto.response.LaborInsumoResponse;
import com.sigre.produccion.entity.LaborInsumo;

import java.util.List;

@Mapper(componentModel = "spring")
public interface LaborInsumoMapper {

    LaborInsumoResponse toResponse(LaborInsumo entity);

    List<LaborInsumoResponse> toResponseList(List<LaborInsumo> entities);
}
