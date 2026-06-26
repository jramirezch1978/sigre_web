package pe.restaurant.rrhh.mapper;

import org.mapstruct.*;
import pe.restaurant.rrhh.dto.request.MotivoCeseCreateRequest;
import pe.restaurant.rrhh.dto.request.MotivoCeseUpdateRequest;
import pe.restaurant.rrhh.dto.response.MotivoCeseResponse;
import pe.restaurant.rrhh.entity.MotivoCese;
import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;

@Mapper(componentModel = "spring")
public interface MotivoCeseMapper {
    @Mapping(target = "fecCreacion", source = "fecCreacion", qualifiedByName = "instantToOffset")
    @Mapping(target = "fecModificacion", source = "fecModificacion", qualifiedByName = "instantToOffset")
    MotivoCeseResponse toResponse(MotivoCese entity);
    List<MotivoCeseResponse> toResponseList(List<MotivoCese> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    @Mapping(target = "flagEstado", constant = "1")
    MotivoCese toEntity(MotivoCeseCreateRequest request);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "codigo", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(@MappingTarget MotivoCese entity, MotivoCeseUpdateRequest request);

    @Named("instantToOffset")
    default OffsetDateTime instantToOffset(Instant instant) {
        return instant != null ? instant.atOffset(ZoneOffset.UTC) : null;
    }
}
