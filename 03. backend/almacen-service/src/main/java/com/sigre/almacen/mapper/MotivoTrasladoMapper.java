package com.sigre.almacen.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import com.sigre.almacen.dto.MotivoTrasladoRequest;
import com.sigre.almacen.dto.MotivoTrasladoResponse;
import com.sigre.almacen.entity.MotivoTraslado;

import java.util.List;

@Mapper(componentModel = "spring")
public interface MotivoTrasladoMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", source = "flagEstado", defaultValue = "1")
    MotivoTraslado toEntity(MotivoTrasladoRequest request);

    MotivoTrasladoResponse toResponse(MotivoTraslado entity);

    List<MotivoTrasladoResponse> toResponseList(List<MotivoTraslado> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", source = "flagEstado", defaultValue = "1")
    void updateEntity(MotivoTrasladoRequest request, @MappingTarget MotivoTraslado entity);
}
