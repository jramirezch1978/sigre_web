package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.MarcaRequest;
import pe.restaurant.core.dto.MarcaResponse;
import pe.restaurant.core.entity.Marca;

import java.util.List;

@Mapper(componentModel = "spring")
public interface MarcaMapper {
    Marca toEntity(MarcaRequest request);
    MarcaResponse toResponse(Marca entity);
    List<MarcaResponse> toResponseList(List<Marca> entities);
    void updateEntity(MarcaRequest request, @MappingTarget Marca entity);
}
