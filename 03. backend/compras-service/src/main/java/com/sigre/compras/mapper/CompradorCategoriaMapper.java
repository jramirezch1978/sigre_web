package com.sigre.compras.mapper;

import org.mapstruct.Mapper;
import com.sigre.compras.dto.CompradorCategoriaResponse;
import com.sigre.compras.entity.CompradorCategoria;

import java.util.List;

@Mapper(componentModel = "spring")
public interface CompradorCategoriaMapper {

    CompradorCategoriaResponse toResponse(CompradorCategoria entity);

    List<CompradorCategoriaResponse> toResponseList(List<CompradorCategoria> entities);
}
