package com.sigre.almacen.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import com.sigre.almacen.dto.AlmacenTipoRequest;
import com.sigre.almacen.dto.AlmacenTipoResponse;
import com.sigre.almacen.entity.AlmacenTipo;

import java.util.List;

@Mapper(componentModel = "spring")
public interface AlmacenTipoMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", constant = "1")
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    AlmacenTipo toEntity(AlmacenTipoRequest request);

    @Mapping(target = "createdByUsuario", ignore = true)
    @Mapping(target = "updatedByUsuario", ignore = true)
    AlmacenTipoResponse toResponse(AlmacenTipo entity);

    List<AlmacenTipoResponse> toResponseList(List<AlmacenTipo> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(AlmacenTipoRequest request, @MappingTarget AlmacenTipo entity);
}
