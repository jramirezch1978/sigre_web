package pe.restaurant.almacen.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.almacen.dto.UbicacionAlmacenRequest;
import pe.restaurant.almacen.dto.UbicacionAlmacenResponse;
import pe.restaurant.almacen.entity.UbicacionAlmacen;

import java.util.List;

@Mapper(componentModel = "spring")
public interface UbicacionAlmacenMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "almacenId", ignore = true)
    UbicacionAlmacen toEntity(UbicacionAlmacenRequest request);

    UbicacionAlmacenResponse toResponse(UbicacionAlmacen entity);

    List<UbicacionAlmacenResponse> toResponseList(List<UbicacionAlmacen> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "almacenId", ignore = true)
    void updateEntity(UbicacionAlmacenRequest request, @MappingTarget UbicacionAlmacen entity);
}
