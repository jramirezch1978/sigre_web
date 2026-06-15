package com.sigre.produccion.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import com.sigre.produccion.dto.request.OrdenTrabajoRequest;
import com.sigre.produccion.dto.response.OtAdministracionInfo;
import com.sigre.produccion.dto.response.OtTipoInfo;
import com.sigre.produccion.dto.response.OrdenTrabajoResponse;
import com.sigre.produccion.dto.response.SucursalInfo;
import com.sigre.produccion.entity.OrdenTrabajo;

import java.util.List;

@Mapper(componentModel = "spring")
public interface OrdenTrabajoMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "codigo", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    OrdenTrabajo toEntity(OrdenTrabajoRequest request);

    @Mapping(target = "sucursal", expression = "java(mapSucursal(entity.getSucursalId()))")
    @Mapping(target = "otTipo", expression = "java(mapOtTipo(entity.getOtTipoId()))")
    @Mapping(target = "otAdministracion", expression = "java(mapOtAdministracion(entity.getOtAdministracionId()))")
    OrdenTrabajoResponse toResponse(OrdenTrabajo entity);

    List<OrdenTrabajoResponse> toResponseList(List<OrdenTrabajo> entities);

    default SucursalInfo mapSucursal(Long id) {
        return id != null ? new SucursalInfo(id, null) : null;
    }

    default OtTipoInfo mapOtTipo(Long id) {
        return id != null ? new OtTipoInfo(id, null, null) : null;
    }

    default OtAdministracionInfo mapOtAdministracion(Long id) {
        return id != null ? new OtAdministracionInfo(id, null, null) : null;
    }

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "codigo", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(OrdenTrabajoRequest request, @MappingTarget OrdenTrabajo entity);
}
