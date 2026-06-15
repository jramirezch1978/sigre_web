package com.sigre.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import com.sigre.core.dto.DetraccionRequest;
import com.sigre.core.dto.DetraccionResponse;
import com.sigre.core.entity.Detraccion;

import java.util.List;

@Mapper(componentModel = "spring")
public interface DetraccionMapper {
    Detraccion toEntity(DetraccionRequest request);
    DetraccionResponse toResponse(Detraccion entity);
    List<DetraccionResponse> toResponseList(List<Detraccion> entities);
    void updateEntity(DetraccionRequest request, @MappingTarget Detraccion entity);
}
