package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.BeanMapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;
import pe.restaurant.core.dto.EntidadTiendaRequest;
import pe.restaurant.core.dto.EntidadTiendaResponse;
import pe.restaurant.core.entity.EntidadTienda;

import java.util.List;

@Mapper(componentModel = "spring")
public interface EntidadTiendaMapper {
    EntidadTienda toEntity(EntidadTiendaRequest request);
    EntidadTiendaResponse toResponse(EntidadTienda entity);
    List<EntidadTiendaResponse> toResponseList(List<EntidadTienda> entities);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    void updateEntity(EntidadTiendaRequest request, @MappingTarget EntidadTienda entity);
}
