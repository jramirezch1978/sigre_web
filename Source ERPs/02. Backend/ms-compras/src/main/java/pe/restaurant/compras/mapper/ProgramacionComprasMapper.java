package pe.restaurant.compras.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import pe.restaurant.compras.dto.ProgramacionComprasDetRequest;
import pe.restaurant.compras.dto.ProgramacionComprasDetResponse;
import pe.restaurant.compras.dto.ProgramacionComprasDetalleResponse;
import pe.restaurant.compras.dto.ProgramacionComprasResponse;
import pe.restaurant.compras.entity.ProgramacionCompras;
import pe.restaurant.compras.entity.ProgramacionComprasDet;

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
