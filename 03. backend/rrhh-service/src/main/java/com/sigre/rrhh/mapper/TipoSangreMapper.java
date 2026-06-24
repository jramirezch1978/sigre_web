package com.sigre.rrhh.mapper;

import org.mapstruct.*;
import com.sigre.rrhh.dto.request.TipoSangreCreateRequest;
import com.sigre.rrhh.dto.request.TipoSangreUpdateRequest;
import com.sigre.rrhh.dto.response.TipoSangreResponse;
import com.sigre.rrhh.entity.TipoSangre;
import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;

@Mapper(componentModel = "spring")
public interface TipoSangreMapper {
    @Mapping(target = "fecCreacion", source = "fecCreacion", qualifiedByName = "instantToOffset")
    @Mapping(target = "fecModificacion", source = "fecModificacion", qualifiedByName = "instantToOffset")
    TipoSangreResponse toResponse(TipoSangre entity);
    List<TipoSangreResponse> toResponseList(List<TipoSangre> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    @Mapping(target = "flagEstado", constant = "1")
    TipoSangre toEntity(TipoSangreCreateRequest request);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "codigo", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(@MappingTarget TipoSangre entity, TipoSangreUpdateRequest request);

    @Named("instantToOffset")
    default OffsetDateTime instantToOffset(Instant instant) {
        return instant != null ? instant.atOffset(ZoneOffset.UTC) : null;
    }
}
