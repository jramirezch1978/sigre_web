package com.sigre.compras.mapper;

import org.mapstruct.BeanMapping;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;
import com.sigre.compras.dto.ArticuloPrecioPactadoRequest;
import com.sigre.compras.dto.ArticuloPrecioPactadoResponse;
import com.sigre.compras.entity.ArticuloPrecioPactado;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ArticuloPrecioPactadoMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    ArticuloPrecioPactado toEntity(ArticuloPrecioPactadoRequest request);

    ArticuloPrecioPactadoResponse toResponse(ArticuloPrecioPactado entity);

    List<ArticuloPrecioPactadoResponse> toResponseList(List<ArticuloPrecioPactado> entities);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    void updateEntity(ArticuloPrecioPactadoRequest request, @MappingTarget ArticuloPrecioPactado entity);
}
