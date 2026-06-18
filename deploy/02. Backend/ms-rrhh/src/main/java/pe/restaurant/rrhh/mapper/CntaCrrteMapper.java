package pe.restaurant.rrhh.mapper;

import org.mapstruct.*;
import pe.restaurant.rrhh.dto.request.CntaCrrteCreateRequest;
import pe.restaurant.rrhh.dto.request.CntaCrrteMovimientoRequest;
import pe.restaurant.rrhh.dto.request.CntaCrrteMovimientoUpdateRequest;
import pe.restaurant.rrhh.dto.request.CntaCrrteUpdateRequest;
import pe.restaurant.rrhh.dto.response.CntaCrrteDetResponse;
import pe.restaurant.rrhh.dto.response.CntaCrrteResponse;
import pe.restaurant.rrhh.entity.CntaCrrte;
import pe.restaurant.rrhh.entity.CntaCrrteDet;
import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;

@Mapper(componentModel = "spring")
public interface CntaCrrteMapper {

    @Mapping(target = "fecCreacion", source = "fecCreacion", qualifiedByName = "instantToOffsetDateTime")
    @Mapping(target = "fecModificacion", source = "fecModificacion", qualifiedByName = "instantToOffsetDateTime")
    @Mapping(target = "trabajadorNombres", ignore = true)
    CntaCrrteResponse toResponse(CntaCrrte entity);
    List<CntaCrrteResponse> toResponseList(List<CntaCrrte> entities);

    @Mapping(target = "id", ignore = true) @Mapping(target = "saldoActual", ignore = true)
    @Mapping(target = "createdBy", ignore = true) @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true) @Mapping(target = "fecModificacion", ignore = true)
    CntaCrrte toEntity(CntaCrrteCreateRequest request);

    @Mapping(target = "id", ignore = true) @Mapping(target = "trabajadorId", ignore = true)
    @Mapping(target = "saldoActual", ignore = true) @Mapping(target = "saldoInicial", ignore = true)
    @Mapping(target = "createdBy", ignore = true) @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true) @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(@MappingTarget CntaCrrte entity, CntaCrrteUpdateRequest request);

    @Mapping(target = "fecCreacion", source = "fecCreacion", qualifiedByName = "instantToOffsetDateTime")
    CntaCrrteDetResponse toDetResponse(CntaCrrteDet entity);
    List<CntaCrrteDetResponse> toDetResponseList(List<CntaCrrteDet> entities);

    @Mapping(target = "id", ignore = true) @Mapping(target = "cntaCrrteId", ignore = true)
    @Mapping(target = "createdBy", ignore = true) @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true) @Mapping(target = "fecModificacion", ignore = true)
    CntaCrrteDet toDetEntity(CntaCrrteMovimientoRequest request);

    @Mapping(target = "id", ignore = true) @Mapping(target = "cntaCrrteId", ignore = true)
    @Mapping(target = "createdBy", ignore = true) @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true) @Mapping(target = "fecModificacion", ignore = true)
    void updateDetEntity(@MappingTarget CntaCrrteDet entity, CntaCrrteMovimientoUpdateRequest request);

    @Named("instantToOffsetDateTime")
    default OffsetDateTime instantToOffsetDateTime(Instant instant) { return instant != null ? instant.atOffset(ZoneOffset.UTC) : null; }
}
