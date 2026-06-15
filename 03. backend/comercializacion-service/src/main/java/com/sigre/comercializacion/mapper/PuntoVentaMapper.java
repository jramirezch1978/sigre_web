package com.sigre.comercializacion.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import com.sigre.comercializacion.dto.request.PuntoVentaRequest;
import com.sigre.comercializacion.dto.response.PuntoVentaResponse;
import com.sigre.comercializacion.entity.PuntoVenta;

import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Mapper(componentModel = "spring")
public interface PuntoVentaMapper {

    // 🎯 MAPEO PARA CREACIÓN (CREATE) - SOLO campos de creación
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)      // ✅ Se llena automáticamente por @CreatedBy
    @Mapping(target = "fecCreacion", ignore = true)   // ✅ Se llena automáticamente por @CreatedDate
    @Mapping(target = "updatedBy", ignore = true)      // ❌ NO se llena en CREATE (solo en UPDATE)
    @Mapping(target = "fecModificacion", ignore = true) // ❌ NO se llena en CREATE (solo en UPDATE)
    @Mapping(target = "sucursal", ignore = true)
    @Mapping(target = "almacen", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)      // ✅ Se establece por defecto "1" en BaseEntity
    PuntoVenta toEntity(PuntoVentaRequest request);

    // 🎯 MAPEO ESTÁNDAR CONTRACTUAL
    @Mapping(target = "sucursalNombre", expression = "java(getSucursalNombre(entity))")
    @Mapping(target = "almacenNombre", expression = "java(getAlmacenNombre(entity))")
    @Mapping(target = "activo", ignore = true)                    // ❌ Ignorar campo extra no contractual
    @Mapping(target = "createdAt", ignore = true)                  // ❌ Ignorar campo extra no contractual
    @Mapping(target = "updatedAt", ignore = true)                  // ❌ Ignorar campo extra no contractual
    @Mapping(target = "flagEstado", source = "flagEstado")         // ✅ Mapear directo
    @Mapping(target = "createdBy", source = "createdBy")            // ✅ Agregar mapeo
    @Mapping(target = "fecCreacion", expression = "java(formatTimestamp(entity.getFecCreacion()))")
    @Mapping(target = "updatedBy", source = "updatedBy")            // ✅ Agregar mapeo
    @Mapping(target = "fecModificacion", expression = "java(formatTimestamp(entity.getFecModificacion()))")
    PuntoVentaResponse toResponse(PuntoVenta entity);

    List<PuntoVentaResponse> toResponseList(List<PuntoVenta> entities);

    // 🎯 MAPEO PARA ACTUALIZACIÓN (UPDATE) - SOLO campos de actualización
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)      // ✅ Se mantiene valor original
    @Mapping(target = "fecCreacion", ignore = true)   // ✅ Se mantiene valor original
    @Mapping(target = "updatedBy", ignore = true)      // ✅ Se llena automáticamente por @LastModifiedBy
    @Mapping(target = "fecModificacion", ignore = true) // ✅ Se llena automáticamente por @LastModifiedDate
    @Mapping(target = "sucursal", ignore = true)
    @Mapping(target = "almacen", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    void updateEntity(PuntoVentaRequest request, @MappingTarget PuntoVenta entity);
    
    // 🎯 UTILIDAD PARA FORMATEO DE TIMESTAMP
    default String formatTimestamp(Instant timestamp) {
        return timestamp != null ? timestamp.atZone(ZoneId.of("America/Lima")).format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")) : null;
    }

    // 🎯 UTILIDADES PARA MAPEAR NOMBRES DE RELACIONES (con null-check)
    default String getSucursalNombre(PuntoVenta entity) {
        return entity != null && entity.getSucursal() != null ? entity.getSucursal().getNombre() : null;
    }

    default String getAlmacenNombre(PuntoVenta entity) {
        return entity != null && entity.getAlmacen() != null ? entity.getAlmacen().getNombre() : null;
    }
}
