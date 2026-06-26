package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import pe.restaurant.core.dto.NumTablasRequest;
import pe.restaurant.core.dto.NumTablasResponse;
import pe.restaurant.core.entity.NumTablas;

import java.util.List;

@Mapper(componentModel = "spring")
public interface NumTablasMapper {
    NumTablas toEntity(NumTablasRequest request);
    NumTablasResponse toResponse(NumTablas entity);
    List<NumTablasResponse> toResponseList(List<NumTablas> entities);
}
