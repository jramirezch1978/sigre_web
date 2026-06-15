package com.sigre.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import com.sigre.core.dto.MonedaRequest;
import com.sigre.core.dto.MonedaResponse;
import com.sigre.core.entity.Moneda;

import java.util.List;

@Mapper(componentModel = "spring")
public interface MonedaMapper {
    Moneda toEntity(MonedaRequest request);
    MonedaResponse toResponse(Moneda entity);
    List<MonedaResponse> toResponseList(List<Moneda> entities);
    void updateEntity(MonedaRequest request, @MappingTarget Moneda entity);
}
