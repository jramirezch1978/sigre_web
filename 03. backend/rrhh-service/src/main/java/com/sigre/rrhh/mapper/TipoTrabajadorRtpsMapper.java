package com.sigre.rrhh.mapper;

import org.mapstruct.*;
import com.sigre.rrhh.dto.request.TipoTrabajadorRtpsCreateRequest;
import com.sigre.rrhh.dto.request.TipoTrabajadorRtpsUpdateRequest;
import com.sigre.rrhh.dto.response.TipoTrabajadorRtpsResponse;
import com.sigre.rrhh.entity.TipoTrabajadorRtps;
import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;

@Mapper(componentModel = "spring")
public interface TipoTrabajadorRtpsMapper {
    @Mapping(target = "fecCreacion", source = "fecCreacion", qualifiedByName = "instantToOffset")
    @Mapping(target = "fecModificacion", source = "fecModificacion", qualifiedByName = "instantToOffset")
    TipoTrabajadorRtpsResponse toResponse(TipoTrabajadorRtps entity);
    List<TipoTrabajadorRtpsResponse> toResponseList(List<TipoTrabajadorRtps> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    @Mapping(target = "flagEstado", constant = "1")
    TipoTrabajadorRtps toEntity(TipoTrabajadorRtpsCreateRequest request);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "codigo", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(@MappingTarget TipoTrabajadorRtps entity, TipoTrabajadorRtpsUpdateRequest request);

    @Named("instantToOffset")
    default OffsetDateTime instantToOffset(Instant instant) {
        return instant != null ? instant.atOffset(ZoneOffset.UTC) : null;
    }
}
