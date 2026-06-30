package com.sigre.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import com.sigre.core.dto.MarcaRequest;
import com.sigre.core.dto.MarcaResponse;
import com.sigre.core.entity.Marca;

import java.util.List;

@Mapper(componentModel = "spring")
public interface MarcaMapper {
    Marca toEntity(MarcaRequest request);
    MarcaResponse toResponse(Marca entity);
    List<MarcaResponse> toResponseList(List<Marca> entities);
    void updateEntity(MarcaRequest request, @MappingTarget Marca entity);
}
