package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.NumeradorRequest;
import pe.restaurant.core.dto.NumeradorResponse;
import pe.restaurant.core.entity.Numerador;

import java.util.List;

@Mapper(componentModel = "spring")
public interface NumeradorMapper {
    Numerador toEntity(NumeradorRequest request);
    NumeradorResponse toResponse(Numerador entity);
    List<NumeradorResponse> toResponseList(List<Numerador> entities);
    void updateEntity(NumeradorRequest request, @MappingTarget Numerador entity);
}
