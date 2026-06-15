package com.sigre.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import com.sigre.core.dto.CatalogoSunatRequest;
import com.sigre.core.dto.CatalogoSunatResponse;
import com.sigre.core.entity.CatalogoSunat;

import java.util.List;

@Mapper(componentModel = "spring")
public interface CatalogoSunatMapper {

    CatalogoSunat toEntity(CatalogoSunatRequest request);

    CatalogoSunatResponse toResponse(CatalogoSunat entity);

    List<CatalogoSunatResponse> toResponseList(List<CatalogoSunat> entities);

    void updateEntity(CatalogoSunatRequest request, @MappingTarget CatalogoSunat entity);
}
