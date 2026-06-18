package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.CatalogoSunatRequest;
import pe.restaurant.core.dto.CatalogoSunatResponse;
import pe.restaurant.core.entity.CatalogoSunat;

import java.util.List;

@Mapper(componentModel = "spring")
public interface CatalogoSunatMapper {

    CatalogoSunat toEntity(CatalogoSunatRequest request);

    CatalogoSunatResponse toResponse(CatalogoSunat entity);

    List<CatalogoSunatResponse> toResponseList(List<CatalogoSunat> entities);

    void updateEntity(CatalogoSunatRequest request, @MappingTarget CatalogoSunat entity);
}
