package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.EjercicioPeriodoRequest;
import pe.restaurant.core.dto.EjercicioPeriodoResponse;
import pe.restaurant.core.entity.EjercicioPeriodo;

import java.util.List;

@Mapper(componentModel = "spring")
public interface EjercicioPeriodoMapper {
    EjercicioPeriodo toEntity(EjercicioPeriodoRequest request);
    EjercicioPeriodoResponse toResponse(EjercicioPeriodo entity);
    List<EjercicioPeriodoResponse> toResponseList(List<EjercicioPeriodo> entities);
    void updateEntity(EjercicioPeriodoRequest request, @MappingTarget EjercicioPeriodo entity);
}
