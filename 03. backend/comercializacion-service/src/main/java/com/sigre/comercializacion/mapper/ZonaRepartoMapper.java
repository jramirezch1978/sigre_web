package com.sigre.comercializacion.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import com.sigre.comercializacion.dto.request.ZonaRepartoRequest;
import com.sigre.comercializacion.dto.response.ZonaRepartoResponse;
import com.sigre.comercializacion.entity.ZonaReparto;

import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Mapper(componentModel = "spring")
public interface ZonaRepartoMapper {

    // 🎯 MAPEO PARA CREACIÓN (CREATE) - SOLO campos de creación
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)      // ✅ Se llena automáticamente por @CreatedBy
    @Mapping(target = "fecCreacion", ignore = true)   // ✅ Se llena automáticamente por @CreatedDate
    @Mapping(target = "updatedBy", ignore = true)      // ❌ NO se llena en CREATE (solo en UPDATE)
    @Mapping(target = "fecModificacion", ignore = true) // ❌ NO se llena en CREATE (solo en UPDATE)
    @Mapping(target = "flagEstado", ignore = true)      // ✅ Se establece por defecto "1" en BaseEntity
    ZonaReparto toEntity(ZonaRepartoRequest request);

    // 🎯 MAPEO ESTÁNDAR CONTRACTUAL
    @Mapping(target = "activo", ignore = true)                    // ❌ Ignorar campo extra no contractual
    @Mapping(target = "createdAt", ignore = true)                  // ❌ Ignorar campo extra no contractual
    @Mapping(target = "updatedAt", ignore = true)                  // ❌ Ignorar campo extra no contractual
    @Mapping(target = "flagEstado", source = "flagEstado")         // ✅ Mapear directo
    @Mapping(target = "createdBy", source = "createdBy")            // ✅ Agregar mapeo
    @Mapping(target = "fecCreacion", expression = "java(formatTimestamp(entity.getFecCreacion()))")
    @Mapping(target = "updatedBy", source = "updatedBy")            // ✅ Agregar mapeo
    @Mapping(target = "fecModificacion", expression = "java(formatTimestamp(entity.getFecModificacion()))")
    ZonaRepartoResponse toResponse(ZonaReparto entity);

    List<ZonaRepartoResponse> toResponseList(List<ZonaReparto> entities);

    // 🎯 MAPEO PARA ACTUALIZACIÓN (UPDATE) - SOLO campos de actualización
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)      // ✅ Se mantiene valor original
    @Mapping(target = "fecCreacion", ignore = true)   // ✅ Se mantiene valor original
    @Mapping(target = "updatedBy", ignore = true)      // ✅ Se llena automáticamente por @LastModifiedBy
    @Mapping(target = "fecModificacion", ignore = true) // ✅ Se llena automáticamente por @LastModifiedDate
    @Mapping(target = "flagEstado", ignore = true)
    void updateEntity(ZonaRepartoRequest request, @MappingTarget ZonaReparto entity);
    
    // 🎯 UTILIDAD PARA FORMATEO DE TIMESTAMP
    default String formatTimestamp(Instant timestamp) {
        return timestamp != null ? timestamp.atZone(ZoneId.of("America/Lima")).format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")) : null;
    }
}
