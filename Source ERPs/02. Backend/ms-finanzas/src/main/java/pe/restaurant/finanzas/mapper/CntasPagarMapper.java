package pe.restaurant.finanzas.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import pe.restaurant.finanzas.dto.request.CntasPagarRequest;
import pe.restaurant.finanzas.dto.response.CntasPagarResponse;
import pe.restaurant.finanzas.entity.CntasPagar;

import java.util.List;

@Mapper(componentModel = "spring", uses = {CntasPagarDetMapper.class})
public interface CntasPagarMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "sucursalId", ignore = true)
    @Mapping(target = "saldo", ignore = true)
    @Mapping(target = "cntblAsientoId", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "detalles", ignore = true)
    CntasPagar toEntity(CntasPagarRequest request);

    @Mapping(target = "proveedorRazonSocial", ignore = true)
    @Mapping(target = "docTipoCodigo", ignore = true)
    @Mapping(target = "docTipoNombre", ignore = true)
    @Mapping(target = "monedaCodigo", ignore = true)
    @Mapping(target = "monedaSimbolo", ignore = true)
    @Mapping(target = "asiento", ignore = true)
    CntasPagarResponse toResponse(CntasPagar entity);

    default List<CntasPagarResponse> toResponseList(List<CntasPagar> entities) {
        return entities.stream()
            .map(this::toResponseSummary)
            .toList();
    }

    @Mapping(target = "proveedorRazonSocial", ignore = true)
    @Mapping(target = "docTipoCodigo", ignore = true)
    @Mapping(target = "docTipoNombre", ignore = true)
    @Mapping(target = "monedaCodigo", ignore = true)
    @Mapping(target = "monedaSimbolo", ignore = true)
    @Mapping(target = "detalles", ignore = true)
    @Mapping(target = "asiento", ignore = true)
    CntasPagarResponse toResponseSummary(CntasPagar entity);
}
