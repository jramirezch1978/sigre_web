package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.MotivoNotaRequest;
import pe.restaurant.core.dto.MotivoNotaResponse;
import pe.restaurant.core.entity.MotivoNota;

import java.util.List;

@Mapper(componentModel = "spring")
public interface MotivoNotaMapper {
    MotivoNota toEntity(MotivoNotaRequest request);
    MotivoNotaResponse toResponse(MotivoNota entity);
    List<MotivoNotaResponse> toResponseList(List<MotivoNota> entities);
    void updateEntity(MotivoNotaRequest request, @MappingTarget MotivoNota entity);
}
