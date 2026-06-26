package pe.restaurant.rrhh.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import pe.restaurant.rrhh.dto.request.CapacitacionTrabajadorRequest;
import pe.restaurant.rrhh.dto.response.CapacitacionTrabajadorResponse;
import pe.restaurant.rrhh.entity.CapacitacionTrabajador;
import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;

@Mapper(componentModel = "spring")
public interface CapacitacionTrabajadorMapper {

    @Mapping(target = "fecCreacion", source = "fecCreacion", qualifiedByName = "instantToOffsetDateTime")
    CapacitacionTrabajadorResponse toResponse(CapacitacionTrabajador entity);

    List<CapacitacionTrabajadorResponse> toResponseList(List<CapacitacionTrabajador> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    CapacitacionTrabajador toEntity(CapacitacionTrabajadorRequest request);

    @Named("instantToOffsetDateTime")
    default OffsetDateTime instantToOffsetDateTime(Instant instant) {
        return instant != null ? instant.atOffset(ZoneOffset.UTC) : null;
    }
}
