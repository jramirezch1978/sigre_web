package com.sigre.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import com.sigre.core.dto.CondicionPagoRequest;
import com.sigre.core.dto.CondicionPagoResponse;
import com.sigre.core.entity.CondicionPago;

import java.util.List;

@Mapper(componentModel = "spring")
public interface CondicionPagoMapper {
    CondicionPago toEntity(CondicionPagoRequest request);
    CondicionPagoResponse toResponse(CondicionPago entity);
    List<CondicionPagoResponse> toResponseList(List<CondicionPago> entities);
    void updateEntity(CondicionPagoRequest request, @MappingTarget CondicionPago entity);
}
