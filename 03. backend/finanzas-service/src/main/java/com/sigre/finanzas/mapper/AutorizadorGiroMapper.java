package com.sigre.finanzas.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.factory.Mappers;
import com.sigre.finanzas.dto.request.AutorizadorGiroRequest;
import com.sigre.finanzas.dto.response.AutorizadorGiroResponse;
import com.sigre.finanzas.entity.AutorizadorGiro;

import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Mapper(componentModel = "spring")
public interface AutorizadorGiroMapper {
    
    AutorizadorGiroMapper INSTANCE = Mappers.getMapper(AutorizadorGiroMapper.class);

    // 🎯 MAPEO PARA CREACIÓN (CREATE) - SOLO campos de creación
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)      // ✅ Se establece por defecto "1" en BaseEntity
    @Mapping(target = "createdBy", ignore = true)      // ✅ Se llena automáticamente por @CreatedBy
    @Mapping(target = "fecCreacion", ignore = true)   // ✅ Se llena automáticamente por @CreatedDate
    @Mapping(target = "updatedBy", ignore = true)      // ❌ NO se llena en CREATE (solo en UPDATE)
    @Mapping(target = "fecModificacion", ignore = true) // ❌ NO se llena en CREATE (solo en UPDATE)
    @Mapping(target = "activo", expression = "java(request.getActivo() != null ? request.getActivo() : true)")
    AutorizadorGiro toEntity(AutorizadorGiroRequest request);

    // 🎯 MAPEO ESTÁNDAR CONTRACTUAL - Similar a ZonaMapper
    @Mapping(target = "activo", expression = "java(mapActivo(entity.getFlagEstado()))")
    @Mapping(target = "flagEstado", source = "flagEstado")         // ✅ Mapear directo
    @Mapping(target = "createdBy", source = "createdBy")            // ✅ Agregar mapeo
    @Mapping(target = "fecCreacion", expression = "java(formatTimestamp(entity.getFecCreacion()))")
    @Mapping(target = "updatedBy", source = "updatedBy")            // ✅ Agregar mapeo
    @Mapping(target = "fecModificacion", expression = "java(formatTimestamp(entity.getFecModificacion()))")
    @Mapping(target = "createdAt", ignore = true)                  // ❌ Ignorar campo extra no contractual
    @Mapping(target = "updatedAt", ignore = true)                  // ❌ Ignorar campo extra no contractual
    AutorizadorGiroResponse toResponse(AutorizadorGiro entity);

    List<AutorizadorGiroResponse> toResponseList(List<AutorizadorGiro> entities);

    // 🎯 MAPEO PARA ACTUALIZACIÓN (UPDATE) - SOLO campos de actualización
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)      // ✅ Se mantiene valor original
    @Mapping(target = "fecCreacion", ignore = true)   // ✅ Se mantiene valor original
    @Mapping(target = "updatedBy", ignore = true)      // ✅ Se llena automáticamente por @LastModifiedBy
    @Mapping(target = "fecModificacion", ignore = true) // ✅ Se llena automáticamente por @LastModifiedDate
    @Mapping(target = "activo", expression = "java(request.getActivo() != null ? request.getActivo() : entity.getActivo())")
    void updateEntity(AutorizadorGiroRequest request, @MappingTarget AutorizadorGiro entity);
    
    // 🎯 UTILIDAD PARA FORMATEO DE TIMESTAMP - Soporta múltiples tipos
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
    
    // 🎯 UTILIDAD PARA MAPEO DE ACTIVO
    default Boolean mapActivo(String flagEstado) {
        return "1".equals(flagEstado);
    }
}
