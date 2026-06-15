package com.sigre.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.BeanMapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;
import com.sigre.core.dto.EntidadTransporteRequest;
import com.sigre.core.dto.EntidadTransporteResponse;
import com.sigre.core.entity.EntidadTransporte;

import java.util.List;

@Mapper(componentModel = "spring")
public interface EntidadTransporteMapper {
    EntidadTransporte toEntity(EntidadTransporteRequest request);
    EntidadTransporteResponse toResponse(EntidadTransporte entity);
    List<EntidadTransporteResponse> toResponseList(List<EntidadTransporte> entities);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    void updateEntity(EntidadTransporteRequest request, @MappingTarget EntidadTransporte entity);
}
