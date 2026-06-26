package pe.restaurant.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import pe.restaurant.core.dto.CatalogoSunatDetRequest;
import pe.restaurant.core.dto.CatalogoSunatDetResponse;
import pe.restaurant.core.entity.CatalogoSunatDet;

import java.util.List;

@Mapper(componentModel = "spring")
public interface CatalogoSunatDetMapper {

    CatalogoSunatDet toEntity(CatalogoSunatDetRequest request);

    CatalogoSunatDetResponse toResponse(CatalogoSunatDet entity);

    List<CatalogoSunatDetResponse> toResponseList(List<CatalogoSunatDet> entities);

    void updateEntity(CatalogoSunatDetRequest request, @MappingTarget CatalogoSunatDet entity);
}
