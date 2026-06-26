package pe.restaurant.rrhh.mapper;

import org.mapstruct.*;
import pe.restaurant.rrhh.dto.request.ImpuestoRentaTramoCreateRequest;
import pe.restaurant.rrhh.dto.request.ImpuestoRentaTramoUpdateRequest;
import pe.restaurant.rrhh.dto.response.ImpuestoRentaTramoResponse;
import pe.restaurant.rrhh.entity.ImpuestoRentaTramo;

import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;

@Mapper(componentModel = "spring")
public interface ImpuestoRentaTramoMapper {

    @Mapping(target = "fecCreacion", source = "fecCreacion", qualifiedByName = "instantToOffset")
    @Mapping(target = "fecModificacion", source = "fecModificacion", qualifiedByName = "instantToOffset")
    ImpuestoRentaTramoResponse toResponse(ImpuestoRentaTramo entity);

    List<ImpuestoRentaTramoResponse> toResponseList(List<ImpuestoRentaTramo> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    @Mapping(target = "flagEstado", constant = "1")
    ImpuestoRentaTramo toEntity(ImpuestoRentaTramoCreateRequest request);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    void updateEntity(@MappingTarget ImpuestoRentaTramo entity, ImpuestoRentaTramoUpdateRequest request);

    @Named("instantToOffset")
    default OffsetDateTime instantToOffset(Instant instant) {
        return instant != null ? instant.atOffset(ZoneOffset.UTC) : null;
    }
}
