package com.sigre.compras.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import com.sigre.compras.dto.ConformidadServicioDetRequest;
import com.sigre.compras.dto.ConformidadServicioDetResponse;
import com.sigre.compras.dto.ConformidadServicioDetalleResponse;
import com.sigre.compras.dto.ConformidadServicioResponse;
import com.sigre.compras.entity.ConformidadServicio;
import com.sigre.compras.entity.ConformidadServicioDet;

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
