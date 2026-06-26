package pe.restaurant.rrhh.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Named;
import pe.restaurant.rrhh.dto.request.TipoContratoCreateRequest;
import pe.restaurant.rrhh.dto.request.TipoContratoUpdateRequest;
import pe.restaurant.rrhh.dto.response.TipoContratoResponse;
import pe.restaurant.rrhh.entity.TipoContrato;
import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;

@Mapper(componentModel = "spring")
public interface TipoContratoMapper {

    @Mapping(target = "fecCreacion", source = "fecCreacion", qualifiedByName = "instantToOffsetDateTime")
    @Mapping(target = "fecModificacion", source = "fecModificacion", qualifiedByName = "instantToOffsetDateTime")
    TipoContratoResponse toResponse(TipoContrato entity);

    List<TipoContratoResponse> toResponseList(List<TipoContrato> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    TipoContrato toEntity(TipoContratoCreateRequest request);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "codigo", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(@MappingTarget TipoContrato entity, TipoContratoUpdateRequest request);

    @Named("instantToOffsetDateTime")
    default OffsetDateTime instantToOffsetDateTime(Instant instant) {
        return instant != null ? instant.atOffset(ZoneOffset.UTC) : null;
    }
}
