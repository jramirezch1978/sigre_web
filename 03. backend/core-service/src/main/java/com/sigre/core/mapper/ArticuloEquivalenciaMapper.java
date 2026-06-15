package com.sigre.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import com.sigre.core.dto.ArticuloEquivalenciaRequest;
import com.sigre.core.dto.ArticuloEquivalenciaResponse;
import com.sigre.core.entity.ArticuloEquivalencia;
import java.util.List;

@Mapper(componentModel = "spring")
public interface ArticuloEquivalenciaMapper {
    ArticuloEquivalencia toEntity(ArticuloEquivalenciaRequest request);
    ArticuloEquivalenciaResponse toResponse(ArticuloEquivalencia entity);
    List<ArticuloEquivalenciaResponse> toResponseList(List<ArticuloEquivalencia> entities);
    void updateEntity(ArticuloEquivalenciaRequest request, @MappingTarget ArticuloEquivalencia entity);
}
