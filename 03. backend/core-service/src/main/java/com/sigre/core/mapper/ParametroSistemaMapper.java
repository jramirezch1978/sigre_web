package com.sigre.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import com.sigre.core.dto.ParametroSistemaRequest;
import com.sigre.core.dto.ParametroSistemaResponse;
import com.sigre.core.entity.ParametroSistema;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ParametroSistemaMapper {
    ParametroSistema toEntity(ParametroSistemaRequest request);
    ParametroSistemaResponse toResponse(ParametroSistema entity);
    List<ParametroSistemaResponse> toResponseList(List<ParametroSistema> entities);
    void updateEntity(ParametroSistemaRequest request, @MappingTarget ParametroSistema entity);
}
