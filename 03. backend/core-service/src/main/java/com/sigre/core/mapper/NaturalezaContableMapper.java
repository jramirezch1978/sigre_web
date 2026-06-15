package com.sigre.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import com.sigre.core.dto.NaturalezaContableRequest;
import com.sigre.core.dto.NaturalezaContableResponse;
import com.sigre.core.entity.NaturalezaContable;

import java.util.List;

@Mapper(componentModel = "spring")
public interface NaturalezaContableMapper {
    NaturalezaContable toEntity(NaturalezaContableRequest request);
    NaturalezaContableResponse toResponse(NaturalezaContable entity);
    List<NaturalezaContableResponse> toResponseList(List<NaturalezaContable> entities);
    void updateEntity(NaturalezaContableRequest request, @MappingTarget NaturalezaContable entity);
}
