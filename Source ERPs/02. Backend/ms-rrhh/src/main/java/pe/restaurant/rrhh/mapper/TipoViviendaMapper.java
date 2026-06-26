package pe.restaurant.rrhh.mapper;

import org.mapstruct.*;
import pe.restaurant.rrhh.dto.request.TipoViviendaCreateRequest;
import pe.restaurant.rrhh.dto.request.TipoViviendaUpdateRequest;
import pe.restaurant.rrhh.dto.response.TipoViviendaResponse;
import pe.restaurant.rrhh.entity.TipoVivienda;
import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;

@Mapper(componentModel = "spring")
public interface TipoViviendaMapper {
    @Mapping(target = "fecCreacion", source = "fecCreacion", qualifiedByName = "instantToOffset")
    @Mapping(target = "fecModificacion", source = "fecModificacion", qualifiedByName = "instantToOffset")
    TipoViviendaResponse toResponse(TipoVivienda entity);
    List<TipoViviendaResponse> toResponseList(List<TipoVivienda> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    @Mapping(target = "flagEstado", constant = "1")
    TipoVivienda toEntity(TipoViviendaCreateRequest request);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "codigo", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(@MappingTarget TipoVivienda entity, TipoViviendaUpdateRequest request);

    @Named("instantToOffset")
    default OffsetDateTime instantToOffset(Instant instant) {
        return instant != null ? instant.atOffset(ZoneOffset.UTC) : null;
    }
}
