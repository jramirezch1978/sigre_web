package com.sigre.contabilidad.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import com.sigre.contabilidad.dto.request.AsientoDetalleRequest;
import com.sigre.contabilidad.dto.response.AsientoDetalleResponse;
import com.sigre.contabilidad.entity.CntblAsientoDet;

import java.util.List;

@Mapper(componentModel = "spring")
public interface AsientoDetalleMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "cntblAsiento", ignore = true)
    @Mapping(target = "bancoCtaId", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    CntblAsientoDet toEntity(AsientoDetalleRequest request);

    @Mapping(target = "id", source = "id")
    AsientoDetalleResponse toResponse(CntblAsientoDet entity);

    List<AsientoDetalleResponse> toResponseList(List<CntblAsientoDet> entities);
}
