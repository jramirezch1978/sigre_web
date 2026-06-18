package pe.restaurant.activos.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import pe.restaurant.activos.dto.AfPolizaSeguroRequest;
import pe.restaurant.activos.dto.AfPolizaSeguroResponse;
import pe.restaurant.activos.entity.AfPolizaSeguro;

import java.util.List;

@Mapper(componentModel = "spring")
public interface AfPolizaSeguroMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    AfPolizaSeguro toEntity(AfPolizaSeguroRequest request);

    AfPolizaSeguroResponse toResponse(AfPolizaSeguro entity);

    List<AfPolizaSeguroResponse> toResponseList(List<AfPolizaSeguro> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "flagEstado", ignore = true)
    void updateEntity(AfPolizaSeguroRequest request, @MappingTarget AfPolizaSeguro entity);
}
