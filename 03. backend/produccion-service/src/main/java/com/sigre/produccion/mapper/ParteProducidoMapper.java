package com.sigre.produccion.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import com.sigre.produccion.dto.request.ParteProducidoRequest;
import com.sigre.produccion.dto.response.ParteProducidoResponse;
import com.sigre.produccion.entity.ParteProduccionProducido;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ParteProducidoMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "parteProduccionId", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    ParteProduccionProducido toEntity(ParteProducidoRequest request);

    ParteProducidoResponse toResponse(ParteProduccionProducido entity);

    List<ParteProducidoResponse> toResponseList(List<ParteProduccionProducido> entities);
}
