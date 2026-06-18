package pe.restaurant.compras.mapper;

import org.mapstruct.BeanMapping;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;
import pe.restaurant.compras.dto.AprobadorConfiguradoRequest;
import pe.restaurant.compras.dto.AprobadorConfiguradoResponse;
import pe.restaurant.compras.entity.AprobadorConfigurado;

import java.util.List;

@Mapper(componentModel = "spring")
public interface AprobadorConfiguradoMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    AprobadorConfigurado toEntity(AprobadorConfiguradoRequest request);

    AprobadorConfiguradoResponse toResponse(AprobadorConfigurado entity);

    List<AprobadorConfiguradoResponse> toResponseList(List<AprobadorConfigurado> entities);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    void updateEntity(AprobadorConfiguradoRequest request, @MappingTarget AprobadorConfigurado entity);
}
