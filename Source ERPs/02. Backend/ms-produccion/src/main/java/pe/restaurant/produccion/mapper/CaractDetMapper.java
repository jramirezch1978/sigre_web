package pe.restaurant.produccion.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import pe.restaurant.produccion.dto.request.CaractDetRequest;
import pe.restaurant.produccion.dto.response.CaractDetResponse;
import pe.restaurant.produccion.entity.ArticuloDocTecnicaCaractDet;

import java.util.List;

@Mapper(componentModel = "spring")
public interface CaractDetMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "articuloDocTecnicaId", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    ArticuloDocTecnicaCaractDet toEntity(CaractDetRequest request);

    @Mapping(target = "unidadMedidaCodigo", ignore = true)
    CaractDetResponse toResponse(ArticuloDocTecnicaCaractDet entity);

    List<CaractDetResponse> toResponseList(List<ArticuloDocTecnicaCaractDet> entities);
}
