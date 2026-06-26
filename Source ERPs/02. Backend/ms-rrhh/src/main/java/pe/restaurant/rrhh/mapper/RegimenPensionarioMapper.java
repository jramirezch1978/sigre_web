package pe.restaurant.rrhh.mapper;

import org.mapstruct.*;
import pe.restaurant.rrhh.dto.request.RegimenPensionarioCreateRequest;
import pe.restaurant.rrhh.dto.request.RegimenPensionarioUpdateRequest;
import pe.restaurant.rrhh.dto.response.RegimenPensionarioResponse;
import pe.restaurant.rrhh.entity.RegimenPensionario;
import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;

@Mapper(componentModel = "spring")
public interface RegimenPensionarioMapper {
    @Mapping(target = "fecCreacion", source = "fecCreacion", qualifiedByName = "instantToOffset")
    @Mapping(target = "fecModificacion", source = "fecModificacion", qualifiedByName = "instantToOffset")
    RegimenPensionarioResponse toResponse(RegimenPensionario entity);
    List<RegimenPensionarioResponse> toResponseList(List<RegimenPensionario> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    @Mapping(target = "flagEstado", constant = "1")
    RegimenPensionario toEntity(RegimenPensionarioCreateRequest request);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "codigo", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(@MappingTarget RegimenPensionario entity, RegimenPensionarioUpdateRequest request);

    @Named("instantToOffset")
    default OffsetDateTime instantToOffset(Instant instant) {
        return instant != null ? instant.atOffset(ZoneOffset.UTC) : null;
    }
}
