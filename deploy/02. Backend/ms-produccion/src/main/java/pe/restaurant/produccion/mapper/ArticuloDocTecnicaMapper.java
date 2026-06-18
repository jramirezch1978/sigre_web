package pe.restaurant.produccion.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.produccion.dto.request.DocTecnicaRequest;
import pe.restaurant.produccion.dto.response.DocTecnicaResponse;
import pe.restaurant.produccion.entity.ArticuloDocTecnica;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ArticuloDocTecnicaMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    @Mapping(target = "documentoBlob", ignore = true)
    ArticuloDocTecnica toEntity(DocTecnicaRequest request);

    @Mapping(target = "docTipoCodigo", ignore = true)
    @Mapping(target = "docTipoNombre", ignore = true)
    @Mapping(target = "articuloCodigo", ignore = true)
    @Mapping(target = "articuloDescripcion", ignore = true)
    @Mapping(target = "caracteristicas", ignore = true)
    @Mapping(target = "tieneDocumentoBlob", expression = "java(entity.getDocumentoBlob() != null && entity.getDocumentoBlob().length > 0)")
    DocTecnicaResponse toResponse(ArticuloDocTecnica entity);

    List<DocTecnicaResponse> toResponseList(List<ArticuloDocTecnica> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    @Mapping(target = "documentoBlob", ignore = true)
    void updateEntity(DocTecnicaRequest request, @MappingTarget ArticuloDocTecnica entity);
}
