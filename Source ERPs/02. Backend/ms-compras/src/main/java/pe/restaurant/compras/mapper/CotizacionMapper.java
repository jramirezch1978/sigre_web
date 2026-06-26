package pe.restaurant.compras.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.compras.dto.CotizacionDetRequest;
import pe.restaurant.compras.dto.CotizacionRequest;
import pe.restaurant.compras.entity.Cotizacion;
import pe.restaurant.compras.entity.CotizacionDet;

@Mapper(componentModel = "spring")
public interface CotizacionMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "sucursalId", ignore = true)
    @Mapping(target = "total", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    @Mapping(target = "lineas", ignore = true)
    Cotizacion toEntity(CotizacionRequest request);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "cotizacion", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    CotizacionDet toDetEntity(CotizacionDetRequest request);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "sucursalId", ignore = true)
    @Mapping(target = "total", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    @Mapping(target = "lineas", ignore = true)
    void updateEntity(CotizacionRequest request, @MappingTarget Cotizacion entity);
}
