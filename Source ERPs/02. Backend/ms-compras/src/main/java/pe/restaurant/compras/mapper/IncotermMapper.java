package pe.restaurant.compras.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.compras.dto.IncotermRequest;
import pe.restaurant.compras.dto.IncotermResponse;
import pe.restaurant.compras.entity.Incoterm;

import java.util.List;

@Mapper(componentModel = "spring")
public interface IncotermMapper {
    Incoterm toEntity(IncotermRequest request);
    IncotermResponse toResponse(Incoterm entity);
    List<IncotermResponse> toResponseList(List<Incoterm> entities);
    void updateEntity(IncotermRequest request, @MappingTarget Incoterm entity);
}
