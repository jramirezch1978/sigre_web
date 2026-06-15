package com.sigre.comercializacion.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import com.sigre.comercializacion.dto.request.VendedorRequest;
import com.sigre.comercializacion.dto.response.VendedorResponse;
import com.sigre.comercializacion.entity.Vendedor;

import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Mapper(componentModel = "spring")
public interface VendedorMapper {

    // 🎯 MAPEO PARA CREACIÓN (CREATE) - SOLO campos de creación
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)      // ✅ Se llena automáticamente por @CreatedBy
    @Mapping(target = "fecCreacion", ignore = true)   // ✅ Se llena automáticamente por @CreatedDate
    @Mapping(target = "updatedBy", ignore = true)      // ❌ NO se llena en CREATE (solo en UPDATE)
    @Mapping(target = "fecModificacion", ignore = true) // ❌ NO se llena en CREATE (solo en UPDATE)
    @Mapping(target = "usuario", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)      // ✅ Se establece por defecto "1" en BaseEntity
    @Mapping(source = "comisionPorcentaje", target = "comisionPorcentaje")
    Vendedor toEntity(VendedorRequest request);

    // 🎯 MAPEO ESTÁNDAR CONTRACTUAL
    @Mapping(source = "usuarioId", target = "usuarioId")  // ✅ Mapear directo del campo
    @Mapping(expression = "java(entity.getUsuario() != null ? entity.getUsuario().getUsername() : null)", target = "usuarioUsername")
    @Mapping(expression = "java(entity.getUsuario() != null ? entity.getUsuario().getNombres() : null)", target = "usuarioNombres")
    @Mapping(expression = "java(entity.getUsuario() != null ? entity.getUsuario().getApellidos() : null)", target = "usuarioApellidos")
    @Mapping(source = "nombre", target = "nombre")
    @Mapping(source = "comisionPorcentaje", target = "comisionPorcentaje")
    @Mapping(target = "activo", ignore = true)                    // ❌ Ignorar campo extra no contractual
    @Mapping(target = "createdAt", ignore = true)                  // ❌ Ignorar campo extra no contractual
    @Mapping(target = "updatedAt", ignore = true)                  // ❌ Ignorar campo extra no contractual
    @Mapping(target = "flagEstado", source = "flagEstado")         // ✅ Mapear directo
    @Mapping(target = "createdBy", source = "createdBy")            // ✅ Agregar mapeo
    @Mapping(target = "fecCreacion", expression = "java(formatTimestamp(entity.getFecCreacion()))")
    @Mapping(target = "updatedBy", source = "updatedBy")            // ✅ Agregar mapeo
    @Mapping(target = "fecModificacion", expression = "java(formatTimestamp(entity.getFecModificacion()))")
    VendedorResponse toResponse(Vendedor entity);

    List<VendedorResponse> toResponseList(List<Vendedor> entities);

    // 🎯 MAPEO PARA ACTUALIZACIÓN (UPDATE) - SOLO campos de actualización
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)      // ✅ Se mantiene valor original
    @Mapping(target = "fecCreacion", ignore = true)   // ✅ Se mantiene valor original
    @Mapping(target = "updatedBy", ignore = true)      // ✅ Se llena automáticamente por @LastModifiedBy
    @Mapping(target = "fecModificacion", ignore = true) // ✅ Se llena automáticamente por @LastModifiedDate
    @Mapping(target = "usuario", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    void updateEntity(VendedorRequest request, @MappingTarget Vendedor entity);
    
    // 🎯 UTILIDAD PARA FORMATEO DE TIMESTAMP
    default String formatTimestamp(Instant timestamp) {
        return timestamp != null ? timestamp.atZone(ZoneId.of("America/Lima")).format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")) : null;
    }
}
