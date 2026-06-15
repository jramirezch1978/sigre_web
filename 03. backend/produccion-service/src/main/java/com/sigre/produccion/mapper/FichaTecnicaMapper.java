package com.sigre.produccion.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import com.sigre.produccion.dto.request.FichaTecnicaRequest;
import com.sigre.produccion.dto.response.FichaTecnicaResponse;
import com.sigre.produccion.entity.FichaTecnica;

@Mapper(componentModel = "spring")
public interface FichaTecnicaMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "recetaId", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    FichaTecnica toEntity(FichaTecnicaRequest request);

    @Mapping(target = "tieneFotoBlob", expression = "java(entity.getFotoBlob() != null && entity.getFotoBlob().length > 0)")
    FichaTecnicaResponse toResponse(FichaTecnica entity);
}
