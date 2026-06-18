package pe.restaurant.rrhh.mapper;

import org.mapstruct.*;
import pe.restaurant.rrhh.dto.request.PrestamoCreateRequest;
import pe.restaurant.rrhh.dto.request.PrestamoUpdateRequest;
import pe.restaurant.rrhh.dto.response.PrestamoResponse;
import pe.restaurant.rrhh.entity.Prestamo;
import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;

@Mapper(componentModel = "spring")
public interface PrestamoMapper {

    @Mapping(target = "fecCreacion", source = "fecCreacion", qualifiedByName = "instantToOffsetDateTime")
    @Mapping(target = "fecModificacion", source = "fecModificacion", qualifiedByName = "instantToOffsetDateTime")
    PrestamoResponse toResponse(Prestamo entity);
    List<PrestamoResponse> toResponseList(List<Prestamo> entities);

    @Mapping(target = "id", ignore = true) @Mapping(target = "cuotaMensual", ignore = true)
    @Mapping(target = "saldo", ignore = true) @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true) @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    Prestamo toEntity(PrestamoCreateRequest request);

    @Mapping(target = "id", ignore = true) @Mapping(target = "trabajadorId", ignore = true)
    @Mapping(target = "createdBy", ignore = true) @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true) @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(@MappingTarget Prestamo entity, PrestamoUpdateRequest request);

    @Named("instantToOffsetDateTime")
    default OffsetDateTime instantToOffsetDateTime(Instant instant) { return instant != null ? instant.atOffset(ZoneOffset.UTC) : null; }
}
