package com.sigre.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.BeanMapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;
import com.sigre.core.dto.EntidadTiendaRequest;
import com.sigre.core.dto.EntidadTiendaResponse;
import com.sigre.core.entity.EntidadTienda;

import java.util.List;

@Mapper(componentModel = "spring")
public interface EntidadTiendaMapper {
    EntidadTienda toEntity(EntidadTiendaRequest request);
    EntidadTiendaResponse toResponse(EntidadTienda entity);
    List<EntidadTiendaResponse> toResponseList(List<EntidadTienda> entities);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    void updateEntity(EntidadTiendaRequest request, @MappingTarget EntidadTienda entity);
}
