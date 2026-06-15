package com.sigre.contabilidad.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import com.sigre.contabilidad.dto.request.AsientoRequest;
import com.sigre.contabilidad.dto.response.AsientoResponse;
import com.sigre.contabilidad.entity.CntblAsiento;

import java.util.List;

@Mapper(componentModel = "spring", uses = {AsientoDetalleMapper.class})
public interface AsientoMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "voucher", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "detalles", source = "detalles")
    CntblAsiento toEntity(AsientoRequest request);

    AsientoResponse toResponse(CntblAsiento entity);

    List<AsientoResponse> toResponseList(List<CntblAsiento> entities);

    default List<AsientoResponse> toResponseListFromPage(List<CntblAsiento> entities) {
        return toResponseList(entities);
    }
}
