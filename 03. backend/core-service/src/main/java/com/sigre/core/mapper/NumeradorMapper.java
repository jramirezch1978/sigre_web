package com.sigre.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import com.sigre.core.dto.NumeradorRequest;
import com.sigre.core.dto.NumeradorResponse;
import com.sigre.core.entity.Numerador;

import java.util.List;

@Mapper(componentModel = "spring")
public interface NumeradorMapper {
    Numerador toEntity(NumeradorRequest request);
    NumeradorResponse toResponse(Numerador entity);
    List<NumeradorResponse> toResponseList(List<Numerador> entities);
    void updateEntity(NumeradorRequest request, @MappingTarget Numerador entity);
}
