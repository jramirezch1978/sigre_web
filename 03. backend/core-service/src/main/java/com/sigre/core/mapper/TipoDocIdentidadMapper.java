package com.sigre.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import com.sigre.core.dto.TipoDocIdentidadRequest;
import com.sigre.core.dto.TipoDocIdentidadResponse;
import com.sigre.core.entity.TipoDocIdentidad;

import java.util.List;

@Mapper(componentModel = "spring")
public interface TipoDocIdentidadMapper {
    TipoDocIdentidadResponse toResponse(TipoDocIdentidad entity);
    List<TipoDocIdentidadResponse> toResponseList(List<TipoDocIdentidad> entities);
    TipoDocIdentidad toEntity(TipoDocIdentidadRequest request);
    void updateEntity(TipoDocIdentidadRequest request, @MappingTarget TipoDocIdentidad entity);
}
