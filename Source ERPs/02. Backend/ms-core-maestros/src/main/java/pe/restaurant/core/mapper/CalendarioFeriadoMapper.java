package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.CalendarioFeriadoRequest;
import pe.restaurant.core.dto.CalendarioFeriadoResponse;
import pe.restaurant.core.entity.CalendarioFeriado;

import java.util.List;

@Mapper(componentModel = "spring")
public interface CalendarioFeriadoMapper {
    CalendarioFeriado toEntity(CalendarioFeriadoRequest request);
    CalendarioFeriadoResponse toResponse(CalendarioFeriado entity);
    List<CalendarioFeriadoResponse> toResponseList(List<CalendarioFeriado> entities);
    void updateEntity(CalendarioFeriadoRequest request, @MappingTarget CalendarioFeriado entity);
}
