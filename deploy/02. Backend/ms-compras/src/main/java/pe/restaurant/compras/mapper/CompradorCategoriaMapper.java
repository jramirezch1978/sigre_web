package pe.restaurant.compras.mapper;

import org.mapstruct.Mapper;
import pe.restaurant.compras.dto.CompradorCategoriaResponse;
import pe.restaurant.compras.entity.CompradorCategoria;

import java.util.List;

@Mapper(componentModel = "spring")
public interface CompradorCategoriaMapper {

    CompradorCategoriaResponse toResponse(CompradorCategoria entity);

    List<CompradorCategoriaResponse> toResponseList(List<CompradorCategoria> entities);
}
