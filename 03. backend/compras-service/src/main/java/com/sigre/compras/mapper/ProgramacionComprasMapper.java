package com.sigre.compras.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import com.sigre.compras.dto.ProgramacionComprasDetRequest;
import com.sigre.compras.dto.ProgramacionComprasDetResponse;
import com.sigre.compras.dto.ProgramacionComprasDetalleResponse;
import com.sigre.compras.dto.ProgramacionComprasResponse;
import com.sigre.compras.entity.ProgramacionCompras;
import com.sigre.compras.entity.ProgramacionComprasDet;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ProgramacionComprasMapper {

    @Mapping(source = "nroProgramacion", target = "numero")
    ProgramacionComprasResponse toResponse(ProgramacionCompras entity);

    List<ProgramacionComprasResponse> toResponseList(List<ProgramacionCompras> entities);

    @Mapping(source = "nroProgramacion", target = "numero")
    @Mapping(target = "lineas", source = "lineas")
    ProgramacionComprasDetalleResponse toDetalleResponse(ProgramacionCompras entity);

    ProgramacionComprasDetResponse toDetResponse(ProgramacionComprasDet entity);

    List<ProgramacionComprasDetResponse> toDetResponseList(List<ProgramacionComprasDet> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "programacionCompras", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    ProgramacionComprasDet toDetEntity(ProgramacionComprasDetRequest request);
}
