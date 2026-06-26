package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.SunatCubsoRequest;
import pe.restaurant.core.dto.SunatCubsoResponse;
import pe.restaurant.core.entity.SunatCubso;

import java.util.List;

@Mapper(componentModel = "spring")
public interface SunatCubsoMapper {
    SunatCubso toEntity(SunatCubsoRequest request);
    SunatCubsoResponse toResponse(SunatCubso entity);
    List<SunatCubsoResponse> toResponseList(List<SunatCubso> entities);
    void updateEntity(SunatCubsoRequest request, @MappingTarget SunatCubso entity);
}
