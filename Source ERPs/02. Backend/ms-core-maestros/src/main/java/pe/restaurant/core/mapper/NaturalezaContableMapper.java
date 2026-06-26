package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.NaturalezaContableRequest;
import pe.restaurant.core.dto.NaturalezaContableResponse;
import pe.restaurant.core.entity.NaturalezaContable;

import java.util.List;

@Mapper(componentModel = "spring")
public interface NaturalezaContableMapper {
    NaturalezaContable toEntity(NaturalezaContableRequest request);
    NaturalezaContableResponse toResponse(NaturalezaContable entity);
    List<NaturalezaContableResponse> toResponseList(List<NaturalezaContable> entities);
    void updateEntity(NaturalezaContableRequest request, @MappingTarget NaturalezaContable entity);
}
