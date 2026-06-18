package pe.restaurant.compras.mapper;

import org.mapstruct.BeanMapping;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;
import pe.restaurant.compras.dto.CompradorRequest;
import pe.restaurant.compras.dto.CompradorResponse;
import pe.restaurant.compras.entity.Comprador;

import java.util.List;

@Mapper(componentModel = "spring")
public interface CompradorMapper {

    @Mapping(target = "id", ignore = true)
    Comprador toEntity(CompradorRequest request);

    CompradorResponse toResponse(Comprador entity);

    List<CompradorResponse> toResponseList(List<Comprador> entities);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    @Mapping(target = "id", ignore = true)
    void updateEntity(CompradorRequest request, @MappingTarget Comprador entity);
}
