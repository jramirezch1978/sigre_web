package com.sigre.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import com.sigre.core.dto.DocTipoRequest;
import com.sigre.core.dto.DocTipoResponse;
import com.sigre.core.entity.DocTipo;

import java.util.List;

@Mapper(componentModel = "spring")
public interface DocTipoMapper {

    DocTipo toEntity(DocTipoRequest request);

    DocTipoResponse toResponse(DocTipo entity);

    List<DocTipoResponse> toResponseList(List<DocTipo> entities);

    void updateEntity(DocTipoRequest request, @MappingTarget DocTipo entity);
}
