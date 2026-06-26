package pe.restaurant.rrhh.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Named;
import pe.restaurant.rrhh.dto.request.NovedadRrhhCreateRequest;
import pe.restaurant.rrhh.dto.request.NovedadRrhhUpdateRequest;
import pe.restaurant.rrhh.dto.response.NovedadRrhhResponse;
import pe.restaurant.rrhh.entity.NovedadRrhh;
import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;

@Mapper(componentModel = "spring")
public interface NovedadRrhhMapper {

    @Mapping(target = "fecCreacion", source = "fecCreacion", qualifiedByName = "instantToOffsetDateTime")
    @Mapping(target = "fecModificacion", source = "fecModificacion", qualifiedByName = "instantToOffsetDateTime")
    NovedadRrhhResponse toResponse(NovedadRrhh entity);
    List<NovedadRrhhResponse> toResponseList(List<NovedadRrhh> entities);

    @Mapping(target = "id", ignore = true) @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true) @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    NovedadRrhh toEntity(NovedadRrhhCreateRequest request);

    @Mapping(target = "id", ignore = true) @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true) @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(@MappingTarget NovedadRrhh entity, NovedadRrhhUpdateRequest request);

    @Named("instantToOffsetDateTime")
    default OffsetDateTime instantToOffsetDateTime(Instant instant) {
        return instant != null ? instant.atOffset(ZoneOffset.UTC) : null;
    }
}
