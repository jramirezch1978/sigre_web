package com.sigre.rrhh.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import com.sigre.rrhh.dto.request.ConceptoPlanillaCreateRequest;
import com.sigre.rrhh.dto.request.ConceptoPlanillaUpdateRequest;
import com.sigre.rrhh.dto.response.ConceptoPlanillaResponse;
import com.sigre.rrhh.entity.ConceptoPlanilla;

import java.time.Instant;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.List;

/**
 * Mapper para convertir entre entidades ConceptoPlanilla y DTOs.
 * Utiliza MapStruct para generación automática de código de mapeo.
 * 
 * @author Equipo de Desarrollo RRHH
 */
@Mapper(componentModel = "spring")
public interface ConceptoPlanillaMapper {

    /**
     * Convierte una entidad ConceptoPlanilla a DTO de respuesta.
     * 
     * @param entity Entidad a convertir
     * @return DTO de respuesta con los datos de la entidad
     */
    @Mapping(target = "grupoCalculo", source = "grupoConceptosPlanilla.codigo")
    ConceptoPlanillaResponse toResponse(ConceptoPlanilla entity);

    List<ConceptoPlanillaResponse> toResponseList(List<ConceptoPlanilla> entities);

    /**
     * Convierte un DTO de creación a entidad ConceptoPlanilla.
     * 
     * @param request DTO con los datos para crear el concepto
     * @return Entidad ConceptoPlanilla con los datos del request
     */
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "grupoConceptosPlanilla", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    ConceptoPlanilla toEntity(ConceptoPlanillaCreateRequest request);

    /**
     * Actualiza una entidad existente con los datos del DTO de actualización.
     * El campo 'id' y 'codigo' se ignoran ya que son inmutables.
     * 
     * @param entity Entidad a actualizar
     * @param request DTO con los nuevos datos
     */
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "codigo", ignore = true)
    @Mapping(target = "grupoConceptosPlanilla", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(@MappingTarget ConceptoPlanilla entity, ConceptoPlanillaUpdateRequest request);

    /**
     * Convierte Instant a OffsetDateTime para el mapeo de fechas.
     * 
     * @param instant Instant a convertir
     * @return OffsetDateTime en UTC
     */
    default OffsetDateTime map(Instant instant) {
        return instant != null ? instant.atOffset(ZoneOffset.UTC) : null;
    }
}
