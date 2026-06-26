package pe.restaurant.activos.mapper;

import org.mapstruct.Mapper;
import pe.restaurant.activos.dto.AfPrimaDevengoResponse;
import pe.restaurant.activos.entity.AfPrimaDevengo;

import java.util.List;

@Mapper(componentModel = "spring")
public interface AfPrimaDevengoMapper {

    AfPrimaDevengoResponse toResponse(AfPrimaDevengo entity);

    List<AfPrimaDevengoResponse> toResponseList(List<AfPrimaDevengo> entities);
}
