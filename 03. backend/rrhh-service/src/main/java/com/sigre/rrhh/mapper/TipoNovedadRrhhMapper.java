package com.sigre.rrhh.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import com.sigre.rrhh.dto.request.TipoNovedadRrhhCreateRequest;
import com.sigre.rrhh.dto.request.TipoNovedadRrhhUpdateRequest;
import com.sigre.rrhh.dto.response.TipoNovedadRrhhResponse;
import com.sigre.rrhh.entity.TipoNovedadRrhh;

import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;

@Mapper(componentModel = "spring")
public interface TipoNovedadRrhhMapper {

    TipoNovedadRrhhResponse toResponse(TipoNovedadRrhh entity);

    List<TipoNovedadRrhhResponse> toResponseList(List<TipoNovedadRrhh> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    TipoNovedadRrhh toEntity(TipoNovedadRrhhCreateRequest request);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "codigo", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(@MappingTarget TipoNovedadRrhh entity, TipoNovedadRrhhUpdateRequest request);

    default OffsetDateTime map(Instant instant) {
        return instant != null ? instant.atOffset(ZoneOffset.UTC) : null;
    }
}
