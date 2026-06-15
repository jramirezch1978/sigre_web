package com.sigre.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import com.sigre.core.dto.TiposImpuestoRequest;
import com.sigre.core.dto.TiposImpuestoResponse;
import com.sigre.core.entity.TiposImpuesto;

import java.util.List;

@Mapper(componentModel = "spring")
public interface TiposImpuestoMapper {

    TiposImpuesto toEntity(TiposImpuestoRequest request);

    TiposImpuestoResponse toResponse(TiposImpuesto entity);

    List<TiposImpuestoResponse> toResponseList(List<TiposImpuesto> entities);

    void updateEntity(TiposImpuestoRequest request, @MappingTarget TiposImpuesto entity);
}
