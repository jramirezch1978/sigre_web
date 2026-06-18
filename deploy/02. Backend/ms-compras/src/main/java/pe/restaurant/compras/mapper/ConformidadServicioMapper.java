package pe.restaurant.compras.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import pe.restaurant.compras.dto.ConformidadServicioDetRequest;
import pe.restaurant.compras.dto.ConformidadServicioDetResponse;
import pe.restaurant.compras.dto.ConformidadServicioDetalleResponse;
import pe.restaurant.compras.dto.ConformidadServicioResponse;
import pe.restaurant.compras.entity.ConformidadServicio;
import pe.restaurant.compras.entity.ConformidadServicioDet;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ConformidadServicioMapper {

    ConformidadServicioResponse toResponse(ConformidadServicio entity);

    List<ConformidadServicioResponse> toResponseList(List<ConformidadServicio> entities);

    @Mapping(target = "lineas", source = "lineas")
    ConformidadServicioDetalleResponse toDetalleResponse(ConformidadServicio entity);

    ConformidadServicioDetResponse toDetResponse(ConformidadServicioDet entity);

    List<ConformidadServicioDetResponse> toDetResponseList(List<ConformidadServicioDet> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "conformidadServicio", ignore = true)
    @Mapping(target = "subtotal", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    ConformidadServicioDet toDetEntity(ConformidadServicioDetRequest request);
}
