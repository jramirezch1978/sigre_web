package pe.restaurant.compras.mapper;

import org.mapstruct.BeanMapping;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;
import pe.restaurant.compras.dto.ArticuloEstructuraRequest;
import pe.restaurant.compras.dto.ArticuloEstructuraResponse;
import pe.restaurant.compras.entity.ArticuloEstructura;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ArticuloEstructuraMapper {

    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    ArticuloEstructura toEntity(ArticuloEstructuraRequest request);

    ArticuloEstructuraResponse toResponse(ArticuloEstructura entity);

    List<ArticuloEstructuraResponse> toResponseList(List<ArticuloEstructura> entities);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateEntity(ArticuloEstructuraRequest request, @MappingTarget ArticuloEstructura entity);
}
