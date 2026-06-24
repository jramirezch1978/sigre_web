package com.sigre.rrhh.mapper;

import org.mapstruct.*;
import com.sigre.rrhh.dto.request.PensionRtpsCreateRequest;
import com.sigre.rrhh.dto.request.PensionRtpsUpdateRequest;
import com.sigre.rrhh.dto.response.PensionRtpsResponse;
import com.sigre.rrhh.entity.PensionRtps;
import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;

@Mapper(componentModel = "spring")
public interface PensionRtpsMapper {
    @Mapping(target = "fecCreacion", source = "fecCreacion", qualifiedByName = "instantToOffset")
    @Mapping(target = "fecModificacion", source = "fecModificacion", qualifiedByName = "instantToOffset")
    PensionRtpsResponse toResponse(PensionRtps entity);
    List<PensionRtpsResponse> toResponseList(List<PensionRtps> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    @Mapping(target = "flagEstado", constant = "1")
    PensionRtps toEntity(PensionRtpsCreateRequest request);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "codigo", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(@MappingTarget PensionRtps entity, PensionRtpsUpdateRequest request);

    @Named("instantToOffset")
    default OffsetDateTime instantToOffset(Instant instant) {
        return instant != null ? instant.atOffset(ZoneOffset.UTC) : null;
    }
}
