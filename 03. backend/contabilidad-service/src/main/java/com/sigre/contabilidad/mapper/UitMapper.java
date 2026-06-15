package com.sigre.contabilidad.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import com.sigre.contabilidad.dto.request.UitRequest;
import com.sigre.contabilidad.dto.response.UitResponse;
import com.sigre.contabilidad.entity.Uit;

import java.util.List;

@Mapper(componentModel = "spring")
public interface UitMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    Uit toEntity(UitRequest request);

    UitResponse toResponse(Uit entity);

    List<UitResponse> toResponseList(List<Uit> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(UitRequest request, @MappingTarget Uit entity);
}
