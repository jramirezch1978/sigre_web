package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.ParametroSistemaRequest;
import pe.restaurant.core.dto.ParametroSistemaResponse;
import pe.restaurant.core.entity.ParametroSistema;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ParametroSistemaMapper {
    ParametroSistema toEntity(ParametroSistemaRequest request);
    ParametroSistemaResponse toResponse(ParametroSistema entity);
    List<ParametroSistemaResponse> toResponseList(List<ParametroSistema> entities);
    void updateEntity(ParametroSistemaRequest request, @MappingTarget ParametroSistema entity);
}
