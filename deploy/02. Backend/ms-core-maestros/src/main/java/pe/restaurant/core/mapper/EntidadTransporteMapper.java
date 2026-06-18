package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.BeanMapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;
import pe.restaurant.core.dto.EntidadTransporteRequest;
import pe.restaurant.core.dto.EntidadTransporteResponse;
import pe.restaurant.core.entity.EntidadTransporte;

import java.util.List;

@Mapper(componentModel = "spring")
public interface EntidadTransporteMapper {
    EntidadTransporte toEntity(EntidadTransporteRequest request);
    EntidadTransporteResponse toResponse(EntidadTransporte entity);
    List<EntidadTransporteResponse> toResponseList(List<EntidadTransporte> entities);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    void updateEntity(EntidadTransporteRequest request, @MappingTarget EntidadTransporte entity);
}
