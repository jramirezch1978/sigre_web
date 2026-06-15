package com.sigre.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import com.sigre.core.dto.UnidadMedidaRequest;
import com.sigre.core.dto.UnidadMedidaResponse;
import com.sigre.core.entity.UnidadMedida;

import java.util.List;

@Mapper(componentModel = "spring")
public interface UnidadMedidaMapper {
    UnidadMedida toEntity(UnidadMedidaRequest request);
    UnidadMedidaResponse toResponse(UnidadMedida entity);
    List<UnidadMedidaResponse> toResponseList(List<UnidadMedida> entities);
    void updateEntity(UnidadMedidaRequest request, @MappingTarget UnidadMedida entity);
}
