package pe.restaurant.almacen.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.almacen.dto.AlmacenTacitoRequest;
import pe.restaurant.almacen.dto.AlmacenTacitoResponse;
import pe.restaurant.almacen.entity.AlmacenTacito;

import java.util.List;

@Mapper(componentModel = "spring")
public interface AlmacenTacitoMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    AlmacenTacito toEntity(AlmacenTacitoRequest request);

    AlmacenTacitoResponse toResponse(AlmacenTacito entity);

    List<AlmacenTacitoResponse> toResponseList(List<AlmacenTacito> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(AlmacenTacitoRequest request, @MappingTarget AlmacenTacito entity);
}
