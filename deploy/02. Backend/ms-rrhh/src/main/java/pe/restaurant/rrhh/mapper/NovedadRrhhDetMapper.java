package pe.restaurant.rrhh.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import pe.restaurant.rrhh.dto.request.NovedadRrhhDetRequest;
import pe.restaurant.rrhh.dto.response.NovedadRrhhDetResponse;
import pe.restaurant.rrhh.entity.NovedadRrhhDet;
import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;

@Mapper(componentModel = "spring")
public interface NovedadRrhhDetMapper {

    @Mapping(target = "fecCreacion", source = "fecCreacion", qualifiedByName = "instantToOffsetDateTime")
    @Mapping(target = "fecModificacion", source = "fecModificacion", qualifiedByName = "instantToOffsetDateTime")
    NovedadRrhhDetResponse toResponse(NovedadRrhhDet entity);
    List<NovedadRrhhDetResponse> toResponseList(List<NovedadRrhhDet> entities);

    @Mapping(target = "id", ignore = true) @Mapping(target = "novedadRrhhId", ignore = true)
    @Mapping(target = "createdBy", ignore = true) @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true) @Mapping(target = "fecModificacion", ignore = true)
    NovedadRrhhDet toEntity(NovedadRrhhDetRequest request);

    @Named("instantToOffsetDateTime")
    default OffsetDateTime instantToOffsetDateTime(Instant instant) {
        return instant != null ? instant.atOffset(ZoneOffset.UTC) : null;
    }
}
