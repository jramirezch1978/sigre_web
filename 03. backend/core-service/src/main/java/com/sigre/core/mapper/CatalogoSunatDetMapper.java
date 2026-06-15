package com.sigre.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import com.sigre.core.dto.CatalogoSunatDetRequest;
import com.sigre.core.dto.CatalogoSunatDetResponse;
import com.sigre.core.entity.CatalogoSunatDet;

import java.util.List;

@Mapper(componentModel = "spring")
public interface CatalogoSunatDetMapper {

    CatalogoSunatDet toEntity(CatalogoSunatDetRequest request);

    CatalogoSunatDetResponse toResponse(CatalogoSunatDet entity);

    List<CatalogoSunatDetResponse> toResponseList(List<CatalogoSunatDet> entities);

    void updateEntity(CatalogoSunatDetRequest request, @MappingTarget CatalogoSunatDet entity);
}
