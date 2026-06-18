package pe.restaurant.compras.mapper;

import org.mapstruct.BeanMapping;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;
import pe.restaurant.compras.dto.TipoEntidadContribuyenteRequest;
import pe.restaurant.compras.dto.TipoEntidadContribuyenteResponse;
import pe.restaurant.compras.entity.TipoEntidadContribuyente;

import java.util.List;

@Mapper(componentModel = "spring")
public interface TipoEntidadContribuyenteMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    TipoEntidadContribuyente toEntity(TipoEntidadContribuyenteRequest request);

    TipoEntidadContribuyenteResponse toResponse(TipoEntidadContribuyente entity);

    List<TipoEntidadContribuyenteResponse> toResponseList(List<TipoEntidadContribuyente> entities);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    void updateEntity(TipoEntidadContribuyenteRequest request, @MappingTarget TipoEntidadContribuyente entity);
}
