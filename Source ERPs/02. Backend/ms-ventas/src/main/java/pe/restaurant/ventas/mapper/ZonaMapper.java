package pe.restaurant.ventas.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.factory.Mappers;
import pe.restaurant.ventas.dto.request.ZonaRequest;
import pe.restaurant.ventas.dto.response.ZonaResponse;
import pe.restaurant.ventas.entity.Zona;

import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Mapper(componentModel = "spring")
public interface ZonaMapper {
    
    ZonaMapper INSTANCE = Mappers.getMapper(ZonaMapper.class);
    
    default Zona.Sucursal createSucursalFromRequest(Long sucursalId) {
        if (sucursalId == null) {
            return null;
        }
        Zona.Sucursal sucursal = new Zona.Sucursal();
        sucursal.setId(sucursalId);
        return sucursal;
    }
    
    // 🎯 MAPEO ESTÁNDAR CONTRACTUAL
    @Mapping(source = "sucursal.id", target = "sucursalId")
    @Mapping(source = "sucursal.nombre", target = "sucursalNombre")
    @Mapping(target = "activo", ignore = true)                    // ❌ Ignorar campo extra no contractual
    @Mapping(target = "createdAt", ignore = true)                  // ❌ Ignorar campo extra no contractual
    @Mapping(target = "updatedAt", ignore = true)                  // ❌ Ignorar campo extra no contractual
    @Mapping(target = "flagEstado", source = "flagEstado")         // ✅ Mapear directo
    @Mapping(target = "createdBy", source = "createdBy")            // ✅ Agregar mapeo
    @Mapping(target = "fecCreacion", expression = "java(formatTimestamp(entity.getFecCreacion()))")
    @Mapping(target = "updatedBy", source = "updatedBy")            // ✅ Agregar mapeo
    @Mapping(target = "fecModificacion", expression = "java(formatTimestamp(entity.getFecModificacion()))")
    ZonaResponse toResponse(Zona entity);
    
    List<ZonaResponse> toResponseList(List<Zona> entities);
    
    // 🎯 MAPEO PARA CREACIÓN (CREATE) - SOLO campos de creación
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)      // ✅ Se establece por defecto "1" en BaseEntity
    @Mapping(target = "createdBy", ignore = true)      // ✅ Se llena automáticamente por @CreatedBy
    @Mapping(target = "fecCreacion", ignore = true)   // ✅ Se llena automáticamente por @CreatedDate
    @Mapping(target = "updatedBy", ignore = true)      // ❌ NO se llena en CREATE (solo en UPDATE)
    @Mapping(target = "fecModificacion", ignore = true) // ❌ NO se llena en CREATE (solo en UPDATE)
    @Mapping(target = "sucursal", expression = "java(createSucursalFromRequest(request.getSucursalId()))")
    Zona toEntity(ZonaRequest request);
    
    // 🎯 MAPEO PARA ACTUALIZACIÓN (UPDATE) - SOLO campos de actualización
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)      // ✅ Se mantiene valor original
    @Mapping(target = "fecCreacion", ignore = true)   // ✅ Se mantiene valor original
    @Mapping(target = "updatedBy", ignore = true)      // ✅ Se llena automáticamente por @LastModifiedBy
    @Mapping(target = "fecModificacion", ignore = true) // ✅ Se llena automáticamente por @LastModifiedDate
    @Mapping(target = "sucursal", ignore = true)
    void updateEntity(ZonaRequest request, @MappingTarget Zona entity);
    
    // 🎯 UTILIDAD PARA FORMATEO DE TIMESTAMP
    default String formatTimestamp(Instant timestamp) {
        return timestamp != null ? timestamp.atZone(ZoneId.of("America/Lima")).format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")) : null;
    }
}
