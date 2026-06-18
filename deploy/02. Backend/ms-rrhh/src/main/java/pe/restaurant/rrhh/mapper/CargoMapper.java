package pe.restaurant.rrhh.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Named;
import pe.restaurant.rrhh.dto.request.CargoRequest;
import pe.restaurant.rrhh.dto.response.CargoResponse;
import pe.restaurant.rrhh.entity.Cargo;

import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;

/**
 * Mapper para transformaciones entre entidad Cargo y sus DTOs.
 * Utiliza MapStruct para generación automática de código.
 */
@Mapper(componentModel = "spring")
public interface CargoMapper {
    
    /**
     * Convierte una entidad Cargo a CargoResponse.
     * 
     * @param entity Entidad Cargo
     * @return DTO de respuesta
     */
    @Mapping(target = "fecCreacion", source = "fecCreacion", qualifiedByName = "instantToOffsetDateTime")
    @Mapping(target = "fecModificacion", source = "fecModificacion", qualifiedByName = "instantToOffsetDateTime")
    CargoResponse toResponse(Cargo entity);
    
    /**
     * Convierte una lista de entidades Cargo a lista de CargoResponse.
     * 
     * @param entities Lista de entidades
     * @return Lista de DTOs de respuesta
     */
    List<CargoResponse> toResponseList(List<Cargo> entities);
    
    /**
     * Convierte un CargoRequest a entidad Cargo.
     * 
     * @param request DTO de entrada
     * @return Entidad Cargo
     */
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    Cargo toEntity(CargoRequest request);
    
    /**
     * Actualiza una entidad Cargo existente con datos de CargoRequest.
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
    void updateEntity(CargoRequest request, @MappingTarget Cargo entity);
    
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
