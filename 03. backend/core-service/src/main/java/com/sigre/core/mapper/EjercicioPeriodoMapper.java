package com.sigre.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import com.sigre.core.dto.EjercicioPeriodoRequest;
import com.sigre.core.dto.EjercicioPeriodoResponse;
import com.sigre.core.entity.EjercicioPeriodo;

import java.util.List;

@Mapper(componentModel = "spring")
public interface EjercicioPeriodoMapper {
    EjercicioPeriodo toEntity(EjercicioPeriodoRequest request);
    EjercicioPeriodoResponse toResponse(EjercicioPeriodo entity);
    List<EjercicioPeriodoResponse> toResponseList(List<EjercicioPeriodo> entities);
    void updateEntity(EjercicioPeriodoRequest request, @MappingTarget EjercicioPeriodo entity);
}
