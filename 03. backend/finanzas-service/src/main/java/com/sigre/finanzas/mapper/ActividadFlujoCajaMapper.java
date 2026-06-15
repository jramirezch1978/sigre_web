package com.sigre.finanzas.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.factory.Mappers;
import com.sigre.finanzas.dto.request.ActividadFlujoCajaRequest;
import com.sigre.finanzas.dto.response.ActividadFlujoCajaResponse;
import com.sigre.finanzas.entity.ActividadFlujoCaja;

import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Mapper(componentModel = "spring")
public interface ActividadFlujoCajaMapper {

    ActividadFlujoCajaMapper INSTANCE = Mappers.getMapper(ActividadFlujoCajaMapper.class);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    ActividadFlujoCaja toEntity(ActividadFlujoCajaRequest request);

    @Mapping(target = "activo", expression = "java(mapActivo(entity.getFlagEstado()))")
    @Mapping(target = "flagEstado", source = "flagEstado")
    @Mapping(target = "createdBy", source = "createdBy")
    @Mapping(target = "fecCreacion", expression = "java(formatTimestamp(entity.getFecCreacion()))")
    @Mapping(target = "updatedBy", source = "updatedBy")
    @Mapping(target = "fecModificacion", expression = "java(formatTimestamp(entity.getFecModificacion()))")
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    ActividadFlujoCajaResponse toResponse(ActividadFlujoCaja entity);

    List<ActividadFlujoCajaResponse> toResponseList(List<ActividadFlujoCaja> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(ActividadFlujoCajaRequest request, @MappingTarget ActividadFlujoCaja entity);

    default String formatTimestamp(Object timestamp) {
        if (timestamp == null) {
            return null;
        }
        if (timestamp instanceof Instant) {
            return ((Instant) timestamp).atZone(ZoneId.of("America/Lima")).format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"));
        } else if (timestamp instanceof java.time.LocalDateTime) {
            return ((java.time.LocalDateTime) timestamp).atZone(ZoneId.of("America/Lima")).format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss"));
        } else if (timestamp instanceof java.util.Date) {
            return new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(timestamp);
        } else {
            return timestamp.toString();
        }
    }

    default Boolean mapActivo(String flagEstado) {
        return "1".equals(flagEstado);
    }
}
