package com.sigre.almacen.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import com.sigre.almacen.dto.FormaEmbarqueRequest;
import com.sigre.almacen.dto.FormaEmbarqueResponse;
import com.sigre.almacen.entity.FormaEmbarque;

import java.util.List;

@Mapper(componentModel = "spring")
public interface FormaEmbarqueMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", source = "flagEstado", defaultValue = "1")
    FormaEmbarque toEntity(FormaEmbarqueRequest request);

    FormaEmbarqueResponse toResponse(FormaEmbarque entity);

    List<FormaEmbarqueResponse> toResponseList(List<FormaEmbarque> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", source = "flagEstado", defaultValue = "1")
    void updateEntity(FormaEmbarqueRequest request, @MappingTarget FormaEmbarque entity);
}
