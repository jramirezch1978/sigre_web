package pe.restaurant.ventas.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.ventas.dto.request.CartaRequest;
import pe.restaurant.ventas.dto.response.CartaResponse;
import pe.restaurant.ventas.entity.Carta;
import pe.restaurant.ventas.entity.CartaDet;

import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Mapper(componentModel = "spring")
public interface CartaMapper {
    
    // 🎯 UTILIDAD PARA FORMATEO DE TIMESTAMP
    default String formatTimestamp(Instant timestamp) {
        return timestamp != null ? timestamp.atZone(ZoneId.of("America/Lima")).format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")) : null;
    }

    // 🎯 MAPEO PARA CREACIÓN (CREATE) - SOLO campos de creación
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)      // ✅ Se llena automáticamente por @CreatedBy
    @Mapping(target = "fecCreacion", ignore = true)   // ✅ Se llena automáticamente por @CreatedDate
    @Mapping(target = "updatedBy", ignore = true)      // ❌ NO se llena en CREATE (solo en UPDATE)
    @Mapping(target = "fecModificacion", ignore = true) // ❌ NO se llena en CREATE (solo en UPDATE)
    @Mapping(target = "flagEstado", ignore = true)      // ✅ Se establece por defecto "1" en BaseEntity
    @Mapping(target = "detalles", expression = "java(request.getDetalles() != null ? request.getDetalles().stream().map(this::toDetEntity).collect(java.util.stream.Collectors.toList()) : null)")
    Carta toEntity(CartaRequest request);

    // 🎯 MAPEO ESTÁNDAR CONTRACTUAL
    @Mapping(target = "sucursalNombre", expression = "java(loadSucursalNombre(entity.getSucursalId()))")
    @Mapping(target = "activo", ignore = true)                    // ❌ Ignorar campo extra no contractual
    @Mapping(target = "flagEstado", source = "flagEstado")         // ✅ Mapear directo
    @Mapping(target = "createdBy", source = "createdBy")            // ✅ Agregar mapeo
    @Mapping(target = "fecCreacion", expression = "java(formatTimestamp(entity.getFecCreacion()))")
    @Mapping(target = "updatedBy", source = "updatedBy")            // ✅ Agregar mapeo
    @Mapping(target = "fecModificacion", expression = "java(formatTimestamp(entity.getFecModificacion()))")
    @Mapping(target = "detalles", ignore = true)                    // ❌ NO incluir detalles en listado (performance)
    CartaResponse toResponse(Carta entity);

    List<CartaResponse> toResponseList(List<Carta> entities);

    // 🎯 MAPEO PARA ACTUALIZACIÓN (UPDATE) - SOLO campos de actualización
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)      // ✅ Se mantiene valor original
    @Mapping(target = "fecCreacion", ignore = true)   // ✅ Se mantiene valor original
    @Mapping(target = "updatedBy", ignore = true)      // ✅ Se llena automáticamente por @LastModifiedBy
    @Mapping(target = "fecModificacion", ignore = true) // ✅ Se llena automáticamente por @LastModifiedDate
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "detalles", ignore = true)
    void updateEntity(CartaRequest request, @MappingTarget Carta entity);

    // Mappers para CartaDet
    // 🎯 MAPEO PARA CREACIÓN (CREATE) - SOLO campos de creación
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)      // ✅ Se llena automáticamente por @CreatedBy
    @Mapping(target = "fecCreacion", ignore = true)   // ✅ Se llena automáticamente por @CreatedDate
    @Mapping(target = "updatedBy", ignore = true)      // ❌ NO se llena en CREATE (solo en UPDATE)
    @Mapping(target = "fecModificacion", ignore = true) // ❌ NO se llena en CREATE (solo en UPDATE)
    @Mapping(target = "flagEstado", ignore = true)      // ✅ Se establece por defecto "1" en BaseEntity
    @Mapping(target = "carta", ignore = true)
    @Mapping(target = "articulo", expression = "java(createArticuloWithId(request.getArticuloId()))")
    CartaDet toDetEntity(CartaRequest.CartaDetRequest request);
    
    // Método helper para crear Articulo con solo ID
    default CartaDet.Articulo createArticuloWithId(Long articuloId) {
        if (articuloId == null) return null;
        CartaDet.Articulo articulo = new CartaDet.Articulo();
        articulo.setId(articuloId);
        return articulo;
    }

    // 🎯 MAPEO ESTÁNDAR CONTRACTUAL
    @Mapping(source = "carta.id", target = "cartaId")
    @Mapping(source = "articulo.id", target = "articuloId")
    @Mapping(source = "articulo.codigo", target = "articuloCodigo")
    @Mapping(source = "articulo.nombre", target = "articuloNombre")
    @Mapping(target = "activo", ignore = true)                    // ❌ Ignorar campo extra no contractual
    @Mapping(target = "flagEstado", source = "flagEstado")         // ✅ Mapear directo
    @Mapping(target = "createdBy", source = "createdBy")            // ✅ Agregar mapeo
    @Mapping(target = "fecCreacion", expression = "java(formatTimestamp(entity.getFecCreacion()))")
    @Mapping(target = "updatedBy", source = "updatedBy")            // ✅ Agregar mapeo
    @Mapping(target = "fecModificacion", expression = "java(formatTimestamp(entity.getFecModificacion()))")
    CartaResponse.CartaDetResponse toDetResponse(CartaDet entity);

    List<CartaResponse.CartaDetResponse> toDetResponseList(List<CartaDet> entities);

    // 🎯 MÉTODO AUXILIAR PARA CARGAR NOMBRE DE SUCURSAL (CONTRATO)
    default String loadSucursalNombre(Long sucursalId) {
        if (sucursalId == null) {
            return null;
        }
        // TODO: Implementar carga de nombre de sucursal desde base de datos
        // Por ahora, retornar un valor descriptivo temporal
        return "Sucursal " + sucursalId;
    }
}
