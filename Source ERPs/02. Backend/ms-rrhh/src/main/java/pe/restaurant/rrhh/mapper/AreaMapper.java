package pe.restaurant.rrhh.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Named;
import pe.restaurant.rrhh.dto.request.AreaRequest;
import pe.restaurant.rrhh.dto.response.AreaResponse;
import pe.restaurant.rrhh.dto.response.AreaTreeResponse;
import pe.restaurant.rrhh.entity.Area;

import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;

/**
 * Mapper para transformaciones entre entidad Area y sus DTOs.
 * Utiliza MapStruct para generación automática de código.
 */
@Mapper(componentModel = "spring")
public interface AreaMapper {
    
    /**
     * Convierte una entidad Area a AreaResponse.
     * 
     * @param entity Entidad Area
     * @return DTO de respuesta
     */
    @Mapping(target = "fecCreacion", source = "fecCreacion", qualifiedByName = "instantToOffsetDateTime")
    @Mapping(target = "fecModificacion", source = "fecModificacion", qualifiedByName = "instantToOffsetDateTime")
    AreaResponse toResponse(Area entity);
    
    /**
     * Convierte una lista de entidades Area a lista de AreaResponse.
     * 
     * @param entities Lista de entidades
     * @return Lista de DTOs de respuesta
     */
    List<AreaResponse> toResponseList(List<Area> entities);
    
    /**
     * Convierte un AreaRequest a entidad Area.
     * 
     * @param request DTO de entrada
     * @return Entidad Area
     */
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    @Mapping(target = "padre", ignore = true)
    Area toEntity(AreaRequest request);
    
    /**
     * Actualiza una entidad Area existente con datos de AreaRequest.
     * Ignora id y campos de auditoría.
     * 
     * @param request DTO con datos actualizados
     * @param entity Entidad a actualizar
     */
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    @Mapping(target = "padre", ignore = true)
    void updateEntity(AreaRequest request, @MappingTarget Area entity);
    
    /**
     * Convierte una entidad Area a AreaTreeResponse para representación jerárquica.
     * La lista de hijos se construye manualmente en el servicio.
     * 
     * @param entity Entidad Area
     * @return DTO de árbol jerárquico
     */
    @Mapping(target = "hijos", ignore = true)
    AreaTreeResponse toTreeResponse(Area entity);
    
    /**
     * Convierte Instant a OffsetDateTime usando UTC.
     * 
     * @param instant Fecha en formato Instant
     * @return Fecha en formato OffsetDateTime
     */
    @Named("instantToOffsetDateTime")
    default OffsetDateTime instantToOffsetDateTime(Instant instant) {
        return instant != null ? instant.atOffset(ZoneOffset.UTC) : null;
    }
}
