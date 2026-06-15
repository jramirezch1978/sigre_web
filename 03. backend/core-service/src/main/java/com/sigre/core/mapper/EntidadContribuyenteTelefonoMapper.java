package com.sigre.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.BeanMapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;
import com.sigre.core.dto.EntidadContribuyenteTelefonoRequest;
import com.sigre.core.dto.EntidadContribuyenteTelefonoResponse;
import com.sigre.core.entity.EntidadContribuyenteTelefono;

import java.util.List;

@Mapper(componentModel = "spring")
public interface EntidadContribuyenteTelefonoMapper {
    EntidadContribuyenteTelefono toEntity(EntidadContribuyenteTelefonoRequest request);
    EntidadContribuyenteTelefonoResponse toResponse(EntidadContribuyenteTelefono entity);
    List<EntidadContribuyenteTelefonoResponse> toResponseList(List<EntidadContribuyenteTelefono> entities);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    void updateEntity(EntidadContribuyenteTelefonoRequest request, @MappingTarget EntidadContribuyenteTelefono entity);
}
