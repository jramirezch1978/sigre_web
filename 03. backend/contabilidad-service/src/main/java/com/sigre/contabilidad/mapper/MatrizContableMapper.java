package com.sigre.contabilidad.mapper;

import org.mapstruct.IterableMapping;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.Named;
import com.sigre.contabilidad.dto.request.MatrizContableDetRequest;
import com.sigre.contabilidad.dto.request.MatrizContableRequest;
import com.sigre.contabilidad.dto.response.MatrizContableDetResponse;
import com.sigre.contabilidad.dto.response.MatrizContableResponse;
import com.sigre.contabilidad.entity.MatrizContable;
import com.sigre.contabilidad.entity.MatrizContableDet;

import java.util.List;

@Mapper(componentModel = "spring")
public interface MatrizContableMapper {

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    @Mapping(target = "detalles", ignore = true)
    MatrizContable toEntity(MatrizContableRequest request);

    @Named("withDetalles")
    @Mapping(target = "detalles", source = "detalles")
    MatrizContableResponse toResponse(MatrizContable entity);

    @Named("withoutDetalles")
    @Mapping(target = "detalles", ignore = true)
    MatrizContableResponse toResponseWithoutDetalles(MatrizContable entity);

    @IterableMapping(qualifiedByName = "withoutDetalles")
    List<MatrizContableResponse> toResponseListWithoutDetalles(List<MatrizContable> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    @Mapping(target = "detalles", ignore = true)
    void updateEntity(MatrizContableRequest request, @MappingTarget MatrizContable entity);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "matrizContable", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    MatrizContableDet toDetalleEntity(MatrizContableDetRequest request);

    @Mapping(target = "matrizContableId", source = "matrizContable.id")
    MatrizContableDetResponse toDetalleResponse(MatrizContableDet entity);

    List<MatrizContableDetResponse> toDetalleResponseList(List<MatrizContableDet> entities);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "matrizContable", ignore = true)
    @Mapping(target = "createdBy", ignore = true)
    @Mapping(target = "fecCreacion", ignore = true)
    @Mapping(target = "updatedBy", ignore = true)
    @Mapping(target = "fecModificacion", ignore = true)
    void updateDetalleEntity(MatrizContableDetRequest request, @MappingTarget MatrizContableDet entity);
}
