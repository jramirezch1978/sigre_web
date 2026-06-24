package com.sigre.rrhh.mapper;

import org.mapstruct.Mapper;
import com.sigre.rrhh.dto.response.PermisoLicenciaDetResponse;
import com.sigre.rrhh.entity.PermisoLicenciaDet;

import java.util.List;

@Mapper(componentModel = "spring")
public interface PermisoLicenciaDetMapper {

    PermisoLicenciaDetResponse toResponse(PermisoLicenciaDet entity);

    List<PermisoLicenciaDetResponse> toResponseList(List<PermisoLicenciaDet> entities);
}
