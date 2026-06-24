package com.sigre.almacen.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import com.sigre.almacen.dto.AlmacenRequest;
import com.sigre.almacen.dto.AlmacenResponse;
import com.sigre.almacen.entity.Almacen;

import java.util.List;

@Mapper(componentModel = "spring")
public interface AlmacenMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", source = "flagEstado", defaultValue = "1")
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    Almacen toEntity(AlmacenRequest request);

    @Mapping(target = "sucursalNombre", ignore = true)
    @Mapping(target = "almacenTipoNombre", ignore = true)
    @Mapping(target = "centrosCostoNombre", ignore = true)
    @Mapping(target = "proveedorNombre", ignore = true)
    @Mapping(target = "createdByUsuario", ignore = true)
    @Mapping(target = "updatedByUsuario", ignore = true)
    AlmacenResponse toResponse(Almacen entity);

    List<AlmacenResponse> toResponseList(List<Almacen> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", source = "flagEstado", defaultValue = "1")
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(AlmacenRequest request, @MappingTarget Almacen entity);
}
