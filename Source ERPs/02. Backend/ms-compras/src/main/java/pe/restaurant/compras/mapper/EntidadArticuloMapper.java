package pe.restaurant.compras.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.compras.dto.EntidadArticuloRequest;
import pe.restaurant.compras.dto.EntidadArticuloResponse;
import pe.restaurant.compras.entity.EntidadArticulo;

import java.util.List;

@Mapper(componentModel = "spring")
public interface EntidadArticuloMapper {
    EntidadArticulo toEntity(EntidadArticuloRequest request);
    EntidadArticuloResponse toResponse(EntidadArticulo entity);
    List<EntidadArticuloResponse> toResponseList(List<EntidadArticulo> entities);
    void updateEntity(EntidadArticuloRequest request, @MappingTarget EntidadArticulo entity);
}
