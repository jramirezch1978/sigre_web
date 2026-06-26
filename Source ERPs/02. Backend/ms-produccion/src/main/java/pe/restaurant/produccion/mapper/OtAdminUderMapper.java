package pe.restaurant.produccion.mapper;

import org.mapstruct.Mapper;
import pe.restaurant.produccion.dto.response.OtAdminUderResponse;
import pe.restaurant.produccion.entity.OtAdminUder;

import java.util.List;

@Mapper(componentModel = "spring")
public interface OtAdminUderMapper {

    OtAdminUderResponse toResponse(OtAdminUder entity);

    List<OtAdminUderResponse> toResponseList(List<OtAdminUder> entities);
}
