package com.sigre.compras.mapper;

import org.mapstruct.BeanMapping;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;
import com.sigre.compras.dto.ServicioCatalogoRequest;
import com.sigre.compras.dto.ServicioCatalogoResponse;
import com.sigre.compras.entity.ServicioCatalogo;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ServicioCatalogoMapper {

    @Mapping(target = "id", ignore = true)
    ServicioCatalogo toEntity(ServicioCatalogoRequest request);

    ServicioCatalogoResponse toResponse(ServicioCatalogo entity);

    List<ServicioCatalogoResponse> toResponseList(List<ServicioCatalogo> entities);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    @Mapping(target = "id", ignore = true)
    void updateEntity(ServicioCatalogoRequest request, @MappingTarget ServicioCatalogo entity);
}
