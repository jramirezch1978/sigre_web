package com.sigre.core.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import com.sigre.core.dto.*;
import com.sigre.core.entity.Departamento;
import com.sigre.core.entity.Distrito;
import com.sigre.core.entity.Pais;
import com.sigre.core.entity.Provincia;

import java.util.List;

@Mapper(componentModel = "spring")
public interface GeografiaMapper {

    PaisResponse toResponse(Pais entity);
    List<PaisResponse> toPaisResponseList(List<Pais> entities);
    Pais toEntity(PaisRequest request);
    void updateEntity(PaisRequest request, @MappingTarget Pais entity);

    DepartamentoResponse toResponse(Departamento entity);
    List<DepartamentoResponse> toDepartamentoResponseList(List<Departamento> entities);
    Departamento toEntity(DepartamentoRequest request);
    void updateEntity(DepartamentoRequest request, @MappingTarget Departamento entity);

    ProvinciaResponse toResponse(Provincia entity);
    List<ProvinciaResponse> toProvinciaResponseList(List<Provincia> entities);
    Provincia toEntity(ProvinciaRequest request);
    void updateEntity(ProvinciaRequest request, @MappingTarget Provincia entity);

    DistritoResponse toResponse(Distrito entity);
    List<DistritoResponse> toDistritoResponseList(List<Distrito> entities);
    Distrito toEntity(DistritoRequest request);
    void updateEntity(DistritoRequest request, @MappingTarget Distrito entity);
}
