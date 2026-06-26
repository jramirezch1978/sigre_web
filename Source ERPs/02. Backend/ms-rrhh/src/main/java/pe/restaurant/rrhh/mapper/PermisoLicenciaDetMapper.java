package pe.restaurant.rrhh.mapper;

import org.mapstruct.Mapper;
import pe.restaurant.rrhh.dto.response.PermisoLicenciaDetResponse;
import pe.restaurant.rrhh.entity.PermisoLicenciaDet;

import java.util.List;

@Mapper(componentModel = "spring")
public interface PermisoLicenciaDetMapper {

    PermisoLicenciaDetResponse toResponse(PermisoLicenciaDet entity);

    List<PermisoLicenciaDetResponse> toResponseList(List<PermisoLicenciaDet> entities);
}
