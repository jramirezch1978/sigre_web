package pe.restaurant.activos.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.activos.dto.AfVentaRequest;
import pe.restaurant.activos.dto.AfVentaResponse;
import pe.restaurant.activos.entity.AfVenta;

import java.util.List;

@Mapper(componentModel = "spring")
public interface AfVentaMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "depreciacionAcumulada", ignore = true)
    @Mapping(target = "valorNetoContable", ignore = true)
    AfVenta toEntity(AfVentaRequest request);

    AfVentaResponse toResponse(AfVenta entity);

    List<AfVentaResponse> toResponseList(List<AfVenta> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "depreciacionAcumulada", ignore = true)
    @Mapping(target = "valorNetoContable", ignore = true)
    void updateEntity(AfVentaRequest request, @MappingTarget AfVenta entity);
}
