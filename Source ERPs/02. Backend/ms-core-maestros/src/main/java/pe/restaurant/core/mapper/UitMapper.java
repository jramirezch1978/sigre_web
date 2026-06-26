package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.UitRequest;
import pe.restaurant.core.dto.UitResponse;
import pe.restaurant.core.entity.Uit;

import java.util.List;

@Mapper(componentModel = "spring")
public interface UitMapper {
    Uit toEntity(UitRequest request);
    UitResponse toResponse(Uit entity);
    List<UitResponse> toResponseList(List<Uit> entities);
    void updateEntity(UitRequest request, @MappingTarget Uit entity);
}
