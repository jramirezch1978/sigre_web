package pe.restaurant.rrhh.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Named;
import pe.restaurant.rrhh.dto.request.ControlSubsidioCreateRequest;
import pe.restaurant.rrhh.dto.request.ControlSubsidioUpdateRequest;
import pe.restaurant.rrhh.dto.response.ControlSubsidioResponse;
import pe.restaurant.rrhh.entity.ControlSubsidio;
import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;

@Mapper(componentModel = "spring")
public interface ControlSubsidioMapper {

    @Mapping(target = "fecCreacion", source = "fecCreacion", qualifiedByName = "instantToOffsetDateTime")
    @Mapping(target = "fecModificacion", source = "fecModificacion", qualifiedByName = "instantToOffsetDateTime")
    ControlSubsidioResponse toResponse(ControlSubsidio entity);

    List<ControlSubsidioResponse> toResponseList(List<ControlSubsidio> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    ControlSubsidio toEntity(ControlSubsidioCreateRequest request);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "trabajadorId", ignore = true)
    @Mapping(target = "tipoSubsidioId", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(@MappingTarget ControlSubsidio entity, ControlSubsidioUpdateRequest request);

    @Named("instantToOffsetDateTime")
    default OffsetDateTime instantToOffsetDateTime(Instant instant) {
        return instant != null ? instant.atOffset(ZoneOffset.UTC) : null;
    }
}
