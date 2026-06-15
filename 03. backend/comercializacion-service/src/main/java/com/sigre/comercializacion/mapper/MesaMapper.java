package com.sigre.comercializacion.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import com.sigre.comercializacion.dto.request.MesaRequest;
import com.sigre.comercializacion.dto.response.MesaResponse;
import com.sigre.comercializacion.entity.Mesa;

import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Mapper(componentModel = "spring")
public interface MesaMapper {

    // 🎯 MAPEO PARA CREACIÓN (CREATE) - SOLO campos de creación
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)      // ✅ Se llena automáticamente por @CreatedBy
    @Mapping(target = "fecCreacion", ignore = true)   // ✅ Se llena automáticamente por @CreatedDate
    @Mapping(target = "updatedBy", ignore = true)      // ❌ NO se llena en CREATE (solo en UPDATE)
    @Mapping(target = "fecModificacion", ignore = true) // ❌ NO se llena en CREATE (solo en UPDATE)
    @Mapping(target = "zona", expression = "java(createZonaFromId(request.getZonaId()))")
    @Mapping(target = "flagEstado", ignore = true)      // ✅ Se establece por defecto "1" en BaseEntity
    Mesa toEntity(MesaRequest request);

    // 🎯 MAPEO ESTÁNDAR CONTRACTUAL
    @Mapping(target = "zonaId", expression = "java(entity.getZona() != null ? entity.getZona().getId() : null)")
    @Mapping(target = "zonaNombre", expression = "java(loadZonaNombre(entity.getZona()))")
    @Mapping(target = "sucursalId", expression = "java(loadSucursalId(entity.getZona()))")
    @Mapping(target = "sucursalNombre", expression = "java(loadSucursalNombre(entity.getZona()))")
    @Mapping(target = "activo", ignore = true)                    // ❌ Ignorar campo extra no contractual
    @Mapping(target = "createdAt", ignore = true)                  // ❌ Ignorar campo extra no contractual
    @Mapping(target = "updatedAt", ignore = true)                  // ❌ Ignorar campo extra no contractual
    @Mapping(target = "flagEstado", source = "flagEstado")         // ✅ Mapear directo
    @Mapping(target = "createdBy", source = "createdBy")            // ✅ Agregar mapeo
    @Mapping(target = "fecCreacion", expression = "java(formatTimestamp(entity.getFecCreacion()))")
    @Mapping(target = "updatedBy", source = "updatedBy")            // ✅ Agregar mapeo
    @Mapping(target = "fecModificacion", expression = "java(formatTimestamp(entity.getFecModificacion()))")
    MesaResponse toResponse(Mesa entity);

    List<MesaResponse> toResponseList(List<Mesa> entities);

    // 🎯 MAPEO PARA ACTUALIZACIÓN (UPDATE) - SOLO campos de actualización
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)      // ✅ Se mantiene valor original
    @Mapping(target = "fecCreacion", ignore = true)   // ✅ Se mantiene valor original
    @Mapping(target = "updatedBy", ignore = true)      // ✅ Se llena automáticamente por @LastModifiedBy
    @Mapping(target = "fecModificacion", ignore = true) // ✅ Se llena automáticamente por @LastModifiedDate
    @Mapping(target = "zona", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    void updateEntity(MesaRequest request, @MappingTarget Mesa entity);
    
    // 🎯 UTILIDAD PARA FORMATEO DE TIMESTAMP
    default String formatTimestamp(Instant timestamp) {
        return timestamp != null ? timestamp.atZone(ZoneId.of("America/Lima")).format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")) : null;
    }
    
    // 🎯 UTILIDAD PARA CREAR ENTIDAD ZONA A PARTIR DE ID
    default com.sigre.comercializacion.entity.Mesa.Zona createZonaFromId(Long zonaId) {
        if (zonaId == null) {
            return null;
        }
        com.sigre.comercializacion.entity.Mesa.Zona zona = new com.sigre.comercializacion.entity.Mesa.Zona();
        zona.setId(zonaId);
        return zona;
    }
    
    // 🎯 UTILIDADES PARA CARGAR DATOS RELACIONADOS
    default String loadZonaNombre(com.sigre.comercializacion.entity.Mesa.Zona zona) {
        if (zona == null || zona.getNombre() == null) {
            return null;
        }
        return zona.getNombre();
    }
    
    default Long loadSucursalId(com.sigre.comercializacion.entity.Mesa.Zona zona) {
        if (zona == null || zona.getSucursal() == null) {
            return null;
        }
        return zona.getSucursal().getId();
    }
    
    default String loadSucursalNombre(com.sigre.comercializacion.entity.Mesa.Zona zona) {
        if (zona == null || zona.getSucursal() == null || zona.getSucursal().getNombre() == null) {
            return null;
        }
        return zona.getSucursal().getNombre();
    }
}
