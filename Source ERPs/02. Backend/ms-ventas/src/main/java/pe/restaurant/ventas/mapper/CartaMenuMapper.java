package pe.restaurant.ventas.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.springframework.data.domain.Page;
import pe.restaurant.ventas.dto.request.CartaRequest;
import pe.restaurant.ventas.dto.response.CartaMenuListItemResponse;
import pe.restaurant.ventas.dto.response.CartaMenuResponse;
import pe.restaurant.ventas.entity.Carta;
import pe.restaurant.ventas.entity.CartaDet;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Mapper(componentModel = "spring")
public interface CartaMenuMapper {

    // 🎯 MAPEO PARA LISTADO (SIN DETALLES)
    @Mapping(target = "sucursalNombre", ignore = true) // JOIN no disponible directamente, se manejará en service
    @Mapping(target = "flagEstado", source = "flagEstado") // ✅ Mapear directo
    @Mapping(target = "createdBy", source = "createdBy")
    @Mapping(target = "fecCreacion", expression = "java(formatTimestamp(entity.getFecCreacion()))")
    @Mapping(target = "updatedBy", source = "updatedBy")
    @Mapping(target = "fecModificacion", expression = "java(formatTimestamp(entity.getFecModificacion()))")
    CartaMenuListItemResponse toListItemResponse(Carta entity);

    List<CartaMenuListItemResponse> toListItemResponseList(List<Carta> entities);
    
    default Page<CartaMenuListItemResponse> toListItemResponsePage(Page<Carta> entities) {
        return entities.map(this::toListItemResponse);
    }

    // 🎯 MAPEO PARA DETALLE (CON DETALLES)
    @Mapping(target = "sucursalNombre", ignore = true) // JOIN no disponible directamente, se manejará en service
    @Mapping(target = "flagEstado", source = "flagEstado") // ✅ Mapear directo
    @Mapping(target = "createdBy", source = "createdBy")
    @Mapping(target = "fecCreacion", expression = "java(formatTimestamp(entity.getFecCreacion()))")
    @Mapping(target = "updatedBy", source = "updatedBy")
    @Mapping(target = "fecModificacion", expression = "java(formatTimestamp(entity.getFecModificacion()))")
    @Mapping(target = "items", expression = "java(entity.getDetalles() != null ? toItemResponseList(entity.getDetalles()) : null)")
    CartaMenuResponse toResponse(Carta entity);

    List<CartaMenuResponse> toResponseList(List<Carta> entities);

    // 🎯 MAPEO PARA ITEMS (DETALLES)
    @Mapping(source = "carta.id", target = "cartaId")
    @Mapping(source = "articulo.id", target = "articuloId")
    @Mapping(source = "articulo.codigo", target = "articuloCodigo")
    @Mapping(source = "articulo.nombre", target = "articuloNombre")
    @Mapping(target = "flagEstado", source = "flagEstado") // ✅ Mapear directo
    @Mapping(target = "createdBy", source = "createdBy")
    @Mapping(target = "fecCreacion", expression = "java(formatTimestamp(entity.getFecCreacion()))")
    @Mapping(target = "updatedBy", source = "updatedBy")
    @Mapping(target = "fecModificacion", expression = "java(formatTimestamp(entity.getFecModificacion()))")
    CartaMenuResponse.CartaItemResponse toItemResponse(CartaDet entity);

    List<CartaMenuResponse.CartaItemResponse> toItemResponseList(List<CartaDet> entities);

    // 🎯 MAPEO PARA CREACIÓN/ACTUALIZACIÓN - INCONSISTENCIA IDENTIFICADA
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)      // ✅ Se llena automáticamente por @CreatedBy
    @Mapping(target = "fecCreacion", ignore = true)   // ✅ Se llena automáticamente por @CreatedDate
    @Mapping(target = "updatedBy", ignore = true)      // ❌ NO se llena en CREATE (solo en UPDATE)
    @Mapping(target = "fecModificacion", ignore = true) // ❌ NO se llena en CREATE (solo en UPDATE)
    @Mapping(target = "flagEstado", ignore = true)      // ✅ Se establece por defecto "1" en BaseEntity
    @Mapping(target = "detalles", expression = "java(request.getDetalles() != null ? request.getDetalles().stream().map(this::toDetEntity).collect(java.util.stream.Collectors.toList()) : null)")
    Carta toEntity(CartaRequest request);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)      // ✅ Se mantiene valor original
    @Mapping(target = "fecCreacion", ignore = true)   // ✅ Se mantiene valor original
    @Mapping(target = "updatedBy", ignore = true)      // ✅ Se llena automáticamente por @LastModifiedBy
    @Mapping(target = "fecModificacion", ignore = true) // ✅ Se llena automáticamente por @LastModifiedDate
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "detalles", ignore = true)
    void updateEntity(CartaRequest request, @MappingTarget Carta entity);

    // 🎯 MAPEO PARA DETALLES (ENTIDADES)
    // 🎯 MAPEO PARA CREACIÓN (CREATE) - INCONSISTENCIA IDENTIFICADA
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

    // 🎯 UTILIDAD PARA FORMATEO DE TIMESTAMP
    default String formatTimestamp(Instant timestamp) {
        return timestamp != null ? timestamp.atZone(ZoneId.of("America/Lima")).format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss")) : null;
    }
}
