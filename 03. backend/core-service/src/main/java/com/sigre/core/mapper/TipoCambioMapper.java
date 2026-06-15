package com.sigre.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import com.sigre.core.dto.TipoCambioRequest;
import com.sigre.core.dto.TipoCambioResponse;
import com.sigre.core.entity.TipoCambio;

import java.util.List;

@Mapper(componentModel = "spring")
public interface TipoCambioMapper {
    TipoCambio toEntity(TipoCambioRequest request);
    TipoCambioResponse toResponse(TipoCambio entity);
    List<TipoCambioResponse> toResponseList(List<TipoCambio> entities);
    void updateEntity(TipoCambioRequest request, @MappingTarget TipoCambio entity);
}
